-module(spawnfest_team_controller, [Req, SessionID]).
-compile(export_all).
-include("ranks.hrl").

index('GET', []) ->
    Teams = boss_db:find(team, []),
    {ok, [{teams, Teams}]};

index('GET', [Id]) ->
    ok.

create('GET', []) ->
    Ranks = boss_db:find(rank, [], all, 0, value, num_ascending),
    {ok, [{ranks, Ranks}]};
create('POST', []) ->
    Name = Req:post_param("name"),
    Project = Req:post_param("project"),
    RankId = Req:post_param("rank_id"),
    Now = calendar:local_time_to_universal_time(calendar:local_time()),

    case (team:new(id, Name, Project, RankId, Now)):save() of
	{ok, SavedTeam} ->
	    {redirect, [{action, "index"}]};
	{error, Reason} ->
	    Reason
    end.

view('GET', [Id]) ->
    Team = boss_db:find(Id),
    {ok, [{team, Team}]}.

edit('GET', [Id]) ->
    Team = boss_db:find(Id),
    Ranks = boss_db:find(rank, [], all, 0, value, num_ascending),
    {ok, [{team, Team}, {ranks, Ranks}]};
edit('POST', [Id]) ->
    OldTeam = boss_db:find(Id),
    NewTeam = OldTeam:set([
			   {name, Req:post_param("name")},
			   {project, Req:post_param("project")},
			   {rank_id, Req:post_param("rank_id")}
			  ]),
    case NewTeam:save() of
	{ok, SavedTeam} ->

	    Msg = case OldTeam:name() =:= NewTeam:name() of
		      true ->
			  lists:flatten(io_lib:format("Team '~s' successfully updated",[ OldTeam:name()]));
		      false ->
			  lists:flatten(io_lib:format("Team '~s' successfully renamed and updated to team '~s'", [OldTeam:name(), NewTeam:name()]))
		  end,
	    boss_flash:add(SessionID, success, Msg),
	    {redirect, [{action, "index"}]};
	{error, Reason} ->
	    Reason
    end.

%% Triggered by Javascript function
destroy('DELETE', [Id]) ->
    boss_db:delete(Id),
    Teams = boss_db:find(team, []),
    {render_other, [{action, "index"}], [{teams, Teams}]},
    {json, [{status, ok}]}.

addmember('GET', [Id]) ->
    Team = boss_db:find(Id),
    M = boss_db:find(member, []),
    Members = only_unassigned_members(M),
    {ok, [{team, Team}, {members, Members}]}.

only_unassigned_members(Members) ->
    unassigned(Members, []).

unassigned([], Unassigned) ->
    lists:reverse(Unassigned);
unassigned([H | Members], Unassigned) ->
    case H:team_id() of
	[] ->
	    unassigned(Members, [H|Unassigned]);
	Id ->
	    unassigned(Members, Unassigned)
    end.
