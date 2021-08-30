-module(recipe_17).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test()->

   Text = "one,two,thee",
   Regex = "\\b(?:(?:(one)|(two)|(three))(?:,|\\b)){3,}(?(1)|(?!))(?(2)|(?!))(?(3)|(?!))",
   {ok, MP} = re:compile(Regex),
   match = re:run(Text, MP, [{capture, none}]).
   
research_02_test()->
   Expected = [["abc"],["bd"]],
   Text = "abc abd",
   Regex = "(a)?b(?(1)c|d)",
   {ok, MP} = re:compile(Regex),
   match = re:run(Text, MP, [{capture, none}]),
   {match,Result} = re:run(Text, MP, [global,{capture, first, list}]),
   %?debugFmt("~p~n",[Result]).
   ?assertEqual(Expected, Result).

   
-endif.
