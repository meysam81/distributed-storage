-module(server).
-export([start/2,
		 proc/2]).
-import(find_elem, [at/2]).



%% to use this program, spawn the 'start' function and store its PID
%% then send a message to that PID using the following pattern:
%%
%% USAGE:
%% Pid = spawn(server, start, [self(), 100000]). %% which is 100k nodes
%% Pid ! 10358. %% which in turn searches the storage for a specific key number
%% receive X -> X end. %% to print the return message of the searched key




%% this is to store key-value pairs into processes that start with spawn(M, F, A)
%% we pass key-value pairs at the beginning of the spawn
%% processes are what so called partitions
%% the storage is a TupleList as in [{k1, v1}, {k2, v2}, ... , {kn, vn}]




%% the starting point of this module is start function
%% we pass the number of keys we want to have in the storage
%% N: number of keys in the storage unit
start(N, PartitionSize) when N >= 0 ->
	Plist = [spawn(server, proc, [K, K + PartitionSize - 1]) || K <- lists:seq(0, N - 1, PartitionSize)],
	messageHandler(Plist, PartitionSize).

%% to determine whose going to respond to what key search
messageHandler(Plist, PartitionSize) ->
	receive {FromPID, K} ->
		Process = at((K div PartitionSize) + 1, Plist), %% find the process that has the appropriate key-value
		Process ! {FromPID, K},
		messageHandler(Plist, PartitionSize)
	end.


%% upper and lower band of the partitions are passed to this function
%% which in term starts as a process
proc(First, Last) ->
	KVlist = [{K, random:uniform(20)} || K <- lists:seq(First, Last)],
	getValue(KVlist).



%% then we listen to the clients for the search keys
getValue(KVlist) ->
	receive {FromPID, K} ->
		FromPID ! lists:keyfind(K, 1, KVlist),
		getValue(KVlist)
	end.
