import semtype.core;

type Module table<TypeDef> key(name); 

type TypeDef record {|
    readonly string name;
    TypeDesc td;
    core:SemType? semType = ();
    int cycleDepth = -1;
|};

type TypeDesc LeafTypeDesc|BinaryTypeDesc|ConstructorTypeDesc|TypeDescRef|SingletonTypeDesc;

type ConstructorTypeDesc ListTypeDesc|MappingTypeDesc|FunctionTypeDesc|ErrorTypeDesc;

type ListTypeDesc record {|
    TypeDesc[] members;
    TypeDesc rest;
    core:ListDefinition? def = ();
|};

type FieldDesc record {|
    string name;
    TypeDesc typeDesc;
|};

type MappingTypeDesc record {|
    FieldDesc[] fields;
    TypeDesc rest;
    core:MappingDefinition? def = ();
|};

type FunctionTypeDesc record {|
    // XXX need to handle rest type
    TypeDesc[] args;
    TypeDesc ret;
    core:FunctionDefinition? def = ();
|};

type ErrorTypeDesc record {|
    TypeDesc detail;
|};

type BinaryOp "|" | "&";

type BinaryTypeDesc record {|
    BinaryOp op;
    TypeDesc left;
    TypeDesc right;
|};

type TypeDescRef record {|
    string ref;
|};

type SingletonTypeDesc  record {|
    (string|int|boolean) value;
|};

type LeafTypeDesc "any"|"byte"|"boolean"|"decimal"|"error"|"float"|"handle"|"int"|"json"
                  |"never"|"readonly"|"string"|"typedesc"|"xml"|"()";

function preparse(string str) returns Module|error {
    Tokenizer tok = new(str);
    check tok.advance();
    return parseModule(tok);
}

function parseModule(Tokenizer tok) returns Module|error {
    Module mod = table [];
    while tok.current != () {
        if tok.current == "type" {
            check tok.advance();
            Token? t = tok.current;
            if t is [IDENTIFIER, string] {
                // JBUG cannot do t[0]
                var [_, name] = t;
                check tok.advance();
                TypeDesc td = check parseTypeDesc(tok);
                mod.add({name, td});
                check tok.expect(";");
                continue;
            }
            else {
                return parseError(tok); 
            }
        }
        // XXX handle "const"
        else {
            return parseError(tok);
        }
    }
    return mod;
}

function parseTypeDesc(Tokenizer tok) returns TypeDesc|error {
    if tok.current == "function" {
        return parseFunction(tok);
    }
    return parseUnion(tok);
}

function parseUnion(Tokenizer tok) returns TypeDesc|error {
    TypeDesc td = check parseIntersection(tok);
    while tok.current == "|" {
        check tok.advance();
        TypeDesc right = check parseIntersection(tok);
        BinaryTypeDesc bin = { op: "|", left: td, right };
        td = bin;
    }
    return td;
}

function parseIntersection(Tokenizer tok) returns TypeDesc|error {
    TypeDesc td = check parsePostfix(tok);
    while tok.current == "&" {
        check tok.advance();
        TypeDesc right = check parsePostfix(tok);
        BinaryTypeDesc bin = { op: "&", left: td, right };
        td = bin;
    }
    return td;
}

function parsePostfix(Tokenizer tok) returns TypeDesc|error {
    TypeDesc td = check parsePrimary(tok);
    while true {
        if tok.current == "?" {
            check tok.advance();
            BinaryTypeDesc bin =  { op: "|", left: td, right: "()" };
            td = bin;
        }
        else if tok.current == "[" {
            check tok.advance();
            check tok.expect("]");
            ListTypeDesc list = { members: [], rest: td };
            td = list;
        }
        else {
            break;
        }
    }
    return td;
}

