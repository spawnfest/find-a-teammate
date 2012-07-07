-module(spawnfest_member_controller, [Req, SessionID]).
-compile(export_all).

index('GET', []) ->
    ok.

create('GET', []) ->
    %% TODO: Find teams that has less than 4 team members
    Teams = boss_db:find(team, []),
    {ok, [{teams, Teams}]};
create('POST', []) ->
    First = Req:post_param("first"),
    Last = Req:post_param("last"),
    Email = Req:post_param("email"),
    Country = Req:post_param("country"),
    State = Req:post_param("state"),
    GitAccount = Req:post_param("github"),
    Rank = (boss_db:find_first(rank, [{name, "Rookie"}])):id(),
    TeamId = Req:post_param("team"),
    
    Passwordhash = mochihex:to_hex(crypto:sha256(Req:post_param("password"))),
    NewMember = member:new(id, TeamId, First, Last, Email, Country, State, GitAccount, Rank, PasswordHash),

    case NewMember:save() of
	{ok, SavedMember} ->
	    boss_flash:add(SessionID, success, "Thank you for signing up"),
	    {redirect, [{action, "thankyou"}]};
	{error, Reason} ->
	    boss_flash:add(SessionID, error, "Signup failed.  Please try again later"),
	    Reason
    end.

edit('GET', [Id]) ->
    ok;
edit('POST', [Id]) ->
    ok.

destroy('GET', [Id]) ->
    ok.

thankyou('GET', []) ->
    ok.
