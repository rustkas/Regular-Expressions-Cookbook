-module(recipe_20).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test()->
    Expected = "Please visit <a href=\"http://www.regexcookbook.com\">http://www.regexcookbook.com</a>",
    Text = "Please visit http://www.regexcookbook.com",
    Regex = "http:\\S+",
	Replacement="<a href=\"&\">&</a>",
    {ok, MP} = re:compile(Regex),
	Result = re:replace(Text,MP,Replacement,[{return, list}]),
	%?debugFmt("Result = ~p",[Result]),
    ?assertEqual(Expected,Result).


-endif.
