# bio-aggr-tda
Summer Research - Topological data analysis of biological aggregation
To run scripts that use javaPlex to calculate persistent homology, 
download javaplex, and it to your matlab path. Finally, copy the provided
copy of load_javaplex.m to your javaplex install. Our version, imports
using absolute paths, and doesn't clear the workspace, which seems to
be necessary to use javaplex from functions/use javaplex in a different
directory.
