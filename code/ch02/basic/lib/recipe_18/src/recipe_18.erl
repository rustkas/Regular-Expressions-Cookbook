-module(recipe_18).

-export([]).

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

research_01_test()->

   Text = "9999-12-77",
   Regex = 
"
\\d{4} # Year
- # Separator
\\d{2} # Month
- # Separator
\\d{2} # Day
"   
   ,
   {ok, MP} = re:compile(Regex,[extended]),
   match = re:run(Text, MP, [{capture, none}]).



-endif.
