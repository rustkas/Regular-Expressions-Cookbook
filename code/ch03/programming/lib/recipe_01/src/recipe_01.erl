-module(recipe_01).

%%
%% Tests
%%
-ifdef(TEST).


make_list_of_numbers()->
    IntegerList = lists:seq(0,9),
	StringList = lists:map(fun(Integer)->
	    integer_to_list(Integer)
	end, IntegerList),
	StringList.


-include_lib("eunit/include/eunit.hrl").

research_01_test()->
    Text = ["$", "\"", "'", "\n"] ++ make_list_of_numbers() ++ ["\\"],
	Regex = "[$\"'\n\\d\\\\]",
    {ok, MP} = re:compile(Regex),
	Result = lists:all(fun(Elem)-> 
	    Result = re:run(Elem,MP,[{capture,none}]),
		%?debugFmt("String = ~p, Result = ~p",[Elem,Result]),
		match == Result
	end,Text),
	?assert(Result).

-endif.