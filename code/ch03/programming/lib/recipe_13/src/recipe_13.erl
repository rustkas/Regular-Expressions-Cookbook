-module(recipe_13).

%%
%% Tests
%%
-ifdef(TEST).


-include_lib("eunit/include/eunit.hrl").

subfilter(Text, OuterRegex, InnerRegex) when is_list(OuterRegex), is_list(InnerRegex) ->
	OuterMP = re_tuner:mp(OuterRegex),
	InnerMP = re_tuner:mp(InnerRegex),
	Result = subfilter(Text, OuterMP, InnerMP),
	Result;
subfilter(Text, OuterMP, InnerMP) when is_tuple(OuterMP), is_tuple(InnerMP) ->
	MatchResult = re_tuner:all_match(Text, OuterMP),
    case MatchResult of 
	    nomatch -> nomatch;
		_-> InnerFunction = fun Fun (StringList, List)-> 
	         case StringList of 
		         [] -> List;
		         _  -> 
	              [Head|Rest] = StringList,
		          case re_tuner:all_match(Head, InnerMP) of
                      nomatch -> Fun(Rest, List);
			          InnerMatchResult -> 
				          NewList = List ++ InnerMatchResult,
				          Fun(Rest,NewList)
                  end
		     end
		  end,
		  Result = InnerFunction(MatchResult, []),
	      Result
    end.

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
	   fun research_01_03_01/1,
	   fun research_02_01_test/1]}}.


build_text_and_expectation()->
	Expected = ["2", "5", "6", "7"],
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
    <b>2</b> 3 4 <b>5 6 7</b> <b>a</b>
	</div>
</body>
</html>
	",
	
    OuterRegex = "<b>(.*?)</b>",
	InnerRegex = "\\d+",
		
{Text, Expected, OuterRegex, InnerRegex}.

research_01({Text, Expected, OuterRegex, InnerRegex})->
    OuterMP = re_tuner:mp(OuterRegex),
	InnerMP = re_tuner:mp(InnerRegex),
	MatchResult = re_tuner:all_match(Text, OuterMP),
	%?debugFmt("~p",[MatchResult]),
	
	FullInnerMatchResult = [],
	InnerFunction = fun Fun (StringList, List)-> 
	      case StringList of 
		      [] -> List;
		      _ -> 
	              [Head|Rest] = StringList,
		          case re_tuner:all_match(Head, InnerMP) of
                      nomatch -> Fun(Rest, List);
			          InnerMatchResult-> 
				          NewList = List ++ InnerMatchResult,
				          Fun(Rest,NewList)
                  end
		  end
	end,
	Result = InnerFunction(MatchResult, FullInnerMatchResult),
	%?debugFmt("~p",[Result]).
	?_assertEqual(Expected, Result).
	
research_01_01({Text, Expected, OuterRegex, InnerRegex})->
	Result = subfilter(Text, OuterRegex, InnerRegex),
	?_assertEqual(Expected, Result).

research_01_02({Text, Expected, OuterRegex, InnerRegex})->
	OuterMP = re_tuner:mp(OuterRegex),
	InnerMP = re_tuner:mp(InnerRegex),
	Result = subfilter(Text, OuterMP, InnerMP),
	?_assertEqual(Expected, Result).

research_01_03({_Text, _Expected, OuterRegex, InnerRegex})->
	Expected = nomatch,
	Text = "",
	OuterMP = re_tuner:mp(OuterRegex),
	InnerMP = re_tuner:mp(InnerRegex),
	Result = subfilter(Text, OuterMP, InnerMP),
	?_assertEqual(Expected, Result).

research_01_01_01({Text, Expected, OuterRegex, InnerRegex})->
	Result = re_tuner:subfilter(Text, OuterRegex, InnerRegex),
	?_assertEqual(Expected, Result).

research_01_02_01({Text, Expected, OuterRegex, InnerRegex})->
	OuterMP = re_tuner:mp(OuterRegex),
	InnerMP = re_tuner:mp(InnerRegex),
	Result = re_tuner:subfilter(Text, OuterMP, InnerMP),
	?_assertEqual(Expected, Result).

research_01_03_01({_Text, _Expected, OuterRegex, InnerRegex})->
	Expected = nomatch,
	Text = "",
	OuterMP = re_tuner:mp(OuterRegex),
	InnerMP = re_tuner:mp(InnerRegex),
	Result = re_tuner:subfilter(Text, OuterMP, InnerMP),
	?_assertEqual(Expected, Result).	

research_02_01_test({Text, Expected, _OuterRegex, _InnerRegex})->
	Regex = "\\d+(?=(?:(?!<b>).)*</b>)",
	MP = re_tuner:mp(Regex),
	Result = re_tuner:all_match(Text, MP),
	%?debugFmt("~p",[Result]),
	%?_assert(true).
	?_assertEqual(Expected, Result).

-endif.