-module(security).
-export([logged_in/2]).

logged_in(SessionID, Function) ->
    case boss_session:get_session_data(SessionID, user_id) of
	undefined ->
		case Function of
			"about" -> ok;
			"notfound" -> ok;
			"main/index" -> ok;
			"signup" -> ok;
		AnythingElse ->
	    	{redirect, [{controller, "security"}, {action, "login"}]}
    	end;	    
	UserId ->
	    {ok, boss_db:find(UserId)}
    end.
