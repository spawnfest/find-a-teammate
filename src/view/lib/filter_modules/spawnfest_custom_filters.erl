-module(spawnfest_custom_filters).
-compile(export_all).

% put custom filters in here, e.g.
%
% my_reverse(Value) ->
%     lists:reverse(binary_to_list(Value)).
%
% "foo"|my_reverse   => "foo"
localtime(Value) ->
    {{Y,M,D},{H,I,S}} = calendar:now_to_local_time(Value),
    lists:flatten(io_lib:format("~2..0B/~2..0B/~B ~2..0B:~2..0B:~2..0B", [M,D,Y,H,I,S])).

