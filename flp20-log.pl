/*
  Project: VUT FIT FLP 2. Project (Logic) - Turing Machine
  Author: Dominik Harmim <xharmi00@stud.fit.vutbr.cz>
  Year: 2020
  Description: Simulation of a given nondeterministic Turing machine.
*/

% This dynamic predicate corresponds to the rule of a Truing machine.
% rule(?State, ?Symbol, ?NewState, ?NewSymbol)
:- dynamic rule/4.

%%%%%%%%%%%%%%%%%%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Simulates a Turing machine given from the standard input.
% simulate/0
simulate :-
  prompt(_, ''),
  read_lines(L), !, parse(L, Tape), ! -> (
    init(S), run([S|Tape], Tapes), ! -> write_tapes(Tapes), free, halt
    ; writeln('Error: the Turing machine terminates abnormally.'), free, fail
  ) ; writeln('Error: invalid format of the input Turing machine.'), free, fail.

% Runs the simulation of a Turing machine with a given initial tape and
% returns a sequence of tapes used during the computation.
% run(+Tape, ?Tapes)
run([H|T], Tapes) :- init(H), run([H|T], [], Tapes).
% run(+Tape, +Tapes, ?NewTapes)
run(Tape, Tapes, NewTapes) :-
  actual(Tape, S, _), final(S), !, append(Tapes, [Tape], NewTapes).
run(Tape, Tapes, NewTapes) :-
  actual(Tape, S, Symb),
  rule(S, Symb, NewS, NewSymb),
  applay(Tape, NewS, NewSymb, NewTape),
  append(Tapes, [Tape], CurrentNewTapes),
  run(NewTape, CurrentNewTapes, NewTapes).

% Applies the rule to the current tape and returns a modified tape.
% modify(+Tape, ?NewState, +NewSymbol, ?NewTape)
applay([S|_], _, NewSymb, _) :- state(S), left(NewSymb), !, fail.
applay([Symb, S|Tape], NewS, NewSymb, [NewS, Symb|Tape]) :-
  state(S), left(NewSymb), !.
applay([S], NewS, NewSymb, [Symb, NewS]) :-
  state(S), right(NewSymb), blank(Symb), !.
applay([S, Symb|Tape], NewS, NewSymb, [Symb, NewS|Tape]) :-
  state(S), right(NewSymb), !.
applay([S], NewS, NewSymb, [NewS, NewSymb]) :- state(S), !.
applay([S, _|Tape], NewS, NewSymb, [NewS, NewSymb|Tape]) :- state(S), !.
applay([Symb|Tape], NewS, NewSymb, [Symb|NewTape]) :-
  applay(Tape, NewS, NewSymb, NewTape).

% Finds out a current state and a symbol under the reading head.
% actual(+Tape, ?State, ?Symbol)
actual([S], S, Symb) :- state(S), blank(Symb), !.
actual([S, Symb|_], S, Symb) :- state(S), !.
actual([_|Tape], S, Symb) :- actual(Tape, S, Symb).

% Cleans up created dynamic rules.
% free/0
free :- retractall(rule(_, _, _, _)).

%%%%%%%%%%%%%%%%%%%%%%% Turing Machine Validation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parses and validates an input Turing machine and returns an input tape.
% parse(?Lines, ?Tape)
parse([Tape], Tape) :- forall(member(C, Tape), symbol(C); blank(C)), !.
parse([[S1, Sep, Symb1, Sep, S2, Sep, Symb2]|T], Tape) :-
  state(S1), state(S2),
  (symbol(Symb1); blank(Symb1)),
  (symbol(Symb2); blank(Symb2); left(Symb2); right(Symb2)),
  sep(Sep),
  !,
  assertz(rule(S1, Symb1, S2, Symb2)),
  parse(T, Tape).

% Checks whether a given character is a valid state of a Turing machine.
% state(?Char)
state(C) :-
  member(C, [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
    'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  ]).

% Checks whether a given character is a valid symbol of a Turing machine.
% symbol(?Char)
symbol(C) :-
  member(C, [
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
    'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
  ]).

% Checks whether a given character is the blank symbol.
% blank(?Char)
blank(' ').

% Checks whether a given state is the initial state.
% init(?State)
init('S').

% Checks whether a given state is the final state.
% final(?State)
final('F').

% Checks whether a given character is a rule separator.
% sep(?Char)
sep(' ').

% Checks whether a given character is the left shift symbol.
% left(?Char)
left('L').

% Checks whether a given character is the right shift symbol.
% right(?Char)
right('R').

%%%%%%%%%%%%%%%%%%%%%%% I/O Operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reads lines from the standard input.
% read_lines(-Lines)
read_lines(L) :-
  read_line(H, C), (C == end_of_file, L = [], !; read_lines(T), L = [H|T]).

% Reads a single line and the first character from the standard input.
% read_line(-Line, -Char)
read_line(L, H) :-
  get_char(H), (eofeol(H), L = [], !; read_line(T, _), L = [H|T]).

% Checks whether a given character is either the end of file symbol or the end
% of line symbol.
% eofeol(?Char)
eofeol(end_of_file).
eofeol(C) :- char_code(C, 10).

% Writes a list of tapes to the standard output.
% write_tapes(+Tapes)
write_tapes([]) :- !.
write_tapes([H|T]) :- forall(member(C, H), write(C)), nl, write_tapes(T).
