# bio-aggr-tda
Summer Research - Topological data analysis of biological aggregation
To run scripts that use javaPlex to calculate persistent homology, 
download javaplex, and it to your matlab path. Finally, copy the provided
copy of load_javaplex.m to your javaplex install. Our version, imports
using absolute paths, and doesn't clear the workspace, which seems to
be necessary to use javaplex from functions/use javaplex in a different
directory.

Command to compile java:
javac -classpath /Users/dbjellan/Desktop/matlab_examples/lib/javaplex.jar:/Users/dbjellan/Desktop/commons-lang3-3.4/commons-lang3-3.4.jar VeitorisRipsTimeStrapper.java

Command to switch to java 1.7
how to switch permenantly?
export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)

http://math.mit.edu/~dspivak/CT4S.pdf
