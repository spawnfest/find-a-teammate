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
    GitHubAccount = 

    {redirect, [{action, "thankyou"}]}

edit('GET', [Id]) ->
    ok;
edit('POST', [Id]) ->
    ok.

destroy('GET', [Id]) ->
    ok.

thankyou('GET', []) ->
    ok.
