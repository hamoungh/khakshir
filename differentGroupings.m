syms d1 d2 d3 d4 real;
lambda=[.1 .2 .3 .4]
D=[1 1 2 3]

findClusteringError(lambda,D,[d1 d2 d3 d4]);
[d1 d2 d3] [d4]
[d1] [d2 d3 d4]
[d1 d2 d4] [d3]
[d1 d3 d4] [d2]
[d1 d2] [d3 d4]
[d1 d3] [d2 d4]
[d1 d4] [d2 d3]
[d1 d2] [d3] [d4]
[d1] [d2 d3] [d4]
[d1] [d2] [d3 d4]
[d1 d4] [d2] [d3]
[d1] [d2] [d3] [d4]
