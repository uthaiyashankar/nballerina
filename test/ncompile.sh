#!/bin/sh
JAVA_COMMAND=`./findJava.sh`
new=""
for f in ../compiler/testSuite/[VPO]*.bal; do
    ll=`basename $f .bal`.ll
    test -f ll/$ll || new="$new $f"
done
$JAVA_COMMAND -jar ../compiler/target/bin/nballerina.jar --outDir . $new
