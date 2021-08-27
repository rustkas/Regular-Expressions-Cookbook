-module(recipe_10).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_01_test() ->
    Expected = "2008-08-08",
    Text = "2008-08-08",
    Regex = "\\b\\d\\d(\\d\\d)-\\1-\\1\\b",
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

-endif.
