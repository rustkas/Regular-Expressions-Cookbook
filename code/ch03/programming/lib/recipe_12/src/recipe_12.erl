-module(recipe_12).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

filter(Text,Regex,Function) when is_list(Regex) ->
    MP = re_tuner:mp(Regex),
	Result = filter(Text, MP,Function),
	Result;
filter(Text, MP,Function) when is_tuple(MP) ->
	Result = case re_tuner:all_match(Text,MP) of 
	    nomatch -> nomatch;
		MatchResult -> lists:filter(Function, MatchResult)
	end,	
	Result.

research_test_() ->
    {"Find a Match Within Another Match",
     {foreach,
      local,
      fun build_text_and_expectation/0,
      [fun research_01/1,
       fun research_01_01/1, 
	   fun research_01_02/1,
	   fun research_01_03/1,
	   fun research_01_01_01/1,
	   fun research_01_02_01/1,
	   fun research_01_03_01/1
	   ]}}.

build_text_and_expectation()->
    Expected = ["13", "65"],
	Text = "The lucky numbers are 7, 13, 16, 42, 65, and 99",
	Regex = "\\d+",
	{Text, Expected, Regex}.

research_01({Text, Expected, Regex})->
	MP = re_tuner:mp(Regex),
	MatchResult = re_tuner:all_match(Text, MP),
	Function = fun(Elem)->
		Integer = list_to_integer(Elem),
		Result = (0 =:= (Integer rem 13)),
		Result
	end,
    Result = lists:filter(Function, MatchResult),
	%?debugFmt("~p",[Result]).
	?_assertEqual(Expected, Result).
	
research_01_01({Text, Expected, Regex})->
	Function = fun(Elem)->
		Integer = list_to_integer(Elem),
		Result = (0 =:= (Integer rem 13)),
		Result
	end,
	Result = filter(Text, Regex, Function),
	?_assertEqual(Expected, Result).

research_01_02({Text, Expected, Regex})->
	MP = re_tuner:mp(Regex),
	Function = fun(Elem)->
		Integer = list_to_integer(Elem),
		Result = (0 =:= (Integer rem 13)),
		Result
	end,
	Result = filter(Text, MP, Function),
	?_assertEqual(Expected, Result).

research_01_03({_Text, _Expected, Regex})->
	Expected = nomatch,
	Text = "The lucky numbers are",
	MP = re_tuner:mp(Regex),
	Function = fun(Elem)->
		Integer = list_to_integer(Elem),
		Result = (0 =:= (Integer rem 13)),
		Result
	end,
	Result = filter(Text, MP, Function),
	?_assertEqual(Expected, Result).

research_01_01_01({Text, Expected, Regex})->
	Function = fun(Elem)->
		Integer = list_to_integer(Elem),
		Result = (0 =:= (Integer rem 13)),
		Result
	end,
	Result = re_tuner:filter(Text, Regex, Function),
	?_assertEqual(Expected, Result).

research_01_02_01({Text, Expected, Regex})->
	MP = re_tuner:mp(Regex),
	Function = fun(Elem)->
		Integer = list_to_integer(Elem),
		Result = (0 =:= (Integer rem 13)),
		Result
	end,
	Result = re_tuner:filter(Text, MP, Function),
	?_assertEqual(Expected, Result).

research_01_03_01({_Text, _Expected, Regex})->
	Expected = nomatch,
	Text = "The lucky numbers are",
	MP = re_tuner:mp(Regex),
	Function = fun(Elem)->
		Integer = list_to_integer(Elem),
		Result = (0 =:= (Integer rem 13)),
		Result
	end,
	Result = re_tuner:filter(Text, MP, Function),
	?_assertEqual(Expected, Result).
	
-endif.

