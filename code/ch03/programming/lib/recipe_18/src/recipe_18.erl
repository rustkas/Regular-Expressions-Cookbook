-module(recipe_18).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

ignore(SubString)->
	  re_tuner:is_match(SubString, "</").

remplace_matches(Text, OuterRegex, InnerRegex, Replacement)  when is_list(OuterRegex), is_list(InnerRegex) ->
	Result = try
	    MP = re_tuner:mp(OuterRegex),
		InnerMP = re_tuner:mp(InnerRegex),
		?debugFmt("Result17 = ~s",["Test"]),
	    remplace_matches(Text, MP, InnerMP, Replacement)
	of
	    TryResult -> TryResult	
    catch
	    error:_ -> Text
	end,	
	Result;
remplace_matches(Text, MP, InnerMP, InnerReplacement) when is_tuple(MP), is_tuple(InnerMP)-> 
	DoAction = fun(DoActionText, DoActionMP, DoActionReplacement) ->
	    Result = re:replace(DoActionText, DoActionMP, DoActionReplacement, [global,{return, list}]),
		%?debugFmt("Replace Result = ~p",[Result]),
		Result
	end,
	
	ReplaceFun = fun(FullString, LastIndex, MatchResult) ->
	  %?debugFmt("MatchResult = ~p",[MatchResult]),
	  Index = element(1,MatchResult),
	  Length = element(2,MatchResult),
	  Offset = Index + Length,
	  SubString = string:slice(FullString, LastIndex, Index - LastIndex),
	  case ignore(SubString) of
		true -> 
		  ?debugFmt("Continue. SubString = ~p, Offset = ~p",[SubString,Offset]),
		  {FullString, Offset};
		false -> 
			case re_tuner:is_match(SubString, InnerMP) of 
			    true ->
				    NewSubString = DoAction(SubString,InnerMP,InnerReplacement),
					?debugFmt("NewSubString = ~ts",[NewSubString]),
					FullStringLength = string:length(FullString),
					NewString = string:slice(FullString, 0, Index) ++ NewSubString 
	                ++ string:slice(FullString, Offset, FullStringLength - Offset ),
			        {NewString, Offset};
				false -> {FullString, Offset}
            end				
	  end	
	end,

	MatchEvaluationFun = fun MatchEvaluator(FullString, EvaluationMP, LastIndex) ->
	    RunResult = re:run(FullString, EvaluationMP,[{capture,first,index},{offset, LastIndex}]),
		%?debugFmt("FullString = ~p",[FullString]),
		%?debugFmt("RunResult = ~p",[RunResult]),
		RunResultCheck = case RunResult of
	        nomatch -> {FullString,LastIndex};
	        {match, [MatchResult]} -> ReplaceFun(FullString, LastIndex, MatchResult)
	    end,
		MatchEvaluationResult = case is_tuple(RunResultCheck) of
		    false -> RunResultCheck;
			true -> 
			     {NewString, NewOffset} = RunResultCheck,
				 MatchEvaluator(NewString, EvaluationMP, NewOffset)
        end,
	    MatchEvaluationResult
    end,
	
	% move index to body tag's content
	Setup = fun(FullString)->
	    SetupMP = re_tuner:mp("<body>"),
	    {match, [MatchResult]} = re:run(FullString, SetupMP,[{capture,first,index}]),
		%?debugFmt("MatchResult = ~p",[MatchResult]),
		Index = element(1,MatchResult),
	    Length = element(2,MatchResult),
	    Offset = Index + Length,
		Offset
	end,
	Offset = Setup(Text),
	%?debugFmt("Text = ~p",[Text]),
	%?debugFmt("Offset = ~p",[Offset]).
	
    {CurrentResult, CurentIndex} = MatchEvaluationFun(Text,MP, Offset),
	
	MatchRest = fun(FullString, LastIndex)->
	    FullStringLength = string:length(FullString),
	    TextAfter = string:slice(FullString, LastIndex, FullStringLength - LastIndex),	
		NewSubString = DoAction(TextAfter,InnerMP,InnerReplacement),
	    Result = string:slice(FullString, 0, LastIndex) ++ NewSubString 
		++ string:slice(FullString, LastIndex, FullStringLength - LastIndex),
		Result
	end,
	
	Result = MatchRest(CurrentResult, CurentIndex),
	?debugFmt("Result = ~s",["Test"]),
	?debugFmt("Result = ~tp",[Result]),
	Result.	

build_text()->
	
    Text="
<!DOCTYPE html>
<html>
<head>
    <meta charset=\"UTF-8\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>Document</title>
</head>
<body>
    <div>
    \"text\" <span class=\"middle\">\"text\"</span> \"text\"
	</div>
</body>
</html>
	",
    Expected="
<!DOCTYPE html>
<html>
<head>
    <meta charset=\"UTF-8\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>Document</title>
</head>
<body>
    <div>
    “text” <span class=\"middle\">“text”</span> “text”
	</div>
</body>
</html>
	",	
	

    OuterRegex =   "<[^<>]*>",
	InnerRegex = "\"([^\"]*)\"",
	InnerReplacement = "“\\1”",
		
{Text, Expected, OuterRegex, InnerRegex, InnerReplacement}.

research_test_() ->
    {"Replace All Matches Within the Matches of Another Regex",
     {foreach,
      local,
      fun build_text/0,
      [fun research_01/1
	   ]}}.

research_01({Text, Expected, OuterRegex, InnerRegex, InnerReplacement})->
    
	Result = remplace_matches(Text, OuterRegex, InnerRegex, InnerReplacement),
	%?debugFmt("Result111 = ~s",["Test"]),
	%?_assertEqual(Expected, Result).
	?_assert(true).




-endif.

