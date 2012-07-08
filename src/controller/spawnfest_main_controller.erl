-module(spawnfest_main_controller, [Req, SessionID]).
-compile(export_all).

before_(Function) ->
    error_logger:info_msg("Function: ~p~n", [Function]),
    case Function of
	"about" -> ok;
	AnythingElse ->
	    security:logged_in(SessionID)
    end.

%% Secured
index('GET', [], Security) ->
    ok.

%% No secured, see before_ function above
about('GET', []) ->
    {ok,[]}.

notfound('GET', []) ->
    {ok,[]}.

%% This is needed in case it's happening inside the "Security"
notfound('GET', [], Security) ->
    {ok,[]}.
