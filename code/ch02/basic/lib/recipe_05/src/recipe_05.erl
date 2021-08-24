-module(recipe_05).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_01_test() ->
    Text = "alpha ",
    Regex = "^alpha",
    {ok, MP} = re:compile(Regex),
    ?assertEqual(match, re:run(Text, MP, [{capture, none}])).

research_01_02_test() ->
    Text = "alpha ",
    Regex = "\\Aalpha",
    {ok, MP} = re:compile(Regex),
    ?assertEqual(match, re:run(Text, MP, [{capture, none}])).

research_01_03_test() ->
    Text = " omega",
    Regex = "omega$",
    {ok, MP} = re:compile(Regex),
    ?assertEqual(match, re:run(Text, MP, [{capture, none}])).

research_01_04_test() ->
    Text = " omega",
    Regex = "omega\\z",
    {ok, MP} = re:compile(Regex),
    ?assertEqual(match, re:run(Text, MP, [{capture, none}])).

research_01_05_test() ->
    Text = " omega\n",
    Regex = "omega\\Z",
    {ok, MP} = re:compile(Regex),
    ?assertEqual(match, re:run(Text, MP, [{capture, none}])).

research_01_06_test() ->
    Text = " omega\r\n",
    Regex = "omega\\Z",
    {ok, MP} = re:compile(Regex),
    ?assertEqual(match, re:run(Text, MP, [{capture, none}, {newline, crlf}])).

research_02_01_test() ->
    Expected = [["one"], ["two"], ["four"]],
    Text = "one\r\ntwo\r\n\r\nfour",
    Regex = "\\w+?$",
    {ok, MP} = re:compile(Regex, [multiline]),
    {match, Result} =
        re:run(Text, MP, [global, {capture, first, list}, {newline, crlf}]),
    ?assertEqual(Expected, Result).

-endif.
