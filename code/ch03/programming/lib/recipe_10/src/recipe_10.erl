-module(recipe_10).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

all_match(Text,Regex) when is_list(Regex) ->
    MP = re_tuner:mp(Regex),
	Result = all_match(Text, MP),
	Result;
all_match(Text, MP) when is_tuple(MP) ->
	Result = case re:run(Text, MP, [global,{capture,first,list}]) of 
	    {match, MatchResult} -> lists:map(fun(Elem)-> hd(Elem) end, MatchResult);
		nomatch -> nomatch
	end,	
	Result.

research_01_test()->
	Expected = ["7", "13", "16", "42", "65", "99"],
	Text = "The lucky numbers are 7, 13, 16, 42, 65, and 99",
	Regex = "\\d+",
    MP = re_tuner:mp(Regex),
	{match, MatchResult} = re:run(Text, MP, [global,{capture,first,list}]),
	Result = lists:map(fun(Elem)->
	    hd(Elem)
	end, MatchResult),
	?assertEqual(Expected, Result).

research_01_01_test()->
	Expected = [ "7", "13", "16", "42", "65", "99"],
	Text = "The lucky numbers are 7, 13, 16, 42, 65, and 99",
	Regex = "\\d+",
	Result = all_match(Text, Regex),
	?assertEqual(Expected, Result).

research_01_02_test()->
	Expected = [ "7", "13", "16", "42", "65", "99"],
	Text = "The lucky numbers are 7, 13, 16, 42, 65, and 99",
	Regex = "\\d+",
	MP = re_tuner:mp(Regex),
	Result = all_match(Text, MP),
	?assertEqual(Expected, Result).

research_01_03_test()->
	Expected = nomatch,
	Text = "The lucky numbers are",
	Regex = "\\d+",
	MP = re_tuner:mp(Regex),
	Result = all_match(Text, MP),
	?assertEqual(Expected, Result).
	
research_01_01_01_test()->
	Expected = [ "7", "13", "16", "42", "65", "99"],
	Text = "The lucky numbers are 7, 13, 16, 42, 65, and 99",
	Regex = "\\d+",
	Result = all_match(Text, Regex),
	?assertEqual(Expected, Result).

research_01_02_01_test()->
	Expected = [ "7", "13", "16", "42", "65", "99"],
	Text = "The lucky numbers are 7, 13, 16, 42, 65, and 99",
	Regex = "\\d+",
	MP = re_tuner:mp(Regex),
	Result = all_match(Text, MP),
	?assertEqual(Expected, Result).

research_01_03_01_test()->
	Expected = nomatch,
	Text = "The lucky numbers are 7, 13, 16, 42, 65, and 99",
	Regex = "\\d{3,}",
	MP = re_tuner:mp(Regex),
	Result = all_match(Text, MP),
	?assertEqual(Expected, Result).	

-endif.
