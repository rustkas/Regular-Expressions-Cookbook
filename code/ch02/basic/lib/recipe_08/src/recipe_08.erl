-module(recipe_08).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test()->
    Expected = [["Mary"],["Jane"],["Sue"],["Mary"]],
    Text = "Mary, Jane, and Sue went to Mary's house",
    Regex = "Mary|Jane|Sue",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [global,{capture, first, list}]),
	?assertEqual(Expected,Result).

research_02_test()->
    Expected = [["Jane"]],
    Text = "Her name is Janet",
    Regex = "Jane|Janet",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [global,{capture, first, list}]),
	?assertEqual(Expected,Result).

research_03_test()->
    Expected = [["Janet"]],
    Text = "Her name is Janet",
    Regex = "Janet|Jane",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [global,{capture, first, list}]),
	?assertEqual(Expected,Result).

research_04_test()->
    Expected = [["Janet"]],
    Text = "Her name is Janet",
    Regex = "\\bJane\\b|\\bJanet\\b",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [global,{capture, first, list}]),
	?assertEqual(Expected,Result).
	
-endif.
