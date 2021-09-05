-module(recipe_15).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

build_text_and_expectation()->
    Text = "A=B",
    Expected = "B=A",
	Regex = "(\\w+)=(\\w+)",
	Replacement = "\\2=\\1",
    {Text, Expected, Regex,Replacement}.

research_test_() ->
    {"Replace Matches Reusing Parts of the Match",
     {foreach,
      local,
      fun build_text_and_expectation/0,
      [fun research_01/1,
	   fun research_01_01_01/1,
	   fun research_01_02_01/1,
	   fun research_01_03_01/1]}}.

research_01({Text, Expected, Regex,Replacement})->
    Result = re:replace(Text, Regex, Replacement,[{return, list}]),
	?_assertEqual(Expected, Result).
	
research_01_01_01({Text, Expected, Regex,Replacement})->
	Result = re_tuner:replace(Text,Regex,Replacement),
	?_assertEqual(Expected, Result).

research_01_02_01({Text, Expected, Regex,Replacement})->
	MP = re_tuner:mp(Regex),
	Result = re_tuner:replace(Text,MP,Replacement),
	?_assertEqual(Expected, Result).

research_01_03_01({_Text, _Expected, Regex, Replacement})->
	Expected = "",
	Text = Expected,
	MP = re_tuner:mp(Regex),
	Result = re_tuner:replace(Text,MP,Replacement),
	?_assertEqual(Expected, Result).
	
-endif.
