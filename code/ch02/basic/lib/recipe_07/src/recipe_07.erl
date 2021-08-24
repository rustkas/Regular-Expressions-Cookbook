-module(recipe_07).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

% Unicode code point
research_01_test() ->
    Expected = ["™"],
    Text = [Expected],
    Regex = "\\x{2122}",
    {ok, MP} = re:compile(Regex, [unicode]),
    {match, Result} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

% Unicode category
% Match any character is in the “Currency Symbol” Unicode category
research_02_test() ->
    List = lists:seq(16#20A0, 16#20BF),
    %?debugFmt("List size = ~p~n",[length(List)]),
    Regex = "\\p{Sc}",
    {ok, MP} = re:compile(Regex, [unicode, ucp]),
    lists:all(fun(Elem) ->
                 Text = [Elem],

                 _Result = re:run(Text, MP, [{capture, none}]),
                 %?debugFmt("Currency = ~ts, Value = ~p, Result = ~p~n",[Text, Elem, Result]),
                 true
              end,
              List).

% Unicode category
% Check Unicode categories
research_03_test() ->
    RegexList =
        ["\\p{L}", "\\p{Ll}", "\\p{Lu}", "\\p{Lt}", "\\p{Lm}", "\\p{Lo}", "\\p{M}",
         "\\p{Mn}", "\\p{Mc}", "\\p{Me}", "\\p{Z}", "\\p{Zs}", "\\p{Zl}", "\\p{Zp}",
         "\\p{S}", "\\p{S}", "\\p{Sm}", "\\p{Sc}", "\\p{Sk}", "\\p{So}", "\\p{N}",
         "\\p{Nd}", "\\p{Nl}", "\\p{No}", "\\p{P}", "\\p{Pd}", "\\p{Ps}", "\\p{Pe}",
         "\\p{Pi}", "\\p{Pf}", "\\p{Pc}", "\\p{Po}", "\\p{C}", "\\p{Cc}", "\\p{Cf}",
         "\\p{Co}", "\\p{Cs}", "\\p{Cn}"]
        ++ ["\\p{L&}"],

    lists:foreach(fun(Elem) ->
                     Regex = Elem,
                     {ok, _MP} = re:compile(Regex, [unicode])
                  end,
                  RegexList).

% Unicode block
research_04_01_test() ->
    Expected = "[\\x0-\\x7F]",
    Range = re_tuner:unicode_block("\\p{InBasicLatin}"),
    Result = Range,
    ?assertEqual(Expected, Result).

research_04_02_test0()->
    Expected = true,
    List = lists:seq(16#370, 16#3FF),
    Regex = re_tuner:unicode_block("\\p{InGreekandCoptic}"),
	?debugFmt("Regex = ~p~n",[Regex]),
    {ok, MP} = re:compile(Regex, [unicode]),
    Result =
        lists:all(fun(Elem) ->
                     Text = [Elem],
					 ?debugFmt("Letter = ~ts, Value =~.16B  ",[Text,Elem]),
                     match == re:run(Text, MP, [{capture, none}])
                  end,
                  List),
    ?assertEqual(Expected, Result).	

research_04_02_test() ->
    Expected = "Α",
	Elem = 16#391,
	Text = [Elem],
    Text = [16#391],
	Text = Expected,
    Regex = re_tuner:unicode_block("\\p{InGreekandCoptic}"),
    %?debugFmt("Regex = ~p", [Regex]),
	{ok, MP} = re:compile(Regex, [unicode]),
	
	[TextValue] = Text,
	%?debugFmt("Text = ~ts, Value = ~.16B", [Text,TextValue]),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

research_04_03_test() ->
    Expected = "5",
    Text = Expected,
    Regex = re_tuner:unicode_block("\\p{InBasicLatin}"),
    %?debugFmt("Regex = ~p, Text = ~p~n",[Regex,Text]),
    {ok, MP} = re:compile(Regex, [unicode]),
    {match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    ?assertEqual(Expected, Result).

% Unicode grapheme
research_05_01_test() ->
Expected = [["à"],["à"]],
    Text = [16#E0, 16#61, 16#300],
	Regex = "\\X",
	{ok, MP} = re:compile(Regex, [unicode]),
	{match, Result} = re:run(Text, MP, [global,{capture, first, list}]),
	%?debugFmt("Result = ~ts",[Result]).
	?assertEqual(Expected, Result).

-endif.
