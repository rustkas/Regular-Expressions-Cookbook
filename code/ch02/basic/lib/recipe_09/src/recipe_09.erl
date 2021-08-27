-module(recipe_09).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_01_test() ->
    Expected = [["Janet"]],
    Text = "Her name is Janet",
    Regex = "\\b(Jane|Janet)\\b",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [global, {capture, first, list}]),
    ?assertEqual(Expected, Result).

research_01_02_test() ->
    Expected = [["Jane"]],
    Text = "Her name is Janet",
    Regex = "\\bMary|Jane|Sue\\b",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [global, {capture, first, list}]),
    ?assertEqual(Expected, Result).

research_01_03_test() ->
    Expected = [["Jane"]],
    Text = "Her name is Janet",
    Regex = "\\bMary|Jane|Sue\\b",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [global, {capture, first, list}]),
    ?assertEqual(Expected, Result).

research_02_01_test() ->
    Expected = "9999-99-99",
    Text = "9999-99-99",
    Regex = "\\b\\d\\d\\d\\d-\\d\\d-\\d\\d\\b",
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_02_02_test() ->
    Expected = "9999-99-99",
    Text = "9999-99-99",
    Regex = "\\b(\\d\\d\\d\\d)-(\\d\\d)-(\\d\\d)\\b",
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_02_03_test() ->
    Expected = ["2008-05-24", "2008", "05", "24"],
    Text = "2008-05-24",
    Regex = "\\b(\\d\\d\\d\\d)-(\\d\\d)-(\\d\\d)\\b",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [{capture, all, list}]),
    ?assertEqual(Expected, Result).

research_03_01_test() ->
    Expected = nomatch,
    Text = "Her name is Janet",
    Regex = "\\b(?:Mary|Jane|Sue)\\b",
    {ok, MP} = re:compile(Regex),
    Result = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p",[Result]),
    %{match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_04_01_test() ->
    Expected = "jaNet",
    Text = "Her name is jaNet",
    Regex = "\\b(?i:Mary|JaNet|Sue)\\b",
    {ok, MP} = re:compile(Regex),
    %Result = re:run(Text, MP, [{capture, first, list}]),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

-endif.
