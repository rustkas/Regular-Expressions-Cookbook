-module(recipe_14).

%%
%% Tests
%%
-ifdef(TEST).


-include_lib("eunit/include/eunit.hrl").

replace(Text, Regex, Replacement) when is_list(Regex)->
    MP = re_tuner:mp(Regex),
	case MP of
	   {error, _} -> Text;
	    _ -> replace(Text, MP, Replacement)
	end;
replace(Text, MP, Replacement) when is_tuple(MP)->    
	Result = re:replace(Text, MP, Replacement,[{return, list}]),
    Result.

build_text_and_expectation()->
    Text = "before",
    Expected = "after",
	Regex = Text,
    {Text, Expected,Regex}.


research_test_() ->
    {"Replace All Matches",
     {foreach,
      local,
      fun build_text_and_expectation/0,
      [fun research_01/1,
	   fun research_01_01/1,
	   fun research_01_02/1,
	   fun research_01_03/1,
	   fun research_01_01_01/1,
	   fun research_01_02_01/1,
	   fun research_01_03_01/1]}}.
	  
research_01({Text, Expected, Regex})->
    Result = re:replace(Text, Regex, Expected,[{return, list}]),
	?_assertEqual(Expected, Result).

research_01_01({Text, Expected, Regex})->
	Result = replace(Text,Regex,Expected),
	?_assertEqual(Expected, Result).

research_01_02({Text, Expected, Regex})->
	MP = re_tuner:mp(Regex),
	Result = replace(Text,MP,Expected),
	?_assertEqual(Expected, Result).

research_01_03({_Text, _Expected, Regex})->
    Expected = "",
	Text = Expected,
	MP = re_tuner:mp(Regex),
	Result = replace(Text,MP,Expected),
	?_assertEqual(Expected, Result).	
	
research_01_01_01({Text, Expected, Regex})->
	Result = re_tuner:replace(Text,Regex,Expected),
	?_assertEqual(Expected, Result).

research_01_02_01({Text, Expected, Regex})->
	MP = re_tuner:mp(Regex),
	Result = re_tuner:replace(Text,MP,Expected),
	?_assertEqual(Expected, Result).

research_01_03_01({_Text, _Expected, Regex})->
	Expected = "",
	Text = Expected,
	MP = re_tuner:mp(Regex),
	Result = re_tuner:replace(Text,MP,Expected),
	?_assertEqual(Expected, Result).	

research_02_test()->
	Text = "before before before before before",
	Expected = "after after after after after",
	Regex = "before",
	MP = re_tuner:mp(Regex),
	Result = replace(Text,MP,Expected),
	?_assertEqual(Expected, Result).

research_03_test()->
	Text = "1before 2before 3before 4before 5before",
	Expected = "1after 2after 3after 4after 5after",
	Regex = "before",
	MP = re_tuner:mp(Regex),
	Result = replace(Text,MP,Expected),
	?_assertEqual(Expected, Result).
	
-endif.
