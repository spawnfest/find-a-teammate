-module(seed_db).
-export([admins/0]).
-export([ranks/0]).


%% Seeding the database with initial values.

%% These supersecure password hashes are sha256("test") :)
admins() ->
    (admin:new(id, "Kai", "Janson", "kotedo@gmail.com", "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08", true)):save(),
    (admin:new(id, "Sergey", "Ivanov", "iseiryu@gmail.com", "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08", true)):save().

ranks() ->
    [ (rank:new(id, Name, Value)):save() || {Name, Value} <- [{"Rookie", 0}, {"Basic", 1}, {"Advanced", 2}] ].
