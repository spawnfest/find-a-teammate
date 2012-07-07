-module(member, [Id, TeamId, First, Last, Email, Country, State, GitAccount, Rank, PasswordHash]).
-compile(export_all).

-belongs_to(team).
