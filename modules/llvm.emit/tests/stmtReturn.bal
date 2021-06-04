import ballerina/file;
import ballerina/test;

function stmtReturn() returns Module {
    Builder builder = new ();
    Module m = new ();
    Function foo1 = m.insertFunction("@foo1", {returnType: "i64"});
    BasicBlock bb1 = foo1.appendBasicBlock();
    builder.positionAtEnd(bb1);
    builder.returnValue(constInt(42));

    Function foo2 = m.insertFunction("@foo2", {returnType: "i64"});
    BasicBlock bb2 = foo2.appendBasicBlock();
    builder.positionAtEnd(bb2);
    Value R1 = builder.alloca("i64");
    Value c = constInt(42);
    builder.store(c, R1);
    Value R2 = builder.load(R1);
    builder.returnValue(R2);
    return m;
}

@test:Config {}
function testStmtReturn() returns error? {
    string expectedOutput = check file:joinPath(file:getCurrentDir(), "modules", "llvm.emit", "tests", "testOutputs", "stmt_return.ll");
    string outputPath = check file:joinPath(file:getCurrentDir(), "modules", "llvm.emit", "tests", "testOutputs", "tmp_stmt_return.ll");
    check buildOutput(stmtReturn(), outputPath);
    test:assertEquals(compareFiles(expectedOutput, outputPath), true);
    check file:remove(outputPath);
}
