-module(recipe_18_unicode_01).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").
research_13_test0()->
    Text1 = unicode:characters_to_binary("“"),
	Text2 = unicode:characters_to_binary("1"),
	Text3 = unicode:characters_to_binary("”"),
    %Text = Text1 ++  Text2 ++ Text3,
	Text = list_to_binary([Text1, Text2, Text3]),
	?debugFmt("Text = ~ts, Byte size = ~p",[Text,byte_size(Text)]),
	?assert(true).
	

research_12_test0()->
    %Text = "<div> “text” <span class=\"middle\">“text”</span></div>",

	Text1 = unicode:characters_to_binary("<div>"),
    ?debugFmt("NewSubString = ~ts, Byte size = ~p",[Text1,byte_size(Text1)]),
	
	Text2 = unicode:characters_to_binary("“"),
	?debugFmt("Text2 = ~ts, Byte size = ~p",[Text2, byte_size(Text2)]),
	
	Text3 = unicode:characters_to_binary("“”"),
	?debugFmt("Text3 = ~ts, Byte size = ~p",[Text3, byte_size(Text3)]),
	?debugFmt("Text3[0] = ~ts, Byte size = ~p",[binary_part(Text3, {0,3}), byte_size(binary_part(Text3, {0,3}))]),
	
	
	%?debugFmt("NewSubString = ~ts",[NewSubString]),
	%FullStringLength = string:length(FullString),
	%FullStringLength =  byte_size(FullStringBinary),
    ?assert(true).
	
	
research_11_test0()->
	Text = "<div> “text” <span class=\"middle\">“text”</span></div>",
	OuterRegex = "<[^<>]*>",
	EvaluationMP = re_tuner:mp(OuterRegex,[unicode]), 
	LastIndex = 47,
	StringLength = string:length(Text),
	%?debugFmt("StringLength = ~p",[StringLength]),
	%?debugFmt("SubString = ~ts",[string:slice(Text, 0, LastIndex)]),
	
	
	
	RunResult = re:run(Text, EvaluationMP,[{capture,first,list}, {offset, StringLength-3}]),
	?debugFmt("Result = ~p",[RunResult]),
	?debugFmt("SubString = ~ts",[string:slice(Text, 0, StringLength-3)]),
	?assert(true).
	
research_10_test0()->
	Text = unicode:characters_to_binary(
	"<div> \"text\" <span class=\"middle\">\"text\"</span></div>"
	),
    OuterRegex = "<[^<>]*>",
	InnerRegex = "\"([^\"]*)\"",
	FullString = Text,
	LastIndex = 0,
	InnerReplacement = unicode:characters_to_binary("“\\1”"),
	EvaluationMP = re_tuner:mp(OuterRegex,[unicode]), 
	InnerMP = re_tuner:mp(InnerRegex,[unicode]), 
	
	Result = match_evaluator(FullString, LastIndex, EvaluationMP, InnerMP, InnerReplacement),
    ?debugFmt("Result = ~ts",[Result]),
	?assert(true).

research_09_test()->
	Text = unicode:characters_to_binary("<div> \"text\" <span class=\"middle\"></div>")
    ,
    OuterRegex = "<[^<>]*>",
	InnerRegex = "\"([^\"]*)\"",
	FullString = Text,
	LastIndex = 0,
 	InnerReplacement = unicode:characters_to_binary("“\\1”")
	,
	EvaluationMP = re_tuner:mp(OuterRegex,[unicode]), 
	InnerMP = re_tuner:mp(InnerRegex,[unicode]), 
	
	Result = match_evaluator(FullString, LastIndex, EvaluationMP, InnerMP, InnerReplacement),
    ?debugFmt("Result = ~ts",[Result]),
	?assert(true).

research_08_test0()->
	Text = 
    "\"text\" <span class=\"middle\">",
    OuterRegex = "<[^<>]*>",
	InnerRegex = "\"([^\"]*)\"",
	FullString = Text,
	LastIndex = 0,
	InnerReplacement = "“\\1”",
	EvaluationMP = re_tuner:mp(OuterRegex,[unicode]), 
	InnerMP = re_tuner:mp(InnerRegex,[unicode]), 
	
	Result = match_evaluator(FullString, LastIndex, EvaluationMP, InnerMP, InnerReplacement),
    ?debugFmt("Result = ~ts",[Result]),
	?assert(true).

research_07_test0()->
    
	OuterRegex = "\\d",
	InnerRegex = "-",
	FullString = "-1",
	LastIndex = 0,
	InnerReplacement = "*",
	EvaluationMP = re_tuner:mp(OuterRegex,[unicode]), 
	InnerMP = re_tuner:mp(InnerRegex,[unicode]), 
	
	Result = match_evaluator(FullString, LastIndex, EvaluationMP, InnerMP, InnerReplacement),
    ?debugFmt("Result = ~p",[Result]),
	?assert(true).

