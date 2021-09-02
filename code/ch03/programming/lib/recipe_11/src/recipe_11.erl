-module(recipe_11).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test()->
	Expected = [ "7", "13", "16", "42", "65", "99"],
	Text = "The lucky numbers are 7, 13, 16, 42, 65, and 99",
	Regex = "\\d+",
	MP = re_tuner:mp(Regex),
	Result = re_tuner:all_match(Text, MP),
	%?debugFmt("~p",[Result]),
	lists:foreach(fun(Elem)->
		?assert(re_tuner:is_match(Elem,MP))
		%?debugFmt("~p",[Elem])
	end, Result).



-endif.

