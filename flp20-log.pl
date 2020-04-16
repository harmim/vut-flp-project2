/*
  Project: VUT FIT FLP 2. Project (Logic) - Turing Machine
  Author: Dominik Harmim <xharmi00@stud.fit.vutbr.cz>
  Year: 2020
  Description: Simulation of a given nondeterministic Turing machine.
*/

:- dynamic rule/4.

%%%%%%%%%%%%%%%%%%%%%%% Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Simulates a Turing machine from the standard input.
simulate :-
  prompt(_, ''),
  read_lines(L), !,
  parse_input(L, Tape), ! -> (
    is_initial(S),
    run([S|Tape], Tapes), ! -> (
      write_tapes(Tapes), cleanup, halt
    ) ; (
      writeln('Error: the Turing machine terminates abnormally.'), cleanup, fail
    )
  ) ; (
    writeln('Error: invalid format of input Turing machine.'), cleanup, fail
  ).

run([H|T], Tapes) :- is_initial(H), run([H|T], [], Tapes), !.
run(Tape, Tapes, NewTapes) :-
  actual(Tape, S, _), is_final(S), !, append(Tapes, [Tape], NewTapes).
run(Tape, Tapes, NewTapes) :-
  actual(Tape, S, SYMB), rule(S, SYMB, S1, SYMB1),
  modify(Tape, S1, SYMB1, NewTape), append(Tapes, [Tape], CurrentNewTapes),
  run(NewTape, CurrentNewTapes, NewTapes).

modify([SYMB, S|Tape], NewS, NewSYMB, [NewS, SYMB|Tape]) :-
  is_state(S), is_left(NewSYMB).
modify([S], NewS, NewSYMB, [SYMB, NewS]) :-
  is_state(S), is_right(NewSYMB), is_blank(SYMB), !.
modify([S, SYMB|Tape], NewS, NewSYMB, [SYMB, NewS|Tape]) :-
  is_state(S), is_right(NewSYMB).
modify([S], NewS, NewSYMB, [NewS, NewSYMB]) :- is_state(S), !.
modify([S, _|Tape], NewS, NewSYMB, [NewS, NewSYMB|Tape]) :- is_state(S), !.
modify([S|Tape], NewS, NewSYMB, [S|NewTape]) :-
  modify(Tape, NewS, NewSYMB, NewTape).

actual([S], S, SYMB) :- is_state(S), is_blank(SYMB), !.
actual([S, SYMB|_], S, SYMB) :- is_state(S), !.
actual([_|Tape], S, SYMB) :- actual(Tape, S, SYMB).

cleanup :- retractall(rule(_, _, _, _)).

%%%%%%%%%%%%%%%%%%%%%%% Turing Machine Validation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parse_input([Tape], Tape) :-
  forall(member(S, Tape), (is_symbol(S); is_blank(S))), !.
parse_input([[S1, SEP, SYMB1, SEP, S2, SEP, SYMB2]|T], Tape) :-
  is_state(S1), is_state(S2),
  (is_symbol(SYMB1); is_blank(SYMB1)),
  (is_symbol(SYMB2); is_blank(SYMB2); is_left(SYMB2); is_right(SYMB2)),
  is_rule_separator(SEP), !,
  assertz(rule(S1, SYMB1, S2, SYMB2)),
  parse_input(T, Tape).

% Checks whether a given atom is a valid state of a Turing machine.
is_state(S) :-
  memberchk(S, [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
    'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  ]).

% Checks whether a given atom is a valid symbol of a Turing machine.
is_symbol(S) :-
  memberchk(S, [
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
    'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
  ]).

% Checks whether a given atom is the valid blank symbol.
is_blank(' ').

% Checks whether a given state is the initial state.
is_initial('S').

% Checks whether a given state is the final state.
is_final('F').

% Checks whether a given atom is a rule separator.
is_rule_separator(' ').

% Checks whether a given atom is the left shift symbol.
is_left('L').

% Checks whether a given atom is the right shift symbol.
is_right('R').

%%%%%%%%%%%%%%%%%%%%%%% I/O Operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reads lines from the standard input.
read_lines(L) :-
  read_line(L1, C), !, (C == end_of_file, L = []; read_lines(LL), L = [L1|LL]).

% Reads a single line from the standard input.
read_line(L, C) :-
  get_char(C), !, (is_eof_eol(C), L = []; read_line(LL, _), L = [C|LL]).

% Checks whether a given symbol is either the end of file symbol or the end of
% line symbol.
is_eof_eol(end_of_file).
is_eof_eol(C) :- char_code(C, 10).

% Writes a list of lines to the standard output.
write_tapes([]).
write_tapes([H|T]) :- forall(member(S, H), write(S)), nl, write_tapes(T).
