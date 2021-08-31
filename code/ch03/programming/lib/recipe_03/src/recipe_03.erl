-module(recipe_03).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test()->
	Regex = "[$\"'\n]",
    {ok, MP} = re:compile(Regex),
	?assert(is_tuple(MP)).

-endif.
