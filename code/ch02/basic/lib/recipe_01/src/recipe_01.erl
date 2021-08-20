-module(recipe_01).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test() ->
    Expected =
        ["The punctuation characters in the ASCII table are: !\"#$%&'()*+,-./:;<=>?@[\]^_`{|}~"],
    Text = [Expected],
    Regex =
        "The punctuation characters in the ASCII table are: !\"#\\$%&'\\(\\)\\*\\+,-\\./:;<=>\\?@\\[\\\]\\^_`\\{\\|\\}~",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).

research_02_test() ->
    Expected = ["Mary had a little lamb"],
    Text = [Expected],
    Regex = "Mary had a little lamb",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_03_test() ->
    Expected = ["$()*+.?[\\^{|"],
    Text = [Expected],
    Regex = "\\$\\(\\)\\*\\+\\.\\?\\[\\\\\\^\\{\\|",
    %?debugFmt("Regex = ~s, Text = ~s~n",[Regex,Text]),
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_04_test() ->
    Expected = ["]-}"],
    Text = [Expected],
    Regex = "]-}",
    %?debugFmt("Regex = ~s, Text = ~s~n",[Regex,Text]),
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_05_test() ->
    Expected =
        ["The punctuation characters in the ASCII table are: !\"#$%&'()*+,-./:;<=>?@[\]^_`{|}~"],
    Text = [Expected],
    Regex =
        "The punctuation characters in the ASCII table are: \\Q!\"#$%&'()*+,-./:;<=>?@[\]^_`{|}~\\E",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_06_test() ->
    Expected =
        ["The punctuation characters in the ASCII table are: !\"#$%&'()*+,-./:;<=>?@[\]^_`{|}~"],
    Text = [Expected],
    Regex =
        "The punctuation characters in the ASCII table are: \\Q!\"#$%&'()*+,-./:;<=>?@[\]^_`{|}~",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_07_01_test() ->
    Expected = ["regex Regex REGEX ReGeX"],
    Text = [Expected],
    Regex = "regex regex regex regex",
    {ok, MP} = re:compile(Regex, [caseless]),
    {match, Result} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_07_02_test() ->
    Expected = ["regex Regex REGEX ReGeX"],
    Text = [Expected],
    Regex = "(?i)regex regex regex regex",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_08_01_test() ->
    Expected = ["sensitiveCASELESSsensitive"],
    Text = [Expected],
    Regex = "sensitive(?i)caseless(?-i)sensitive",
    {ok, MP} = re:compile(Regex),
    {match, Result} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_08_02_test() ->
    Expected = nomatch,
    Text = "SENSITIVEcaselessSENSITIVE",
    Regex = "sensitive(?i)caseless(?-i)sensitive",
    {ok, MP} = re:compile(Regex),
    Result = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

-endif.
