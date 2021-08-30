-module(recipe_21).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test()->
    Expected = "(123) 456-7890",
    Text = "1234567890",
    Regex = "\\b(\\d{3})(\\d{3})(\\d{4})\\b",
	Replacement="(\\1) \\2-\\3",
    {ok, MP} = re:compile(Regex),
	Result = re:replace(Text,MP,Replacement,[{return, list}]),
	%?debugFmt("Result = ~p",[Result]),
    ?assertEqual(Expected,Result).

% Named backreferences is not supported	
research_02_test0()->
    Expected = "(123) 456-7890",
    Text = "1234567890",
    Regex = "\\b(?<area>\\d{3})(?<exchange>\\d{3})(?<number>\\d{4})\\b",
	Replacement="(\\k<area>) \\k<exchange>-\\k<number>",
    {ok, MP} = re:compile(Regex),
	Result = re:replace(Text,MP,Replacement,[{return, list}]),
	%?debugFmt("Result = ~p",[Result]),
    ?assertEqual(Expected,Result).
-endif.
