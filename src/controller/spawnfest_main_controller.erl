-module(spawnfest_main_controller, [Req, SessionID]).
-compile(export_all).

before_(_) ->
    security:logged_in(SessionID).

index('GET', [], Security) ->
    ok.

about('GET', []) ->
	{ok,[]}.

notfound('GET', []) ->
	{ok,[]}.
