-module(find_elem).
-export([index_of/2,
		at/2]).





index_of(Elem, List) ->
	index_of(Elem, List, 1).
index_of(_, [], _) ->
	not_found;
index_of(_Elem, [_Elem | _], Index) ->
	Index;
index_of(_Elem, [_Head | Tail], Index) ->
	index_of(_Elem, Tail, Index + 1).




at(Index, List) ->
	at(Index, List, 1).
at(_, [], _) ->
	out_of_range;
at(_Index, [Elem | _], _Index) ->
	Elem;
at(_Index, [_Head | Tail], _Counter) ->
	at(_Index, Tail, _Counter + 1).
