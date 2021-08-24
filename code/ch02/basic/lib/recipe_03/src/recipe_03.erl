-module(recipe_03).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test() ->
    Expected = [["calendar"], ["celendar"], ["calandar"], ["calender"]],
    Text = "calendar celendar calandar calender",
    Regex = "c[ae]l[ae]nd[ae]r",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [global, {capture, all, list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).

research_02_01_test() ->
    Regex = "\\d",
    {ok, MP} = re:compile(Regex),
    lists:foreach(fun(Elem) -> match == re:run([Elem], MP, [{capture, none}]) end,
                  lists:seq(0, 9)).

research_02_02_test() ->
    Regex = "[\\d]",
    {ok, MP} = re:compile(Regex),
    lists:foreach(fun(Elem) -> match == re:run([Elem], MP, [{capture, none}]) end,
                  lists:seq(0, 9)).

research_02_03_test() ->
    Regex = "\\D",
    {ok, MP} = re:compile(Regex),
    List = lists:seq(0, 127) -- lists:seq(0, 9),
    lists:foreach(fun(Elem) -> match == re:run([Elem], MP, [{capture, none}]) end,
                  List).

research_02_04_test() ->
    Regex = "[^\\d]",
    {ok, MP} = re:compile(Regex),
    List = lists:seq(0, 127) -- lists:seq(0, 9),
    lists:foreach(fun(Elem) -> match == re:run([Elem], MP, [{capture, none}]) end,
                  List).

research_02_05_test() ->
    Regex = "[a-fA-F\\d]",
    {ok, MP} = re:compile(Regex),
    List = lists:seq(0, 127),
    lists:foreach(fun(Elem) ->
                     HexNumber = sstr:hex(Elem, ""),
                     match == re:run(HexNumber, MP, [{capture, none}])
                  end,
                  List).

research_02_06_test() ->
    Regex = "\\w",
    {ok, MP} = re:compile(Regex),
    List = lists:seq($0, $9) ++ lists:seq($a, $z) ++ lists:seq($A, $Z) ++ [$_],
    lists:foreach(fun(Elem) -> match == re:run([Elem], MP, [{capture, none}]) end,
                  List).

research_02_07_test() ->
    Regex = "\\W",
    {ok, MP} = re:compile(Regex),
    List =
        lists:seq(0, 127)
        -- lists:seq($0, $9) ++ lists:seq($a, $z) ++ lists:seq($A, $Z) ++ [$_],
    lists:foreach(fun(Elem) -> match == re:run([Elem], MP, [{capture, none}]) end,
                  List).

research_02_08_test() ->
    Regex = "[a-zA-Z0-9_]",
    {ok, MP} = re:compile(Regex),
    List = lists:seq($0, $9) ++ lists:seq($a, $z) ++ lists:seq($A, $Z) ++ [$_],
    lists:foreach(fun(Elem) -> match == re:run([Elem], MP, [{capture, none}]) end,
                  List).

research_03_test() ->
    Expected = [256],
    Text = [256],
    Regex = "\\x{100}",
    {ok, MP} = re:compile(Regex, [unicode]),
    {match, [Result]} = re:run(Text, MP, [{capture, all, list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).

research_04_test() ->
    Expected = [256],
    Text = [256],
    Regex = "\\p{L}",
    {ok, MP} = re:compile(Regex, [unicode]),
    {match, [Result]} = re:run(Text, MP, [{capture, all, list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).

research_05_01_test() ->
    Regex = "[a-f0-9]",
    {ok, MP} = re:compile(Regex, [caseless]),
    List = lists:seq(0, 127),
    lists:foreach(fun(Elem) ->
                     HexNumber = sstr:hex(Elem, ""),
                     match == re:run(HexNumber, MP, [{capture, none}])
                  end,
                  List).

research_05_02_test() ->
    Regex = "(?i)[a-f0-9]",
    {ok, MP} = re:compile(Regex),
    List = lists:seq(0, 127),
    lists:foreach(fun(Elem) ->
                     HexNumber = sstr:hex(Elem, ""),
                     match == re:run(HexNumber, MP, [{capture, none}])
                  end,
                  List).

research_05_03_test() ->
    Regex = "(?i)[^A-F0-9]",
    {ok, MP} = re:compile(Regex),
    List =
        lists:seq(0, 127)
        -- lists:seq($0, $9) ++ lists:seq($a, $f) ++ lists:seq($A, $F),
    lists:foreach(fun(Elem) -> match == re:run([Elem], MP, [{capture, none}]) end,
                  List).

research_06_01_test() ->
    Regex = "[a-zA-Z0-9-[g-zG-Z]]",
    {ok, MP} = re:compile(Regex),
    List =
        lists:seq($a, $z)
        ++ lists:seq($A, $Z)
        ++ lists:seq($0, $9) -- lists:seq($g, $z) -- lists:seq($G, $Z),
    lists:foreach(fun(Elem) -> match == re:run([Elem], MP, [{capture, none}]) end,
                  List).

research_06_02_test() ->
    Regex = "[a-zA-Z0-9-[g-zG-Z]]",
    {ok, MP} = re:compile(Regex),
    List = lists:seq($g, $z) ++ lists:seq($G, $Z),
    lists:foreach(fun(Elem) -> nomatch == re:run([Elem], MP, [{capture, none}]) end,
                  List).

research_07_01_test() ->
    Regex = "[\\p{Thai}-[\\P{N}]]",
    {ok, _MP} = re:compile(Regex, [unicode]).

research_08_01_test() ->
    Regex = "[a-f[A-F][0-9]]",
    {ok, MP} = re:compile(Regex),
    List = lists:seq($0, $9) ++ lists:seq($a, $z) ++ lists:seq($A, $Z),
    lists:foreach(fun(Elem) -> match == re:run([Elem], MP, [{capture, none}]) end,
                  List).

research_08_02_test() ->
    Regex = "[a-f[A-F[0-9]]]",
    {ok, MP} = re:compile(Regex),
    List = lists:seq($0, $9) ++ lists:seq($a, $z) ++ lists:seq($A, $Z),
    lists:foreach(fun(Elem) -> match == re:run([Elem], MP, [{capture, none}]) end,
                  List).

research_08_03_test() ->
    Regex = "[\\w&&[a-fA-F0-9\\s]]",
    {ok, MP} = re:compile(Regex, [caseless]),
    List = lists:seq(0, 255),
    lists:foreach(fun(Elem) ->
                     HexNumber = sstr:hex(Elem, ""),
                     match == re:run(HexNumber, MP, [{capture, none}])
                  end,
                  List).

research_08_04_test() ->
    Regex = "[a-zA-Z0-9&&[^g-zG-Z]]",
    {ok, MP} = re:compile(Regex, [caseless]),
    List = lists:seq(0, 255),
    lists:foreach(fun(Elem) ->
                     HexNumber = sstr:hex(Elem, ""),
                     match == re:run(HexNumber, MP, [{capture, none}])
                  end,
                  List).

-endif.
