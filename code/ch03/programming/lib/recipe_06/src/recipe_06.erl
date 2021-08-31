-module(recipe_06).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

is_full_match(Text, Regex) when is_list(Regex) ->
    %?debugFmt("MATCH = ~p",[Regex]),
   try 
      MP = re_tuner:mp("\\A" ++ Regex ++ "\\Z"),
	  is_full_match(Text, MP)  
   catch
      error:_Error -> false
   end;
is_full_match(Text, MP)  when is_tuple(MP) ->
    %?debugFmt("MP MATCH = ~p",[MP]),
	MatchResult = re:run(Text, MP, [{capture,none}]),
	Result = (MatchResult == match),
	Result.

research_01_test()->
	Expected = match,
	Text = "hello world",
	Regex = "hello world",
    MP = re_tuner:mp(Regex),
	Result = re:run(Text, MP, [{capture,none}]),
	Result = match,
	?assertEqual(Expected, Result).

research_02_test()->
	Expected = true,
	Text = "hello world",
	Regex = "hello world",
	Result = is_full_match(Text, Regex),
	?assertEqual(Expected, Result).

research_03_test()->
	Expected = false,
	Text = "hello world",
	Regex = "hello",
	Result = re_tuner:is_full_match(Text, Regex),
	?assertEqual(Expected, Result).

research_04_test0()->
   Regex = "(",
   false = re_tuner:is_full_match("(", Regex).


   
-endif.

