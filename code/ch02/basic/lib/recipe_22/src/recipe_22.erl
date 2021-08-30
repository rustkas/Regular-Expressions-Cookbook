-module(recipe_22).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test()->
    %Expected = "BSeforeBeforeBeforeMatchAfterAfterAfter",
	Expected = "Before$`$_$'After",
	
    Text = "BeforeMatchAfter",
    Regex = "Match",
	%Replacement="\\`\\`\\&\\'\\'",
	Replacement="$`$_$'",
    {ok, MP} = re:compile(Regex),
	Result = re:replace(Text,MP,Replacement,[{return, list}]),
	%?debugFmt("Result = ~p",[Result]),
    ?assertEqual(Expected,Result).

-endif.
