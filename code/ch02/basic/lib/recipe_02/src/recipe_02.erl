-module(recipe_02).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

ascii_control_characters() ->
    ASCII_Control_Characters =
        #{"bell" => 16#07,
          "escape" => 16#1B,
          "form feed" => 16#0C,
          "line feed" => 16#0A,
          "carriage return" => 16#0D,
          "horizontal tab" => 16#09,
          "vertical tab" => 16#0B},
    ASCII_Control_Characters.

ascii_values() ->
    ASCII_Control_Characters = ascii_control_characters(),
    Values =
        [maps:get("bell", ASCII_Control_Characters),
         maps:get("escape", ASCII_Control_Characters),
         maps:get("form feed", ASCII_Control_Characters),
         maps:get("line feed", ASCII_Control_Characters),
         maps:get("carriage return", ASCII_Control_Characters),
         maps:get("horizontal tab", ASCII_Control_Characters),
         maps:get("vertical tab", ASCII_Control_Characters)],
    Values.

research_01_test() ->
    Expected = ascii_values(),
    Text = Expected,
    %?debugFmt("~p~n", [Text]),
    Regex = "\\a\\e\\f\\n\\r\\h\\v",
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p~n",[Result]),
    ?assertEqual(Expected, Result).

research_02_test() ->
    Expected = lists:seq(1, 26),
    Text = Expected,
    Regex = lists:map(fun(Elem) -> "\\c" ++ [Elem] end, lists:seq($A, $Z)),
    %?debugFmt("~p~n",[Regex]),
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p~n",[Result]),
    ?assertEqual(Expected, Result).

research_03_test() ->
    Expected = ascii_values(),
    Text = Expected,
    %?debugFmt("~p~n", [Text]),
    Regex = lists:map(fun(Elem) -> "\\x" ++ sstr:hex(Elem, "") end, Expected),
    {ok, MP} = re:compile(Regex),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p~n",[Result]),
    ?assertEqual(Expected, Result).

-endif.
