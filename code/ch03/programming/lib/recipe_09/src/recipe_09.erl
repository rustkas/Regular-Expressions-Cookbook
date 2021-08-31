-module(recipe_09).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

first_part_match(Text,Regex) when is_list(Regex) ->
    MP = re_tuner:mp(Regex),
	Result = first_part_match(Text, MP),
	Result;
first_part_match(Text, MP) when is_tuple(MP) ->
	Result = case re:run(Text, MP, [{capture, [1], list}]) of 
	    {match, [RunResult]} -> RunResult;
		nomatch -> nomatch
	end,	
	Result.

research_01_test()->
	Expected = "www.regexcookbook.com",
	Text = "Please visit http://www.regexcookbook.com for more information",
	Regex = "http://([a-z0-9.-]+)",
    MP = re_tuner:mp(Regex),
	{match, [Result]} = re:run(Text, MP, [{capture,[1],list}]),
	?assertEqual(Expected, Result).


research_01_01_test()->
	Expected = "www.regexcookbook.com",
	Text = "Please visit http://www.regexcookbook.com for more information",
	Regex = "http://([a-z0-9.-]+)",
	Result = first_part_match(Text, Regex),
	?assertEqual(Expected, Result).

research_01_02_test()->
	Expected = "www.regexcookbook.com",
	Text = "Please visit http://www.regexcookbook.com for more information",
	Regex = "http://([a-z0-9.-]+)",
	MP = re_tuner:mp(Regex),
	Result = first_part_match(Text, MP),
	?assertEqual(Expected, Result).

research_01_03_test()->
	Expected = nomatch,
	Text = "Please visit http://www.regexcookbook.com for more information",
	Regex = "https://([a-z0-9.-]+)",
	MP = re_tuner:mp(Regex),
	Result = first_part_match(Text, MP),
	?assertEqual(Expected, Result).

research_02_01_test()->
	Expected = "www.regexcookbook.com",
	Text = "Please visit http://www.regexcookbook.com for more information",
	Regex = "http://([a-z0-9.-]+)",
	Result = re_tuner:first_part_match(Text, Regex),
	?assertEqual(Expected, Result).

research_02_02_test()->
	Expected = "www.regexcookbook.com",
	Text = "Please visit http://www.regexcookbook.com for more information",
	Regex = "http://([a-z0-9.-]+)",
	MP = re_tuner:mp(Regex),
	Result = re_tuner:first_part_match(Text, MP),
	?assertEqual(Expected, Result).

research_02_03_test()->
	Expected = nomatch,
	Text = "Please visit http://www.regexcookbook.com for more information",
	Regex = "https://([a-z0-9.-]+)",
	MP = re_tuner:mp(Regex),
	Result = re_tuner:first_part_match(Text, MP),
	?assertEqual(Expected, Result).
	
research_03_test()->
	Expected = "www.regexcookbook.com",
	Text = "Please visit http://www.regexcookbook.com for more information",
	Regex = "http://(?<domain>[a-z0-9.-]+)",
    MP = re_tuner:mp(Regex),
	{match, [Result]} = re:run(Text, MP, [{capture,['domain'],list}]),
	?assertEqual(Expected, Result).	

-endif.