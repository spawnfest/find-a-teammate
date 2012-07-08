-module(member, [Id, TeamId, First, Last, Email, City, Country, State, GitAccount, Rank, PasswordHash]).
-compile(export_all).

-belongs_to(team).
