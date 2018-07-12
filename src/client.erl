-module(client).


%% N: number of clients
start(ServerPID, N, NumberOfKs) ->
	[spawn(client, askForKey, [ServerPID, NumberOfKs]) || I <- lists:seq(0, N - 1)].


askForKey(ServerPID, NumberOfKs) ->
	MyK = random:uniform(NumberOfKs - 1),
	ServerPID ! MyK,
	receive
		{K, V} ->
			io:format("we received value ~p for searching key ~p~n", [V, K]);
		false ->
			io:format("we couldn't get anything for searching key ~p~n", [MyK];
		_ ->
			io:format("ERROR: default case")
	end
