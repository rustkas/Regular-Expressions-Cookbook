-module(recipe_06).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test() ->
    Expected = ["cat"],
    Text1 = "My cat is brown",
    Text2 = "category or bobcat",
    Regex = "\\bcat\\b",
    {ok, MP} = re:compile(Regex),
    {match, Result1} = re:run(Text1, MP, [{capture, first, list}]),
    Result2 = re:run(Text2, MP, [global, {capture, first, list}]),
    ?assertEqual(Expected, Result1),
    ?assertEqual(nomatch, Result2).

research_02_test() ->
    Expected = ["cat"],
    Text1 = "My cat is brown",
    Text2 = "category or bobcat",
    Text3 = "staccato",
    Regex = "\\Bcat\\B",
    {ok, MP} = re:compile(Regex),
    Result1 = re:run(Text1, MP, [{capture, first, list}]),
    Result2 = re:run(Text2, MP, [global, {capture, first, list}]),
    {match, Result3} = re:run(Text3, MP, [{capture, first, list}]),
    ?assertEqual(nomatch, Result1),
    ?assertEqual(nomatch, Result2),
    ?assertEqual(Expected, Result3).

-endif.
