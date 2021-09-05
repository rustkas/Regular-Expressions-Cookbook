-module(recipe_16).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test0()->
    Expected = {"2",1},
	Text = "1",
    Regex = "\\d+",
	Function = fun (FullString, MatchResult)->
	  Index = element(1,MatchResult),
	  Length = element(2,MatchResult),
	  Offset = Index + Length,
	  SubString = string:slice(FullString, Index, Length),
      Integer = list_to_integer(SubString),
	  Value = Integer * 2,

	  NewSubString = integer_to_list(Value),
	  NewOffset = Index + string:length(NewSubString),
	  FullStringLength = string:length(FullString),
	  NewString = string:slice(FullString, 0, Index) ++ NewSubString ++ string:slice(FullString, Offset, FullStringLength - Offset ),
	  {NewString, NewOffset}
	end,
	  
	Offset = 0,
	MatchResultTuple = re:run(Text,Regex,[{capture,first,index},{offset, Offset}]),
	Result = case MatchResultTuple of
	    nomatch -> Text;
	    {match,[MatchResult]} -> 
		   Function(Text,MatchResult)
	end,
	%?debugFmt("~p",[Result]). 
	?assertEqual(Expected, Result).

research_02_test0()->
    Expected = {"20",2},
	Text = "1",
    Regex = "\\d+",
	Function = fun (FullString, MatchResult)->
	  Index = element(1,MatchResult),
	  Length = element(2,MatchResult),
	  Offset = Index + Length,
	  SubString = string:slice(FullString, Index, Length),
      Integer = list_to_integer(SubString),
	  Value = Integer * 20,

	  NewSubString = integer_to_list(Value),
	  NewOffset = Index + string:length(NewSubString),
	  FullStringLength = string:length(FullString),
	  NewString = string:slice(FullString, 0, Index) ++ NewSubString ++ string:slice(FullString, Offset, FullStringLength - Offset ),
	  {NewString, NewOffset}
	end,
	  
	Offset = 0,
	MatchResultTuple = re:run(Text,Regex,[{capture,first,index},{offset, Offset}]),
	Result = case MatchResultTuple of
	    nomatch -> Text;
	    {match,[MatchResult]} -> 
		   Function(Text,MatchResult)
	end,
	%?debugFmt("~p",[Result]). 
	?assertEqual(Expected, Result).

research_03_test0()->
    Expected = "20 40 60",
	Text = "1 2 3",
    Regex = "\\d+",
	
	ReplaceFun = fun(FullString, MatchResult)->
	  Index = element(1,MatchResult),
	  Length = element(2,MatchResult),
	  Offset = Index + Length,
	  SubString = string:slice(FullString, Index, Length),
      Integer = list_to_integer(SubString),
	  Value = Integer * 20,

	  NewSubString = integer_to_list(Value),
	  NewOffset = Index + string:length(NewSubString),
	  FullStringLength = string:length(FullString),
	  NewString = string:slice(FullString, 0, Index) ++ NewSubString ++ string:slice(FullString, Offset, FullStringLength - Offset ),
	  {NewString, NewOffset}
	end,
	  
	MatchEvaluationFun = fun MatchEvaluator(FullString, EvaluationRegex, Offset) ->
	    RunResult = re:run(FullString,EvaluationRegex,[{capture,first,index},{offset, Offset}]),
		RunResultCheck = case RunResult of
	        nomatch -> FullString;
	        {match,[MatchResult]} -> ReplaceFun(FullString,MatchResult)
	    end,
		MatchEvaluationResult = case is_tuple(RunResultCheck) of
		    true -> 
			     {NewString, NewOffset} = RunResultCheck,
				 MatchEvaluator(NewString, EvaluationRegex, NewOffset);
			_ -> RunResultCheck
        end,
	    MatchEvaluationResult
    end,
	
	StartOffset = 0,
	Result = MatchEvaluationFun(Text,Regex,StartOffset),
	%?debugFmt("~p",[Result]). 
	?assertEqual(Expected, Result).


%-type replace_fun(string(),[string()]) :: {string(), non_neg_integer()}.
%-type replace_fun(string(),[string()]).


-spec match_evaluator(DoAction, Text, Regex) -> Result
   when DoAction :: function(),
        Text :: string(),
		Regex :: string()|tuple(),
		Result :: string().

match_evaluator(DoAction, Text, Regex)  when is_list(Regex) ->
	Result = try
	    MP = re_tuner:mp(Regex),
	    match_evaluator(DoAction, Text, MP)
	of
	    TryResult -> TryResult	
    catch
	    error:_ -> Text
	end,	
	%?debugFmt("Result = ~p",[Result]),
	Result;
