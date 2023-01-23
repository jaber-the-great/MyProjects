## Python
#### General:
* Dynamically typed
* Has interpreter rather than compiler
* Bytecode: 113 opcodes (42 with arguments/operands and 71 without)

#### CPython:
* The reference implementation of python
* Cpython compiles Python code into bytecode before interpreting it
* makes use of a global interpreter lock (GIL) on each CPython interpreter process
  * Means it is single threaded
* The GIL makes python unsuitable for CPU-intensive algorithms which run across multiple cores
* Decode and dispatch 
* Fat bytecode
* More work done in handler of each bytecode