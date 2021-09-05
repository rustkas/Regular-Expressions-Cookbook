-module(match_chain_function).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

match_chain(Text, ListRegex) when is_list(hd(ListRegex)) ->
    List_MP = lists:map(fun(Regex)-> 
	  re_tuner:mp(Regex)
	end, ListRegex),
	
	Result = match_chain(Text, List_MP),
	Result;
match_chain(Text, List_MP) when is_tuple(hd(List_MP)) ->
    
    [HeadMP|RestMP] = List_MP,	   
	MainMatchResult = re_tuner:all_match(Text, HeadMP),
	Result = case MainMatchResult of 
        nomatch -> nomatch;
        _ -> 
	        FindFun = fun Fun(MP, StringList, AccList)-> 
	          case StringList of 
		          [] -> AccList;
		          _ -> 
	                  [Head|Rest] = StringList,
		              case re_tuner:all_match(Head, MP) of
                          nomatch -> Fun(MP, Rest, AccList);
			              InnerMatchResult -> 
				              NewList = AccList ++ InnerMatchResult,
				              Fun(MP, Rest, NewList)
                      end % case
		     end % case
	        end, % fun
	        MP_Fun = fun Fun(StringList, ListMP) ->
		      case ListMP of 
			     [] -> StringList;
				 [Head|Rest] ->
		             MP_Result = FindFun(Head, StringList, []),
					 Fun(MP_Result, Rest)
			  end % case
	      end, % fun
	      MP_Fun(MainMatchResult, RestMP)
    end,        		
    Result.			

build_text_and_expectation()->
	Expected = ["2", "5", "6", "7"],
        Text= "
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
		
{Text, Expected, [OuterRegex, InnerRegex]}.

research_test_() ->
    {"Get the matches of one regex within the matches of another regex",
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


research_01({Text, Expected, ListRegex})->
	List_MP = lists:map(fun(Regex)-> 
	  re_tuner:mp(Regex)
	end, ListRegex),

    [HeadMP|RestMP] = List_MP,	   
	MainMatchResult = re_tuner:all_match(Text, HeadMP),
	      
	FindFun = fun Fun(MP, StringList, AccList)-> 
	          case StringList of 
		          [] -> AccList;
		          _ -> 
	                  [Head|Rest] = StringList,
		              case re_tuner:all_match(Head, MP) of
                          nomatch -> Fun(MP, Rest, AccList);
			              InnerMatchResult -> 
				              NewList = AccList ++ InnerMatchResult,
				              Fun(MP, Rest, NewList)
                      end % case
		     end % case
	      end, % fun
	MP_Fun = fun Fun(StringList, ListMP) ->
		      case ListMP of 
			     [] -> StringList;
				 [Head|Rest] ->
		             MP_Result = FindFun(Head, StringList, []),
					 Fun(MP_Result, Rest)
			  end % case
	      end, % fun
	Result = MP_Fun(MainMatchResult, RestMP),
	?_assertEqual(Expected, Result).

research_01_01({Text, Expected, ListRegex}) ->
	Result = match_chain(Text, ListRegex),
	?_assertEqual(Expected, Result).
	

research_01_02({Text, Expected, ListRegex})->
    List_MP = lists:map(fun(Regex)-> 
	  re_tuner:mp(Regex)
	end, ListRegex),
	Result = match_chain(Text, List_MP),
	?_assertEqual(Expected, Result).

research_01_03({_Text, _Expected, ListRegex})->
    Expected = nomatch,
	Text = "",
	Result = match_chain(Text, ListRegex),
	?_assertEqual(Expected, Result).
	
research_01_01_01({Text, Expected, ListRegex})->
	Result = re_tuner:match_chain(Text, ListRegex),
	?_assertEqual(Expected, Result).

research_01_02_01({Text, Expected, ListRegex})->
    List_MP = lists:map(fun(Regex)-> 
	  re_tuner:mp(Regex)
	end, ListRegex),
	Result = re_tuner:match_chain(Text, List_MP),
	?_assertEqual(Expected, Result).

research_01_03_01({_Text, _Expected, ListRegex})->
	Expected = nomatch,
	Text = "",
	Result = re_tuner:match_chain(Text, ListRegex),
	?_assertEqual(Expected, Result).	
	
-endif.