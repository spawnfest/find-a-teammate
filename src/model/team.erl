-module(team, [Id, Name, Project, RankId, CreatedAt]).
-compile(export_all).

-has({members, many}).
-belongs_to(rank).
