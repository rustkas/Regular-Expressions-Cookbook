-module(recipe_11).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_01_test() ->
    Expected1 = "2008",
    Expected2 = "08",
    Expected3 = "08",
    Text = "2008-08-08",
    Regex = "\\b(?<year>\\d\\d\\d\\d)-(?<month>\\d\\d)-(?<day>\\d\\d)\\b",
    {ok, MP} = re:compile(Regex),
    {match, [Result1]} = re:run(Text, MP, [{capture, [year], list}]),
    {match, [Result2]} = re:run(Text, MP, [{capture, [month], list}]),
    {match, [Result3]} = re:run(Text, MP, [{capture, [day], list}]),

    ?assertEqual(Expected1, Result1),
    ?assertEqual(Expected2, Result2),
    ?assertEqual(Expected3, Result3).

research_01_02_test() ->
    Expected = "2008-08-08",
    Text = "2008-08-08",
    Regex = "\\b\\d\\d(?<magic>\\d\\d)-\\g{magic}-\\g{magic}\\b",
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),

    ?assertEqual(Expected, Result).

-endif.
