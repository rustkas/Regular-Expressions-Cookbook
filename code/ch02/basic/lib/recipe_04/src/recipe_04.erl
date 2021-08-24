-module(recipe_04).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test() ->
    Regex = ".",
    {ok, MP} = re:compile(Regex),
    List = lists:seq(0, 127) -- [10],
    lists:foreach(fun(Elem) ->
                     Text = [Elem],
                     match == re:run(Text, MP, [{newline, lf}, {capture, none}])
                  end,
                  List).

research_02_01_test() ->
    Regex = "[\\s\\S]",
    {ok, MP} = re:compile(Regex, [dotall]),
    List = lists:seq(0, 127),
    lists:foreach(fun(Elem) ->
                     Text = [Elem],
                     match == re:run(Text, MP, [{newline, lf}, {capture, none}])
                  end,
                  List).

research_02_02_test() ->
    Regex = "[\\d\\D]",
    {ok, MP} = re:compile(Regex, [dotall]),
    List = lists:seq(0, 127),
    lists:foreach(fun(Elem) ->
                     Text = [Elem],
                     match == re:run(Text, MP, [{newline, lf}, {capture, none}])
                  end,
                  List).

research_02_03_test() ->
    Regex = "[\\w\\W]",
    {ok, MP} = re:compile(Regex, [dotall]),
    List = lists:seq(0, 127),
    lists:foreach(fun(Elem) ->
                     Text = [Elem],
                     match == re:run(Text, MP, [{newline, lf}, {capture, none}])
                  end,
                  List).

research_02_04_test() ->
    Regex = "(?s).",
    {ok, MP} = re:compile(Regex, [dotall]),
    List = lists:seq(0, 127),
    lists:foreach(fun(Elem) ->
                     Text = [Elem],
                     match == re:run(Text, MP, [{newline, lf}, {capture, none}])
                  end,
                  List).

research_02_05_test() ->
    Regex = "(?m).",
    {ok, MP} = re:compile(Regex, [dotall]),
    List = lists:seq(0, 127),
    lists:foreach(fun(Elem) ->
                     Text = [Elem],
                     match == re:run(Text, MP, [{newline, lf}, {capture, none}])
                  end,
                  List).

research_03_test() ->
    Expected = match,
    Text1 = "05/16/08",
    Text2 = "99/99/99",
    Text3 = "12345678",
    Regex = "\\d\\d[/.\-]\\d\\d[/.\-]\\d\\d",
    {ok, MP} = re:compile(Regex),
    ?assertEqual(Expected, re:run(Text1, MP, [{capture, none}])),
    ?assertEqual(Expected, re:run(Text2, MP, [{capture, none}])),
    ?assertEqual(nomatch, re:run(Text3, MP, [{capture, none}])).

-endif.
