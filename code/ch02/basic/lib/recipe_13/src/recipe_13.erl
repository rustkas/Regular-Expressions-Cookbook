-module(recipe_13).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test() ->
    Expected = "<p>test</p>",
    Text = Expected,
    Regex = "<p>.*?</p>",
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_02_test() ->
    Expected =
        "<p>
The very <em>first</em> task is to find the beginning of a paragraph.
</p>",
    Text =
        "<p>
The very <em>first</em> task is to find the beginning of a paragraph.
</p>
<p>
Then you have to find the end of the paragraph
</p>
\t",
    Regex = "<p>.*?</p>",
    {ok, MP} = re:compile(Regex, [multiline, dotall]),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    %{match, [Result]} = re:run(Text, MP, [{capture,first,list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).

research_03_test() ->
    Expected = "<p>test1 <p>test2</p></p>",
    Text = Expected,
    Regex = "<p>.*</p>",
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_04_01_test() ->
    Expected = "1234",
    Text = "1234",
    Regex = "\\d+\\b",
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_04_02_test() ->
    Expected = "1234",
    Text = "1234",
    Regex = "\\d+?\\b",
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_05_01_test() ->
    Expected = nomatch,
    Text = "1234X",
    Regex = "\\d+\\b",
    {ok, MP} = re:compile(Regex),
    Result = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_05_02_test() ->
    Expected = nomatch,
    Text = "1234X",
    Regex = "\\d+?\\b",
    {ok, MP} = re:compile(Regex),
    Result = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

-endif.
