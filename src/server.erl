%% USAGE:
%% Pid = spawn(server, start, [NumberOfKeys, NumbersInEachPartition]).


-module(server).
-export([start/2, proc/2]).
-import(find_elem, [at/2]).

%% our starting point to this application
start(NumberOfKeys, PartitionSize) when NumberOfKeys >= 0 ->
	Plist = [spawn(server, proc, [K, K + PartitionSize - 1]) || K <- lists:seq(0, NumberOfKeys - 1, PartitionSize)],
	messageHandler(Plist, PartitionSize).

%% to determine whose going to respond to what searched element
messageHandler(Plist, PartitionSize) ->
	receive
		{FromPID, K} ->
			Process = at((K div PartitionSize) + 1, Plist), %% find the process that has the appropriate key-value
			Process ! {FromPID, K},
			messageHandler(Plist, PartitionSize);
		_ ->
			wrong_message_format,
			messageHandler(Plist, PartitionSize)
	end.

%% key-value storages
proc(First, Last) ->
	random:seed(erlang:monotonic_time()),
	KVlist = [{K, random:uniform(20)} || K <- lists:seq(First, Last)],
	getValue(KVlist).


%% then we listen to the clients for the search keys
getValue(KVlist) ->
	receive
		{FromPID, K} ->
			FromPID ! {self(), lists:keyfind(K, 1, KVlist)},
			getValue(KVlist);
		_ ->
			false,
			getValue(KVlist)
	end.
