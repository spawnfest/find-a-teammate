-module(spawnfest_security_controller, [Req, SessionID]).
-compile(export_all).

-default_action(login).

login('GET', []) ->
    ok;
login('POST', []) ->
    Email = Req:post_param("email"),
    PasswordHash = mochihex:to_hex(crypto:sha256(Req:post_param("password"))),
    error_logger:info_msg("Email: ~p~nPass : ~p~n", [Email, PasswordHash]),

    case boss_db:find(admin, [{email, Email}, {password_hash, PasswordHash}, {active, true}]) of
	[] ->
	    boss_flash:add(SessionID, error, "Invalid username/password."),
	    {redirect, [{action, "login"}]};
	[Admin] ->
	    boss_session:set_session_data(SessionID, user_id, Admin:id()),
	    {redirect, [{controller, "main"}, {action, "index"}]}
    end.

logout('GET', []) ->
    error_logger:info_msg("logout!!!~n"),
    boss_session:delete_session(SessionID),
    {redirect, [{action, "login"}]}.
