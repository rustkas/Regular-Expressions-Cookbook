-module(recipe_01).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test()->
    % [$"'\n\d/\\]
    Text = ["$","\""],
	Regex = "[$\"]",
    {ok, MP} = re:compile(Regex),
	lists:all(fun(Elem)-> 
	    Result = re:run(Elem,MP),
		match == Result
	end,Text).

-endif.	