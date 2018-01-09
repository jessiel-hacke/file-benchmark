Deprecated

## TM I/O Bench

### Dependencies

Docker >= 1.12

### Running

Build docker's image

`docker build -t files-benchmark . `

Execute

`docker run -v $(pwd):/file-bench -ti files-benchmark`


### Referencia de resultado:

```
➔ ./bench.sh
===================================================
Ruby benchmark: File read(only read)
Ruby version: ruby 2.3.2p217 (2016-11-15 revision 56796) [x86_64-linux]
===================================================


Bench #1: Full file read:
Time: 0.14
Memory: 128.55 MB
Shell execution time: 0.395765 seconds

Bench #2: Streaming file read:
Time: 0.19
Memory: 10.31 MB
Shell execution time: 0.425338 seconds

===================================================
Crystal benchmark: File read(only read)
Crystal version: Crystal 0.19.4 [7f82f79] (2016-10-07)
===================================================


Bench #1: Full file read:
Time: 0.1074681
Memory: 128.84 MB
Shell execution time: 0.834745 seconds

Bench #2: Streaming file read:
Time: 1.3312754
Memory: 0.49 MB
Shell execution time: 2.106627 seconds

===================================================
Lua benchmark: File read(only read)
Lua version: Lua 5.3.3  Copyright (C) 1994-2016 Lua.org, PUC-Rio
===================================================


Bench #1: Full file read:
Memory: 128.6 MB  1
Time: 0.208937  1
Shell execution time: 0.273067 seconds

Bench #2: Streaming file read:
Memory: 0.18 MB 1
Time: 0.464157  1
Shell execution time: 0.505675 seconds

```
