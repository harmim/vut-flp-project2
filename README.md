# Functional and Logic Programming - Logic Project
## Turing Machine

##### Author: Dominik Harmim <xharmi00@stud.fit.vutbr.cz>

## Build
Using the command `make`, the project is compiled using the `swipl` compiler
and a program `flp20-log` is created.

## Run
After the compilation (see the section above), it can be run as follows:
```bash
$ ./flp20-log < input-file > output-file
```
`input-file` is the name of an input file with a Turing machine and with an
initial tape in a specified format. `output-file` is the name of the output
file where a sequence of tapes used during the computation is going to be
stored.

## Description
The program simulates a given nondeterministic Turing machine. An input
specification of the machine and an initial tape are first parsed and their
format is validated. In case the format is invalid, an error message is
printed to the standard output and the program is terminated. Otherwise,
all the given rules are added to the program as dynamic predicates and the
simulation with the initial tape is started. Prolog tries to find a sequence
of tapes that leads to the final state according to the stored rules. The
simulation fails if there is no such sequence that leads to the final state. If
the simulation succeeds, the sequence of tapes used during the computation is
printed to the standard output.

## Tests
In the directory `tests`, there are some testing input files (`.in` extension)
and corresponding outputs (`.out` extension). There is the a description
of these files (`#` denotes the blank symbol):
- `invalid-format` - invalid format of an input file (there are some illegal
  characters). Running time: 0.014s.
- `abnormal-termination` - abnormal termination of a Turing machine (there is
  no final state). Running time: 0.020s.
- `ref` - a reference example. Running time: 0.013s.
- `ab` - accepts the following language `#(a|b)^n#`. Running time: 0.116s.
- `an-bn` - modifies the tape from the format `#a^n#` to the format `#b^n#`.
  Running time: 3.863s.
- `a2n-abn` - modifies the tape from the format `#a^(2n)#` to the format
  `#(ab)^n#`. Running time: 1.039s.
- `anbncn` - accepts the following language `#a^nb^nc^n#` (the global stack
  limit likely needs to be increase). Running time: 29.203s.
