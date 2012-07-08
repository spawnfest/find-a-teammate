-module(spawnfest_main_controller, [Req, SessionID]).
-compile(export_all).

before_(Function) ->
    error_logger:info_msg("Function: ~p~n", [Function]),
    security:logged_in(SessionID, "main/index").

%% Secured
index('GET', [], Security) ->
    {ok, [{security, Security}]}.

%% No secured, see before_ function above
about('GET', []) ->
    {ok,[]}.

notfound('GET', []) ->
    {ok,[]}.

%% This is needed in case it's happening inside the "Security"
notfound('GET', [], Security) ->
    {ok,[]}.
