-module(recipe_05).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

is_match(Text, Regex) when is_list(Regex) ->
    %?debugFmt("MATCH = ~p",[Regex]),
   try 
      MP = re_tuner:mp(Regex),
	  is_match(Text, MP)  
   catch
      error:_Error -> false
   end;
is_match(Text, MP)  when is_tuple(MP) ->
    %?debugFmt("MP MATCH = ~p",[MP]),
	MatchResult = re:run(Text, MP, [{capture,none}]),
	Result = (MatchResult == match),
	Result.

research_01_test()->
	Expected = match,
	Text = "$",
	Regex = "$",
    MP = re_tuner:mp(Regex),
	Result = re:run(Text, MP, [{capture,none}]),
	Result = match,
	?assertEqual(Expected, Result).


research_02_test()->
	
	StringList = lists:map(fun(Elem)->
	integer_to_list(Elem)
	end,lists:seq(0,127)),
	
	Regex = "$",
    MP = re_tuner:mp(Regex),
	
	
	true = lists:all(fun(Text)->
	    %Result = re:run(Text, MP, [{capture,none}]),
	    %?debugFmt("String = ~p, Result = ~p",[Text,Result]),
		%true
	    match == re:run(Text, MP, [{capture,none}])
	end, StringList).
	

research_03_test()->
   Regex = "(",
   false = is_match("(", Regex).

research_04_test()->
   Regex = "[(]",
   MP = re_tuner:mp(Regex),
   true = is_match("(", MP).
   
research_03_02_test()->
   Regex = "(",
   false = re_tuner:is_match("(", Regex).

research_04_02_test()->
   Regex = "[(]",
   MP = re_tuner:mp(Regex),
   true = re_tuner:is_match("(", MP).   
   
-endif.
