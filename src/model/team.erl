-module(team, [Id, Name, Project, Rank, CreatedAt]).
-compile(export_all).

-has({members, many}).
