-module(recipe_12).

-export([check_string/2]).

-spec check_string(Input, MP) -> match
    when Input :: string(),
         MP :: tuple().
check_string(Input, MP) ->
    match = re:run(Input, MP, [{capture, none}]),
    match.

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

% A googol (a decimal number with 100 digits).
research_01_test() ->
    Expected = match,
    StringList = lists:duplicate(100, "1"),
    String = string:join(StringList, ""),
    %?debugFmt("Length = ~p, Value = ~p~n",[length(String),String]),
    Regex = "\\b\\d{100}\\b",
    {ok, MP} = re:compile(Regex),
    Resutl = check_string(String, MP),
    ?assertEqual(Expected, Resutl).

research_02_test_() ->
    {"A 32-bit hexadecimal number", [{timeout, 10000, research_04()}]}.

research_02() ->
    Expected = match,

    Regex = "\\b[A-F0-9]{1,8}\\b",
    {ok, MP} = re:compile(Regex),

    Fun = fun FunAcc(Integer) ->
                  case Integer == 4294967295 of
                      true ->
                          true;
                      _ ->
                          HexString = io_lib:format("~.16B", [Integer]),
                          ?debugFmt("~p", [HexString]),
                          Result = check_string(HexString, MP),
                          ?assertEqual(Expected, Result),
                          FunAcc(Integer + 1)
                  end
          end,
    Fun(0).

research_04() ->
    Expected = match,

    Regex = "\\d*\\.\\d+(e\\d+)?",
    {ok, MP} = re:compile(Regex),

    Fun = fun FunAcc(Integer) ->
                  case Integer == 4294967295 of
                      true ->
                          true;
                      _ ->
                          HexString =
                              io_lib:format("~.10B.~.10Be~.10B", [Integer, Integer, Integer]),
                          ?debugFmt("~p", [HexString]),
                          Result = check_string(HexString, MP),
                          ?assertEqual(Expected, Result),
                          FunAcc(Integer + 1)
                  end
          end,
    Fun(0).

-endif.
