-module(spawnfest_team_controller, [Req, SessionID]).
-compile(export_all).
-include("ranks.hrl").

index('GET', []) ->
    Teams = boss_db:find(team, []),
    {ok, [{teams, Teams}]}.

create('GET', []) ->
    ok;
create('POST', []) ->
    Name = Req:post_param("name"),
    Project = Req:post_param("project"),
    RankId = (boss_db:find_first(rank, [{name, "Rookie"}])):id(),
    Now = calendar:local_time_to_universal_time(calendar:local_time()),

    case (team:new(id, Name, Project, RankId, Now)):save() of
	{ok, SavedTeam} ->
	    {redirect, [{action, "index"}]};
	{error, Reason} ->
	    Reason
    end.
