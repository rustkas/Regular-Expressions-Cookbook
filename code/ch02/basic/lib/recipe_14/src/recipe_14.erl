-module(recipe_14).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_test_() ->
    {"Eliminate Needless Backtracking",
     {foreach,
      local,
      fun make_string/0,
      [fun research_01_01/1,
       fun research_01_02/1,
       fun research_01_03/1,
       fun research_01_03/1]}}.

make_string() ->
    IntegerList = lists:seq(1, 10),
    StringList =
        lists:map(fun(Integer) -> integer_to_list(Integer) end, IntegerList),
    String = string:join(StringList, ""),
    String.

research_01_01(Text) ->
    Expected = "12345678910",
    Regex = "\\b\\d+\\b",
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p~n",[Result]).
    ?_assertEqual(Expected, Result).

research_01_02(Text) ->
    Expected = "12345678910",
    Regex = "\\b\\d+?\\b",
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p~n",[Result]).
    ?_assertEqual(Expected, Result).

%  a possessive quantifier
research_01_03(Text) ->
    Expected = "12345678910",
    %?debugFmt("~p~n",[Text]),
    Regex = "\\b\\d++\\b",
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p~n",[Result]).
    ?_assertEqual(Expected, Result).

% atomic group
research_01_04(Text) ->
    Expected = "12345678910",
    %?debugFmt("~p~n",[Text]),
    Regex = "\\b(?>\\d+)\\b",
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p~n",[Result]).
    ?_assertEqual(Expected, Result).

research_02_01_test() ->
    Expected = "abc123",
    Regex = "\\w+\\d+",
    Text = Expected,
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).

research_02_02_test() ->
    Expected = "abc123",
    Regex = "(?>\\w+\\d+)",
    Text = Expected,
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).

research_02_03_test() ->
    Expected = nomatch,
    Regex = "(?>\\w+)(?>\\d+)",
    Text = Expected,
    {ok, MP} = re:compile(Regex),
    Result = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).

-endif.
