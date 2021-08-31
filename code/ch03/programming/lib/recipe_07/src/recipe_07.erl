-module(recipe_07).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

first_match(Text,Regex) when is_list(Regex) ->
    MP = re_tuner:mp(Regex),
	Result = first_match(Text, MP),
	Result;
first_match(Text, MP) when is_tuple(MP) ->
	Result = case re:run(Text, MP, [{capture, first, list}]) of 
	    {match, [RunResult]} -> RunResult;
		nomatch -> nomatch
	end,	
	Result.

research_01_test()->
	Expected = "13",
	Text = "Do you like 13 or 42?",
	Regex = "\\d+",
    MP = re_tuner:mp(Regex),
	{match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
	?assertEqual(Expected, Result).

research_01_01_test()->
	Expected = "13",
	Text = "Do you like 13 or 42?",
	Regex = "\\d+",
	Result = first_match(Text, Regex),
	?assertEqual(Expected, Result).

research_01_02_test()->
	Expected = "13",
	Text = "Do you like 13 or 42?",
	Regex = "\\d+",
	MP = re_tuner:mp(Regex),
	Result = first_match(Text, MP),
	?assertEqual(Expected, Result).

research_01_03_test()->
	Expected = nomatch,
	Text = "Do you like 13 or 42?",
	Regex = "\\d{3,}",
	MP = re_tuner:mp(Regex),
	Result = first_match(Text, MP),
	?assertEqual(Expected, Result).
	
research_02_01_test()->
	Expected = "13",
	Text = "Do you like 13 or 42?",
	Regex = "\\d+",
	Result = re_tuner:first_match(Text, Regex),
	?assertEqual(Expected, Result).

research_02_02_test()->
	Expected = "13",
	Text = "Do you like 13 or 42?",
	Regex = "\\d+",
	MP = re_tuner:mp(Regex),
	Result = re_tuner:first_match(Text, MP),
	?assertEqual(Expected, Result).

research_02_03_test()->
	Expected = nomatch,
	Text = "Do you like 13 or 42?",
	Regex = "\\d{3,}",
	MP = re_tuner:mp(Regex),
	Result = re_tuner:first_match(Text, MP),
	?assertEqual(Expected, Result).	
-endif.
