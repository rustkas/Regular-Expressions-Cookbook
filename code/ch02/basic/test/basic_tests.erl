% Active code page: 65001 - UTF-8 Encoding
% chcp 65001
%
-module(basic_tests).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").
% Add commond helper files to the module
-include("helper.util").

% Match Literal Text
research_01_test() ->
    Expected = ["The punctuation characters in the ASCII table are: !\"#\$%&'\(\)\*\+,-\./:;<=>\?@\[\\]\^_`\{\|}~"],
    Text = [Expected],
    Regex = "The punctuation characters in the ASCII table are: \\Q!\"#\$%&'\(\)\*\+,-\./:;<=>\?@\[\\]\^_`\{\|}~\\E",
	{match, Result} = re:run(Text, get_mp(Regex), [{capture,first,list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).

% Case-insensitive matching
research_02_01_test() ->
    Expected = [["regex"],["Regex"],["REGEX"],["ReGeX"]],
    Text = "regex but not Regex, REGEX, or ReGeX",
    Regex = "(?i)regex",
	{match, Result} = re:run(Text, get_mp(Regex), [global,{capture,first,list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).

research_02_02_test() ->
    Expected = [["regex"],["Regex"],["REGEX"],["ReGeX"]],
    Text = "regex but not Regex, REGEX, or ReGeX",
    Regex = "regex",
	{match, Result} = re:run(Text, get_mp(Regex,[caseless]), [global,{capture,first,list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).

%  local mode modifiers
research_03_01_test() ->
    Expected = [["sensitiveCASELESSsensitive"]],
    Text = "sensitiveCASELESSsensitive",
    Regex = "sensitive(?i)caseless(?-i)sensitive",
	{match, Result} = re:run(Text, get_mp(Regex), [global,{capture,first,list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).

research_03_02_test() ->
    Expected = nomatch,
    Text = "SENSITIVEcaselessSENSITIVE",
    Regex = "sensitive(?i)caseless(?-i)sensitive",
	Result = re:run(Text, get_mp(Regex), [global,{capture,first,list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).
	
% Match Nonprintable Characters
% bell, escape, form feed, line feed, carriage return, horizontal tab, vertical tab	
% hexadecimal ASCII codes: 0x07, 0x1B, 0x0C, 0x0A, 0x0D, 0x09, 0x0B.	
research_04_01_test() ->
    Expected = [[16#07, 16#1B, 16#0C, 16#0A, 16#0D, 16#09, 16#0B]],
    Text = [16#07, 16#1B, 16#0C, 16#0A, 16#0D, 16#09, 16#0B],
    Regex = "\\a\\e\\f\\n\\r\\t\\v",
	{match, Result} = re:run(Text, get_mp(Regex), [{capture,first,list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).

% Match One of Many Characters
research_05_01_test() ->
    Expected = [["calendar"],["celendar"],["calandar"],["calender"]],
    Text = "calendar celendar calandar calender",
    Regex = "c[ae]l[ae]nd[ae]r",
	{match, Result} = re:run(Text, get_mp(Regex), [global,{capture,first,list}]),
    %?debugFmt("~p~n",[Result]).
    ?assertEqual(Expected, Result).
	
% Match any characters	
research_06_01_test() ->

    List = lists:seq(0,127),

    {ok,MP}= re:compile("[\\s\\S]"),
    lists:all(fun(Elem)-> 
        Text = [Elem],
        match == re:run(Text, MP, [{capture,none}])
    end, List).

research_06_02_test() ->

    List = lists:seq(0,127),

    {ok,MP}= re:compile("[\\d\\D]"),
    lists:all(fun(Elem)-> 
        Text = [Elem],
        match == re:run(Text, MP, [{capture,none}])
    end, List).

research_06_03_test() ->

    List = lists:seq(0,127),

    {ok,MP}= re:compile("[\\w\\W]"),
    lists:all(fun(Elem)-> 
        Text = [Elem],
        match == re:run(Text, MP, [{capture,none}])
    end, List).

research_07_01_test() ->
	Expected = match,
    Text1 = "05/16/08",
	Text2 = "99/99/99",
	Text3 = "12345678",
    Regex = "\\d\\d[/.\-]\\d\\d[/.\-]\\d\\d",
	?assertEqual(Expected, re:run(Text1, get_mp(Regex), [{capture,none}])),
    ?assertEqual(Expected, re:run(Text2, get_mp(Regex), [{capture,none}])),
    ?assertEqual(nomatch, re:run(Text3, get_mp(Regex), [{capture,none}])).
    
research_08_01_test() ->
	Text = "alpha ",
    Regex = "^alpha",
	?assertEqual(match, re:run(Text, get_mp(Regex), [{capture,none}])).
	
research_08_02_test() ->
	Text = "alpha ",
    Regex = "\\Aalpha",
	?assertEqual(match, re:run(Text, get_mp(Regex), [{capture,none}])).
	
research_08_03_test() ->
	Text = " omega",
    Regex = "omega$",
	?assertEqual(match, re:run(Text, get_mp(Regex), [{capture,none}])).	

research_08_04_test() ->
	Text = " omega",
    Regex = "omega\\z",
	?assertEqual(match, re:run(Text, get_mp(Regex), [{capture,none}])).	

research_08_05_test() ->
	Text = " omega\n",
    Regex = "omega\\Z",
	?assertEqual(match, re:run(Text, get_mp(Regex), [{capture,none}])).	 
	
research_08_06_test() ->
	Text = " omega\r\n",
    Regex = "omega\\Z",
	?assertEqual(match, re:run(Text, get_mp(Regex), [{capture,none},{newline, crlf}])).	 	

research_09_01_test() ->
    Expected = ["cat"], 
    Text1="My cat is brown",
	Text2="category or bobcat",
    Regex = "\\bcat\\b",
    {match, Result1} = re:run(Text1, get_mp(Regex), [{capture,first,list}]),
	Result2 = re:run(Text2, get_mp(Regex), [global,{capture,first,list}]),
    ?assertEqual(Expected,Result1),
	?assertEqual(nomatch,Result2).
 
research_09_02_test() ->
    Expected = ["cat"], 
    Text1="My cat is brown",
	Text2="category or bobcat",
	Text3="staccato",
    Regex = "\\Bcat\\B",
    Result1 = re:run(Text1, get_mp(Regex), [{capture,first,list}]),
	Result2 = re:run(Text2, get_mp(Regex), [global,{capture,first,list}]),
	{match, Result3} = re:run(Text3, get_mp(Regex), [{capture,first,list}]),
    ?assertEqual(nomatch,Result1),
	?assertEqual(nomatch,Result2),
	?assertEqual(Expected,Result3).

% Use a regular expression to find the trademark sign (™)
research_10_01_test() ->
	Expected = ["™"], 
	Text = [Expected],
	Regex = "\\x{2122}",
	{ok,MP} = re:compile(Regex,[unicode]),
	{match, Result} = re:run(Text, MP, [{capture,first,list}]),
	?assertEqual(Expected,Result).
	
% Match any character is in the “Currency Symbol” Unicode category	
research_10_02_test() ->	
	List = lists:seq(16#20A0,16#20BF),	
	%?debugFmt("List size = ~p~n",[length(List)]),
	Regex = "\\p{Sc}",
	{ok,MP} = re:compile(Regex,[unicode,ucp ]),
	lists:all(fun(Elem)->
	    Text = [Elem],
		
        _Result = re:run(Text, MP, [{capture,none}]),
		%?debugFmt("Currency = ~ts, Value = ~p, Result = ~p~n",[Text, Elem, Result]),
		true
	end,List).
-endif.
