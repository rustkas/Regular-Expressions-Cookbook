-module(recipe_15).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").


research_test_() ->
    {"Prevent Runaway Repetition",
     {foreach,
      local,
      fun build_text_and_expectation/0,
      [fun research_01/1,
       fun research_02/1]}}.

build_text_and_expectation()->
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
    
</body>
</html>
	",
	
	Expected = "<html>\n<head>\n    <meta charset=\"UTF-8\">\n    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <title>Document</title>\n</head>\n<body>\n    \n</body>\n</html>",
	{Text, Expected}.

research_01({Text, Expected})->
	Regex = "<html>(?>.*?<head>)(?>.*?<title>)(?>.*?</title>)(?>.*?</head>)(?>.*?<body[^>]*>)(?>.*?</body>).*?</html>",
	{ok, MP} = re:compile(Regex,[caseless, multiline,dotall]),
    %Result = re:run(Text, MP, [{capture, first, list}]),
	{match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p~n",[Result]).
    ?_assertEqual(Expected, Result).

research_02({Text, Expected})->
    Regex = "<html>.*?<head>.*?<title>.*?</title>.*?</head>.*?<body[^>]*>.*?</body>.*?</html>",
	{ok, MP} = re:compile(Regex,[caseless, multiline,dotall]),
    %Result = re:run(Text, MP, [{capture, first, list}]),
	{match, [Result]} = re:run(Text, MP, [{capture, first, list}]),
    %?debugFmt("~p~n",[Result]).
    ?_assertEqual(Expected, Result).

-endif.
