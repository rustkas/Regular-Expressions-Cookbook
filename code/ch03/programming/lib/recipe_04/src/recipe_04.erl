-module(recipe_04).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test()->
	Regex = "[$\"'\n]",
    {ok, MP} = re:compile(Regex,[extended, caseless, multiline]),
	?assert(is_tuple(MP)).

-endif.