match_evaluator(DoAction, Text, MP) when is_tuple(MP)->    
	ReplaceFun = fun(FullString, MatchResult)->
	  Index = element(1,MatchResult),
	  Length = element(2,MatchResult),
	  Offset = Index + Length,
	  SubString = string:slice(FullString, Index, Length),
      
	  NewSubString = DoAction(SubString),
	  
	  NewOffset = Index + string:length(NewSubString),
	  FullStringLength = string:length(FullString),
	  NewString = string:slice(FullString, 0, Index) ++ NewSubString 
	  ++ string:slice(FullString, Offset, FullStringLength - Offset ),
	  {NewString, NewOffset}
	end,

	MatchEvaluationFun = fun MatchEvaluator(FullString, EvaluationMP, Offset) ->
	    RunResult = re:run(FullString, EvaluationMP,[{capture,first,index},{offset, Offset}]),
		RunResultCheck = case RunResult of
	        nomatch -> FullString;
	        {match,[MatchResult]} -> ReplaceFun(FullString,MatchResult)
	    end,
		MatchEvaluationResult = case is_tuple(RunResultCheck) of
		    true -> 
			     {NewString, NewOffset} = RunResultCheck,
				 MatchEvaluator(NewString, EvaluationMP, NewOffset);
			_ -> RunResultCheck
        end,
	    MatchEvaluationResult
    end,
	
	StartOffset = 0,
	Result = MatchEvaluationFun(Text,MP,StartOffset),
	Result.

research_04_01_test()->
    Expected = "20 40 60",
	Text = "1 2 3",
    Regex = "\\d+",
	
	DoAction = fun(SubString)->
	  Integer = list_to_integer(SubString),
	  Value = Integer * 20,
	  NewSubString = integer_to_list(Value),
	  NewSubString
	end,
	
	Result = match_evaluator(DoAction, Text,Regex),
	?assertEqual(Expected, Result).

research_04_02_test()->
    Expected = "20 40 60",
	Text = "1 2 3",
    Regex = "\\d+",
	MP = re_tuner:mp(Regex),
	
	DoAction = fun(SubString)->
	  Integer = list_to_integer(SubString),
	  Value = Integer * 20,
	  NewSubString = integer_to_list(Value),
	  NewSubString
	end,
	
	Result = match_evaluator(DoAction, Text, MP),
	?assertEqual(Expected, Result).

research_04_03_test()->
    Expected = "",
	Text = "",
    Regex = "\\d+",
	MP = re_tuner:mp(Regex),
	
	DoAction = fun(SubString)->
	  Integer = list_to_integer(SubString),
	  Value = Integer * 20,
	  NewSubString = integer_to_list(Value),
	  NewSubString
	end,
	
	Result = match_evaluator(DoAction, Text, MP),
	?assertEqual(Expected, Result).

research_04_04_test()->
    Expected = "1 2 3",
	Text = "1 2 3",
    Regex = "\\d(",
	
	
	DoAction = fun(SubString)->
	  Integer = list_to_integer(SubString),
	  Value = Integer * 20,
	  NewSubString = integer_to_list(Value),
	  NewSubString
	end,
	
	Result = match_evaluator(DoAction, Text, Regex),
	?assertEqual(Expected, Result).
	

build_input_and_expectation()->
    Expected = "20 40 60",
	Text = "1 2 3",
    Regex = "\\d+",

    DoAction = fun(SubString)->
	  Integer = list_to_integer(SubString),
	  Value = Integer * 20,
	  NewSubString = integer_to_list(Value),
	  NewSubString
	end,
    {Text, Expected, Regex, DoAction}.


research_test_() ->
    {"Replace Matches with Replacements Generated in Code",
     {foreach,
      local,
      fun build_input_and_expectation/0,
      [
	   fun research_01_01_01/1,
	   fun research_01_02_01/1,
	   fun research_01_03_01/1]}}.

research_01_01_01({Text, Expected, Regex, DoAction})->
	Result = re_tuner:match_evaluator(DoAction, Text, Regex),
	?_assertEqual(Expected, Result).

research_01_02_01({Text, Expected, Regex, DoAction})->
	MP = re_tuner:mp(Regex),
	Result = re_tuner:match_evaluator(DoAction, Text, MP),
	?_assertEqual(Expected, Result).

research_01_03_01({_Text, _Expected, Regex, DoAction})->
	Expected = "",
	Text = Expected,
	MP = re_tuner:mp(Regex),
	Result = re_tuner:match_evaluator(DoAction, Text, MP),
	?_assertEqual(Expected, Result).	


-endif.

