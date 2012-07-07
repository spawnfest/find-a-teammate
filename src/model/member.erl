-module(member, [Id, TeamId, First, Last, Email, Country, State, GitAccount, Rank]).
-compile(export_all).

-belongs_to(team).