// Tokenizer is on first token of the type descriptor
// Afterwards it is on the token immediately following the type descriptor
function parsePrimary(Tokenizer tok) returns TypeDesc|error {
    Token? cur = tok.current;
    match cur {
        "(" => {
            check tok.advance();
            if tok.current == ")" {
                check tok.advance();
                return "()";
            }
            TypeDesc td = check parseTypeDesc(tok);
            check tok.expect(")");
            return td;
        }
        "boolean"
        | "decimal"
        | "float"
        | "string"
        | "xml"
        | "typedesc"
        | "handle"
        | "any"
        | "never"
        | "json"
        | "byte"
        |  "readonly" => {
            check tok.advance();
            // JBUG should not need cast
            return <LeafTypeDesc>cur;
        }
        "[" => {
            return parseTuple(tok);
        }
        "map" => {
            check tok.advance();
            return <MappingTypeDesc>{ rest: check parseTypeParam(tok), fields: [] };
        }
        "error" => {
            check tok.advance();
            if tok.current != "<" {
                return "error";
            }
            return <ErrorTypeDesc>{ detail: check parseTypeParam(tok) };
        }        
        "record" => {
            return parseRecord(tok);         
        }
        "int" => {
            // XXX handle int:Signed32 etc
            check tok.advance();
            return "int";
        }
        // JBUG language server sometimes flags `var ref`
        // here as something like
        // "some variable cannot repeat in a match pattern"
        [IDENTIFIER, var ref] => {
            check tok.advance();
            return <TypeDescRef>{ ref };
        }
        [STRING_LITERAL, var str] => {
            check tok.advance();
            return <SingletonTypeDesc>{ value: str };
        }
        "true" => {
            check tok.advance();
            return <SingletonTypeDesc>{ value: true };
        }
        "false" => {
            check tok.advance();
            return <SingletonTypeDesc>{ value: false };
        }
    }
    return parseError(tok);
}

function parseTypeParam(Tokenizer tok) returns TypeDesc|error {
    check tok.expect("<");
    TypeDesc td = check parseTypeDesc(tok);
    check tok.expect(">");
    return td;
}

// current token is "function"
function parseFunction(Tokenizer tok) returns TypeDesc|error {
    // skip "function"
    check tok.advance();
    check tok.expect("(");
    TypeDesc[] args = [];
    while true {
        if tok.current == ")" {
            break;
        }
        args.push(check parseTypeDesc(tok));
        if tok.current == "," {
            check tok.advance();
        }
    }
    // on ")"
    check tok.advance();
    TypeDesc ret;
    if tok.current == "returns" {
        check tok.advance();
        ret = check parseTypeDesc(tok);
    }
    else {
        ret = "()";
    }
    return <FunctionTypeDesc>{ args, ret };
}

// current token is []
function parseTuple(Tokenizer tok) returns ListTypeDesc|error {
    TypeDesc[] members = [];
    TypeDesc rest = "never";
    check tok.advance();
    if tok.current != "]" {
        while true {
            TypeDesc td = check parseTypeDesc(tok);
            if tok.current == "..." {
                rest = td;
                check tok.advance();
            }
            else if tok.current == "," {
                check tok.advance();
                continue;
            }
            if tok.current == "]" {
                break;
            }
            return parseError(tok);
        }
    }
    check tok.advance();
    return {members, rest};
}

function parseRecord(Tokenizer tok) returns MappingTypeDesc|error {
    check tok.advance();
    check tok.expect("{|");
    FieldDesc[] fields = [];
    TypeDesc? rest = ();
    while tok.current != "|}" {
        if !(rest is ()) {
            return parseError(tok);
        }
        TypeDesc td = check parseTypeDesc(tok);
        match tok.current {
            "..." => {
                rest = td;
                check tok.advance();
            }
            [IDENTIFIER, var name] => {
                check tok.advance();
                fields.push({name, typeDesc: td});
            }
            _ => {
                return parseError(tok);
            }
        }
        check tok.expect(";");
    }
    check tok.advance();
    return { fields, rest: rest ?: "never" };
}

function parseError(Tokenizer tok) returns error {
    string message = "parse error";
    Token? t = tok.current;
    if t is string {
        // JBUG cast needed
        message += " at '" + <string>t + "'";
    }
    return tok.err(message);
}