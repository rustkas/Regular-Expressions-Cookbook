-module(recipe_02).


%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test()->
    Text = ["$", "\"", "'", "\n"],
	Regex = "[$\"'\n]",
    {ok, MP} = re:compile(Regex),
	Result = lists:all(fun(Elem)-> 
	    Result = re:run(Elem,MP,[{capture,none}]),
		%?debugFmt("String = ~p, Result = ~p",[Elem,Result]),
		match == Result
	end,Text),
	?assert(Result).

-endif.
