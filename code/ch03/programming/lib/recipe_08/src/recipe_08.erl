-module(recipe_08).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

first_match_info(Text,Regex) when is_list(Regex) ->
    MP = re_tuner:mp(Regex),
	Result = first_match_info(Text, MP),
	Result;
first_match_info(Text, MP) when is_tuple(MP) ->
	Result = case re:run(Text, MP, [{capture, first, index}]) of 
	    {match, [RunResult]} -> RunResult;
		nomatch -> nomatch
	end,
	Result.

research_01_test()->
	Expected = {12,2},
	Text = "Do you like 13 or 42?",
	Regex = "\\d+",
    MP = re_tuner:mp(Regex),
	{match, [Result]} = re:run(Text, MP, [{capture, first, index}]),
	?assertEqual(Expected, Result).

research_01_01_test()->
	Expected = {12,2},
	Text = "Do you like 13 or 42?",
	Regex = "\\d+",
	Result = first_match_info(Text, Regex),
	?assertEqual(Expected, Result).

research_01_02_test()->
	Expected = {12,2},
	Text = "Do you like 13 or 42?",
	Regex = "\\d+",
	MP = re_tuner:mp(Regex),
	Result = first_match_info(Text, MP),
	?assertEqual(Expected, Result).

research_01_03_test()->
	Expected = nomatch,
	Text = "Do you like 13 or 42?",
	Regex = "\\d{3,}",
	MP = re_tuner:mp(Regex),
	Result = first_match_info(Text, MP),
	?assertEqual(Expected, Result).

-endif.

