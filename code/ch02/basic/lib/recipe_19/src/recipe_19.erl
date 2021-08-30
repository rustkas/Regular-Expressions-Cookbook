-module(recipe_19).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test()->
    Expected = "[text]",
    Text = "text",
    Regex = "text",
	Replacement="[&]",
    {ok, MP} = re:compile(Regex),
	Result = re:replace(Text,MP,Replacement,[{return, list}]),
    ?assertEqual(Expected,Result).
	
research_02_test()->
    Expected = "text",
    Text = "text",
    Regex = "(text) 123",
	Replacement="",
    {ok, MP} = re:compile(Regex),
	Result = re:replace(Text,MP,Replacement,[{return, list}]),
	%?debugFmt("Result = ~p",[Result]),
    ?assertEqual(Expected,Result).


	
-endif.
