-module(recipe_16).

%% Setup you command line - run "chcp 65001" command

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

recipe_01_test()->
    Expected = "cat",
    Text = "My <b>cat</b> is furry",
    Regex = "(?<=<b>)\\w+(?=</b>)",
    {ok, MP} = re:compile(Regex,[caseless]),
	%Result = re:run(Text, MP, [{capture, first, list}]),
	{match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).

% Matching the same text twice	
% Thai numbers	
recipe_02_test()->
    Expected = [["๐"],["๑"],["๒"],["๓"],["๔"],["๕"],["๖"],["๗"],["๘"],["๙"],["๑"],["๐"]],
    Text = "๐ ๑ ๒ ๓ ๔ ๕ ๖ ๗ ๘ ๙ ๑๐",
	
    Regex = "(?=\\p{Thai})\\p{N}",
    {ok, MP} = re:compile(Regex,[unicode]),
	match = re:run(Text, MP, [{capture, none}]),
	
	%Result = re:run(Text, MP, [global, {capture, first, list}]),
	{match, Result} = re:run(Text, MP, [global, {capture, first, list}]),
    %?debugFmt("~ts~n",[Result]).
    ?assertEqual(Expected, Result).

% Lookaround is atomic
recipe_03_test()->
	Expected = nomatch,
	Text = " 123x12",
	Regex="(?=(\\d+))\w+\\1",
	{ok, MP} = re:compile(Regex),
	Result = re:run(Text, MP, [{capture, first, list}]),
	?assertEqual(Expected, Result).
	%?debugFmt("~ts~n",[Result]).

% Alternative to Lookbehind
recipe_04_01_test()->	
	Expected = "text",
	Text = "beforetext",
	Regex = "before\\Ktext",
	{ok, MP} = re:compile(Regex),
	%Result = re:run(Text, MP, [{capture, first, list}]),
	%?debugFmt("~p~n",[Result]).
	{match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
	?assertEqual(Expected, Result).

recipe_04_02_test()->	
	Expected = "text",
	Text = "beforetext",
	Regex = "(?<=before)text",
	{ok, MP} = re:compile(Regex),
	%Result = re:run(Text, MP, [{capture, first, list}]),
	%?debugFmt("~p~n",[Result]).
	{match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
	?assertEqual(Expected, Result).	
	
recipe_04_03_01_test()->	
	Expected = [["a"],["a"]],
	Text = "aaa",
	Regex = "(?<=a)a",
	{ok, MP} = re:compile(Regex),
	%Result = re:run(Text, MP, [{capture, first, list}]),
	%?debugFmt("~p~n",[Result]).
	{match, Result} = re:run(Text, MP, [global,{capture, first, list}]),
	?assertEqual(Expected, Result).	

recipe_04_03_02_test()->
	Expected = [["a"]],
	Text = "aaa",
	Regex = "a\\Ka",
	{ok, MP} = re:compile(Regex),
	%Result = re:run(Text, MP, [{capture, first, list}]),
	%?debugFmt("~p~n",[Result]).
	{match, Result} = re:run(Text, MP, [global,{capture, first, list}]),
	?assertEqual(Expected, Result).	

recipe_05_01_test()->
    Expected = "a",
    Text = "๐a",
    Regex = "(?<=\\p{Thai})(?<=\\p{Nd})a",
    {ok, MP} = re:compile(Regex,[unicode]),
	match = re:run(Text, MP, [{capture, none}]),
	{match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

recipe_05_02_test()->
    Expected = "a",
    Text = "๑a",
    Regex = "(?=\\p{Thai})\\p{Nd}\\Ka",
    {ok, MP} = re:compile(Regex,[unicode]),
	match = re:run(Text, MP, [{capture, none}]),
	{match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).
	
-endif.
