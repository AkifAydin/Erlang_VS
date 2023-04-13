-module(erlang_learning).
%-export([hello_world/0,my_length/1]).
-compile([export_all, nowarn_export_all, nowarn_unused_function]).

%This Method is a implementation of the Qsort Algorithm
qsort([]) -> [];
qsort([Pivot|T]) -> qsort([X || X <- T, X < Pivot]) %New List X containing T Elems smaller than Pivot
	++ [Pivot] ++ %Concatenating smaller List with Pivot and bigger List
qsort([X || X <- T, X >= Pivot]). %New List X containing T Elems bigger than Pivot

%This Method gives the Max of two values
max(X, Y) when X > Y -> X;
max(_, Y) -> Y.

%This Method gives the biggest elem in List
maxElemList(List) -> maxElemList(List,0).
maxElemList([],N) -> N; 
maxElemList([Head|Tail],N) when Head > N -> maxElemList(Tail,Head);
maxElemList([_Head|Tail],N) -> maxElemList(Tail,N).

%This Method deletes the first Element of the list
deleteFirst(List) when List == [] -> [];
deleteFirst([_Head|Tail]) -> Tail.

%This Method deletes the Last Element of the list
deleteLastElement(List) -> deleteLastElement(List, []).
deleteLastElement(List, List) when List ==[] -> [];
deleteLastElement([Head|Tail], List) when Tail =/= []-> deleteLastElement(Tail, List++[Head]);
deleteLastElement([_Head|_Tail], List) -> List. %When Iterated through whole List, return new list

%This is a Method for calculating the sum of the elements of a list
sum([]) -> 0;
sum([Head|Tail]) -> Head + sum(Tail).
%sum(L) -> sum(L, 0).
%sum([], N) -> N;
%sum([H|T], N) -> sum(T,H+N).

%This Method writes Hello World in 3 different ways
hello_world() -> 
	io:fwrite("Hello World~n"),
	io:fwrite([104,101,108,108,111,32,119,111,114,108,100]),
	io:fwrite("~n"),
	io:fwrite([$h,$e,$l,$l,$o,$ ,$w,$o,$r,$l,$d]),
	io:fwrite("~n").
	
%This Method implements the given method "length/1"
my_length([]) -> 0;
my_length([_Head|Tail]) -> 1 + my_length(Tail).

%This Method implements the given method "reverse_list/2"
reverse_list(List) ->
    reverse_list(List, []).

reverse_list([], Acc) ->
    Acc;  %This is the Clausel for the empty List
reverse_list([Head|Tail], Acc) ->
    reverse_list(Tail, [Head|Acc]).  %this is the clausel for an non empty List

%This Method finds the element in the middle
center_elem([]) -> [];
center_elem(List) -> pick_elem(List, round(my_length(List)/2)-1).

pick_elem([Head|_Tail], 0) -> [Head];
pick_elem([_Head|Tail], NmbOfElementsTillMid) -> pick_elem(Tail, NmbOfElementsTillMid-1).

%This Method concatenates two Lists
addTogetherLists(Lst,Lst2) -> Lst++Lst2.

%This Method concatenates each elements of one list with each element of another list
addEachElement(Lst,Lst2) -> addEachElement(Lst, Lst2, []).
addEachElement([Head|Tail], Lst2, NewList) when Tail == [] -> NewList ++ [Head] ++ Lst2;
addEachElement(Lst, [Head2|Tail2], NewList) when Tail2 == [] -> NewList ++ [Head2] ++ Lst;
addEachElement([Head|Tail], [Head2|Tail2], NewList) ->
	addEachElement(Tail, Tail2, NewList ++ [Head] ++ [Head2]).

%Aufgabe.1
%This Method checks if the given Element is a Member of the InputList
member(_Member, []) -> false;
member(Member, [Head|_Tail]) when Member == Head -> true;
member(Member, [_Head|Tail]) -> member(Member, Tail).

%Aufgabe.2
%Erstezt Element E in der Liste L mit S an der Position a
substitute(E, S, L, P) when P == a -> findAll(E, S, L, []); %alle
substitute(E, S, L, P) when P == e -> findFirst(E, S, L, []); %erstes
substitute(E, S, L, P) when P == l -> findLast(E, S, L, [], []). %letztes

