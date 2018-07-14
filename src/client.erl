-module(client).
-export([start/3, askForKey/2]).

start(ServerPID, NumberOfClients, NumberOfKs) ->
	[spawn(client, askForKey, [ServerPID, NumberOfKs]) || _ <- lists:seq(0, NumberOfClients - 1)],
	ok.


askForKey(ServerPID, NumberOfKs) ->
	random:seed(erlang:monotonic_time()),
	MyK = random:uniform(NumberOfKs - 1),
	ServerPID ! {self(), MyK},
	io:format("~p search ~p~n", [self(), MyK]),
	receive
		{FromPID, {K, V}} ->
			io:format("~p got ~p from ~p~n", [self(), {K, V}, FromPID]);
		false ->
			io:format("~p got false~n", [self()]);
		_ ->
			io:format("ERROR: default case from ~p~n", [self()])
	end.
