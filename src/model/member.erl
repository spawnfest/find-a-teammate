-module(member, [Id, TeamId, First, Last, Email, City, Country, State, GitAccount, Rank, PasswordHash]).
-compile(export_all).

-belongs_to(team).

validation_tests() ->
	[{fun() -> length(Email) > 0 end,
		"Please enter an email"},
	{fun() -> length(PasswordHash) > 0 end,
		"Please enter a password"},
	{fun() -> boss_db:find(member, [{email, Email}], 1) == [] end,
		"Please choose a different email"}].
