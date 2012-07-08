-module(spawnfest_member_controller, [Req, SessionID]).
-compile(export_all).

index('GET', []) ->
    Members = boss_db:find(member, []),
    [Assigned, Unassigned] = separate_members(Members),
    %% error_logger:info_msg("We have ~p Assigned and ~p Unassigned Members", [length(Assigned), length(Unassigned)]),
    Teams = boss_db:find(team, []),
    {ok, [{assigned, Assigned}, {unassigned, Unassigned}, {teams, Teams}, {members, Members}]}.

create('GET', []) ->
    %% TODO: Find teams that has less than 4 team members
    Teams = boss_db:find(team, []),
    {ok, [{teams, Teams}]};
create('POST', []) ->
    First = Req:post_param("first"),
    Last = Req:post_param("last"),
    Email = Req:post_param("email"),
    City = Req:post_param("city"),
    Country = Req:post_param("country"),
    State = Req:post_param("state"),
    GitAccount = Req:post_param("github"),
    Rank = (boss_db:find_first(rank, [{name, "Rookie"}])):id(),
    TeamId = Req:post_param("team"),
    
    PasswordHash = mochihex:to_hex(crypto:sha256(Req:post_param("password"))),
    NewMember = member:new(id, TeamId, First, Last, Email, City, Country, State, GitAccount, Rank, PasswordHash),

    case NewMember:save() of
	{ok, SavedMember} ->
	    boss_flash:add(SessionID, success, "Thank you for signing up"),
	    boss_session:set_session_data(SessionID, thankyou_id, SavedMember:id()),
	    case SavedMember:team_id() of
		[] ->
		    TeamsNow = [binary_to_list(X:name()) || X <- boss_db:find(team, [])],
		    (noteam:new(id, Email, TeamsNow)):save(),
		    {redirect, [{action, "thankyou"}]};
		Id ->
		    {redirect, [{action, "thankyou"}]};
		{error, Reason} ->
		    boss_flash:add(SessionID, error, "Signup failed.  Please try again later"),
		    Reason
	    end
    end.

edit('GET', [Id]) ->
    ok;
edit('POST', [Id]) ->
    ok.

destroy('GET', [Id]) ->
    ok.

thankyou('GET', []) ->
    Member = boss_db:find( boss_session:get_session_data(SessionID, thankyou_id)),
    {ok, [{member, Member}]}.

separate_members(Members) ->
    separate_members(Members, [], []).

separate_members([], Assigned, Unassigned) ->
    [lists:reverse(Assigned), lists:reverse(Unassigned)];
separate_members([H | Members], Assigned, Unassigned) ->
    case H:team_id() of
	[] ->
%%	    error_logger:info_msg("H is empty ~p~n", [H]),
	    separate_members(Members, Assigned, [H|Unassigned]);
	Id ->
%%	    error_logger:info_msg("H is assigned ~p~n", [H]),
	    separate_members(Members, [H|Assigned], Unassigned)
    end.