research_06_test0()->
    {Text, Expected, OuterRegex, InnerRegex, InnerReplacement} = 
		build_text(),
	Tag = "<body>",	
    {SetuppedText, SetupOffset} = setup(Text, Tag),
	?debugFmt("SetupOffset = ~p",[SetupOffset]),
	?debugFmt("SetuppedText = ~ts",[string:slice(SetuppedText, 0, SetupOffset)]),
	FullString = Text,
	LastIndex = SetupOffset,
	EvaluationMP = re_tuner:mp(OuterRegex,[unicode]), 
	InnerMP = re_tuner:mp(InnerRegex,[unicode]), 
	
	Result = match_evaluator(FullString, LastIndex, EvaluationMP, InnerMP, InnerReplacement),
    ?debugFmt("Result = ~ts",[Result]),
	?assert(true).	

research_05_test0()->
    
	
	WithoutUnocode = fun()->
	    Regex = "\\d",
	    {ok, MP} = re:compile(Regex,[unicode]),
	    Text = "-1",
	    {match, Result} = re:run(Text,MP),
	    ?debugFmt("Without Unicode Result = ~p",[Result])
	
	end,
	
	WithUnocode = fun()->
	    Regex = "\\d",
	    {ok, MP} = re:compile(Regex,[unicode]),
	    Text = "“1",
	    {match, [Result]} = re:run(Text,MP),
	    ?debugFmt("With Unicode Result = ~p",[Result]),
		Binary = unicode:characters_to_binary(Text),
		?debugFmt("Binary = ~p",[Binary]),
		
		{PosIndex,Length} = Result,
		SubBinary = binary_part(Binary, {0,PosIndex+1}),
		SubList = unicode:characters_to_list(SubBinary),
		CharacterIndex = string:length(SubBinary) - 1,
		?debugFmt("Tuned With Unicode Result = ~p",[{CharacterIndex,Length}])
	
	end,
	
	WithoutUnocode(),
	WithUnocode(),
	
	
	
	
	?assert(true).

research_04_test0()->
	Expected = 
"<div>
    “text” <span class=“middle“>“text”</span> “text”
	</div>",
	SanitizedExpected = sanitize_text(Expected),
	Text = 
"<div>
    \"text\" <span class=\"middle\">\"text\"</span> \"text\"
	</div>",
	%SanitizedText = sanitize_text(Text),
    Regex = "\"([^\"]*)\"",
	MP = re_tuner:mp(Regex,[unicode]),
	
	Replacement = "“\\1”",
	
	Result = do_replace(Text, MP, Replacement),
	%?assertEqual(SanitizedExpected,Result),
	
	Zip = lists:zip(SanitizedExpected,Result),
	?assertEqual(length(SanitizedExpected), length(Result)),
	%?debugFmt("~p",[Zip]),
	lists:all(fun(Elem)-> 
	    ?debugFmt("Expected= ~p, Result = ~p", [element(1,Elem), element(2,Elem)]),
		%?assertEqual(element(1,Elem), element(2,Elem))
		element(1,Elem) =:= element(2,Elem)
	end,Zip),
	%?assert(string:equal(SanitizedExpected, Result)),
	%?debugFmt("length(SanitizedExpected) = ~p",[length(SanitizedExpected)]),
	%?debugFmt("SanitizedExpected = ~ts",[SanitizedExpected]),
	%?debugFmt("SanitizedText = ~ts",[SanitizedText]),
	%?debugFmt("Result = ~ts",[Result]),
	?assert(true).
	

research_03_test0()->
	{Text, Expected, OuterRegex, InnerRegex, InnerReplacement} = 
		build_text(),
	Tag = "<body>",	
    {SetuppedText, SetupOffset} = setup(Text, Tag),	
	Result = remplace_matches(SetuppedText, OuterRegex, InnerRegex, InnerReplacement,[unicode],[unicode],SetupOffset),
	?debugFmt("Result = ~ts",[Result]),
	?assert(true).
	
research_02_test0()->
	{Text, Expected, OuterRegex, InnerRegex, InnerReplacement} = 
		build_text(),
	Result = remplace_matches(Text, OuterRegex, InnerRegex, InnerReplacement,[unicode],[unicode],0),
	?debugFmt("Result = ~ts",[Result]),
	?assert(true).

research_01_test0()->
	{Text, Expected, OuterRegex, InnerRegex, InnerReplacement} = 
		build_text(),
	%?debugFmt("Text = ~ts",[Text]),
	%?debugFmt("Expected = ~ts",[Expected]),
	%?debugFmt("OuterRegex = ~ts",[OuterRegex]),
	%?debugFmt("InnerRegex = ~ts",[InnerRegex]),
	%?debugFmt("InnerReplacement = ~ts",[InnerReplacement]),
	?assert(true).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