findAll(_E, _S, [], NewList) -> NewList;
findAll(E, S, [Head|Tail], NewList) when E == Head -> findAll(E, S, Tail, NewList ++ [S]);
findAll(E, S, [Head|Tail], NewList) -> findAll(E, S, Tail, NewList ++ [Head]).

findFirst(_E, _S, [], NewList) -> NewList;
findFirst(E, S, [Head|Tail], NewList) when E == Head -> NewList++[S]++Tail;
findFirst(E, S, [Head|Tail], NewList) -> findFirst(E, S, Tail, NewList ++ [Head]).

findLast(_E, _S, [], _OldList, NewList) -> NewList;
findLast(E, S, [Head|Tail], OldList, _NewList) when E == Head -> findLast(E, S, Tail, OldList++[Head], OldList ++ [S]);
findLast(E, S, [Head|Tail], OldList, _NewList) -> findLast(E, S, Tail, OldList++[Head], OldList ++ [Head]).

%Aufgabe.3 -----------------------------------------------------------------------------------
%This Method find the occurences of each element and puts them out as "Maps" inside a list

% MainList = [1,2,3,4,2,3,4,3,4], SearchL= [1,2,3,4] resultList should be = [{1,1},{2,2},{3,3},{4,3}]
compress(MainList) -> compress(MainList, listOfElems(MainList), []).
compress(_MainList, [], ResultList) -> ResultList;
compress(MainList, [Head2|Tail2], ResultList) -> 
	compress(MainList, Tail2, ResultList++[{Head2,countMemberInList(MainList,Head2)}]).

%Hilfsmethode um keine Doppelten mehr in der Liste zu haben, sondern nur die Vorkommen 
% [1,2,3,4,2,3,4,3,4] -> [1,2,3,4]
listOfElems(List) -> listOfElems(List, []).
listOfElems([], NewListOfElems) -> NewListOfElems;
listOfElems([Head|Tail], NewListOfElems) -> 
	case member(Head, NewListOfElems) of
		true ->	
			listOfElems(Tail, NewListOfElems);
		false ->	
		listOfElems(Tail, NewListOfElems ++ [Head])
	end.

%Hilfsmethode um die Anzahl der Vorkommnisse eines Elementes in der Liste zu Zählen
% [1,2,3,4,2,3,4,3,4],4 -> 3
countMemberInList(List, Elem) -> countMemberInList(List, Elem, 0).
countMemberInList([], _Elem, Counter) -> Counter;
countMemberInList([Head|Tail], Elem, Counter) when Head == Elem-> countMemberInList(Tail, Elem, Counter+1);
countMemberInList([_Head|Tail], Elem, Counter) -> countMemberInList(Tail, Elem, Counter).

% Berechnung des ggT nach Euler
%                                      A1
ggt(A,B) when is_integer(A) and (A >= 0) and 
is_integer(B) and (B >= 0) -> ggtI(A,B);
ggt(A,B) -> io:format(">>Fehler in ggt: Parameter ~p,~p sind 
nicht beide eine positive natürliche 
Zahl!\n\n",[A,B]),0.

%    AF1     A2
ggtI(A,A) -> A;
%                AF2           A3        AF1-true
ggtI(A,B) when (B > A) -> ggtI(B,A);
% A4 AF1/AF2-true
ggtI(A,B) -> ggtI(A - B, B).

month_length(Year, Month) ->
    %% All years divisible by 400 are leap
    %% Years divisible by 100 are not leap (except the 400 rule above)
    %% Years divisible by 4 are leap (except the 100 rule above)
    Leap = if
        trunc(Year / 400) * 400 == Year ->
            leap;
        trunc(Year / 100) * 100 == Year ->
            not_leap;
        trunc(Year / 4) * 4 == Year ->
            leap;
        true ->
            not_leap
    end,  
    case Month of
        sep -> 30;
        apr -> 30;
        jun -> 30;
        nov -> 30;
        feb when Leap == leap -> 29;
        feb -> 28;
        jan -> 31;
        mar -> 31;
        may -> 31;
        jul -> 31;
        aug -> 31;
        oct -> 31;
        dec -> 31;
		X -> io:format("FEHLER: kein gültiger Monat: ~p~n", [X]),0
    end.
	