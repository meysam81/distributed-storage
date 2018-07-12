-module(server).
-export([start/2,
		 proc/2]).



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
-start(FromPID, N) when N >= 0 ->
	Plist = [spawn(server, proc, [K, K + 999] || K <- lists:seq(0, N - 1, 1000)],
	messageHandler(FromPID, Plist).

%% to determine whose going to respond to what key search
-messageHandler(FromPID, Plist) ->
	receive K ->
		Process = yechizi(Plist), %% find the process that has the appropriate key-value
		Process ! {FromPID, K},
		messageHandler(FromPID, Plist)
	end.


%% upper and lower band of the partitions are passed to this function
%% which in term starts as a process
-proc(First, Last) ->
	KVlist = [{K, 1} || K <- lists:seq(First, Last)],
	getValue(KVlist).



%% then we listen to the clients for the search keys
-getValue(KVlist) ->
	receive {FromPID, K} ->
		FromPID ! lists:keyfind(K, 1, KVlist),
		getValue(KVlist)
	end.