match_evaluator(FullString, LastIndex, EvaluationMP, InnerMP, InnerReplacement) ->
    RunResult = re:run(FullString, EvaluationMP,[{capture,first,index},{offset, LastIndex}]),
	RunResultCheck = case RunResult of
	        nomatch -> {FullString,LastIndex};
	        {match, [MatchResult]} -> 
				Index = element(1,MatchResult),
				SubBinary = binary_part(FullString, {0,Index+1}),
				?debugFmt("SubBinary = ~ts",[SubBinary]),
				CharacterIndex = byte_size(SubBinary) - 1,
				
				Length = element(2, MatchResult),
			    replace_string(FullString, LastIndex, {CharacterIndex,Length}, InnerMP, InnerReplacement)
	    end,

	{CurrentString, CurrentIndex} = RunResultCheck,
	CurrentStringLength = byte_size(CurrentString),
	MatchEvaluationResult = case CurrentIndex < CurrentStringLength of  
		    true ->
			    match_evaluator(CurrentString, CurrentIndex, EvaluationMP, InnerMP, InnerReplacement);
			false -> 
			    CurrentString
        end,
	MatchEvaluationResult.

replace_string(FullStringBinary, LastIndex, MatchResult, MP, Replacement) ->
	  Index = element(1,MatchResult),
	  Length = element(2,MatchResult),
	  
	  
	  SubStringBinary = binary_part(FullStringBinary, LastIndex, Index - LastIndex),
	  %?debugFmt("SubStringBinary = ~ts",[SubStringBinary]),
	  Result = case (match == re:run(SubStringBinary, MP, [{capture,none}])) of 
	      true ->
			  NewSubStringBinary = do_replace(SubStringBinary,MP,Replacement),
			  
			  %?debugFmt("NewSubStringBinary = ~ts",[NewSubStringBinary]),
			  Part1 = binary_part(FullStringBinary, 0, Index - LastIndex),
			  Part2 = NewSubStringBinary,
        
              FullStringBinarySize = byte_size(FullStringBinary),
			  Part3 = binary_part(FullStringBinary, Index, FullStringBinarySize - Index),

			  NewString = list_to_binary([Part1, Part2, Part3]),
			  
			  NewSubStringLength =  byte_size(NewSubStringBinary),
			  {NewString, LastIndex + NewSubStringLength + Length};
		  false -> 
			  Offset = Index + Length,
			  {FullStringBinary, Offset}
          end,
     Result.

do_replace(Text, MP, Replacement) ->
    Result = re:replace(Text, MP, Replacement,[global,{return, binary}]),
	Result.

sanitize_text(Text) when is_list(Text)->
    SanitizedText = string:replace(Text, [$\r,$\n], [$\n], all),
	FlattenText = lists:flatten(SanitizedText),
    FlattenText.


	

setup(FullString,Tag) when is_list(Tag)->
	    SanitizedText = string:replace(FullString, [$\r,$\n], [$\n], all),
		TrimmedString = string:trim(SanitizedText),
	    SetupMP = re_tuner:mp(Tag,[unicode]),
	    {match, [MatchResult]} = re:run(TrimmedString, SetupMP,[{capture,first,index}]),
		
		%?debugFmt("MatchResult = ~p",[MatchResult]),
		%		?debugFmt("MatchResult2 = ~p",[string:slice(FullString, 0, element(1,MatchResult)) ]),
		Index = element(1,MatchResult),
	    Length = element(2,MatchResult),
	    Offset = Index + Length,
		{TrimmedString, Offset}.

remplace_matches(Text, OuterRegex, InnerRegex, Replacement, OuterRegexOptions, InnerRegexOptions,Offset) 
       when is_list(OuterRegex), is_list(InnerRegex),is_list(OuterRegexOptions),is_list(InnerRegexOptions) ->
	Result = try
	    MP = re_tuner:mp(OuterRegex,OuterRegexOptions),
		InnerMP = re_tuner:mp(InnerRegex, InnerRegexOptions),
		
	    remplace_matches(Text, MP, InnerMP, Replacement,Offset)
	of
	    TryResult -> TryResult	
    catch
	    error:_ -> Text
	end,	
	Result.
	
	
remplace_matches(Text, OuterRegex, InnerRegex, Replacement,Offset)  when is_list(OuterRegex), is_list(InnerRegex) ->
	Result = try
	    MP = re_tuner:mp(OuterRegex),
		InnerMP = re_tuner:mp(InnerRegex),
		
	    remplace_matches(Text, MP, InnerMP, Replacement,Offset)
	of
	    TryResult -> TryResult	
    catch
	    error:_ -> Text
	end,	
	Result;
remplace_matches(Text, MP, InnerMP, InnerReplacement,Offset) when is_tuple(MP), is_tuple(InnerMP)-> 
	Result = Text,
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
    “text” <span class=\"middle\">“text”</span> \"text\"
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

-endif.
