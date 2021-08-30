programming
=====

## Create new project
    $ rebar3 new umbrella programming && cd programming && rm -R apps && mkdir lib && cd lib && rebar3 new lib recipe_01 && rebar3 new lib recipe_02 && rebar3 new lib recipe_03 && rebar3 new lib recipe_04 && rebar3 new lib recipe_05 && rebar3 new lib recipe_06 && rebar3 new lib recipe_07 && rebar3 new lib recipe_08 && rebar3 new lib recipe_09 && rebar3 new lib recipe_10 && rebar3 new lib recipe_11 && rebar3 new lib recipe_12 && rebar3 new lib recipe_13 && rebar3 new lib recipe_14 && rebar3 new lib recipe_15 && rebar3 new lib recipe_16 && rebar3 new lib recipe_17 && rebar3 new lib recipe_18 && rebar3 new lib recipe_19 && rebar3 new lib recipe_20 && rebar3 new lib recipe_21 && rebar3 new lib recipe_22

An OTP application

## EUnit
-----
	$ rebar3 eunit
	$ rebar3 eunit -m recipe_01
	$ rebar3 eunit -m recipe_02
	$ rebar3 eunit -m recipe_03
	$ rebar3 eunit -m recipe_04
	$ rebar3 eunit -m recipe_05
	$ rebar3 eunit -m recipe_06
	$ rebar3 eunit -m recipe_07
	$ rebar3 eunit -m recipe_08
	$ rebar3 eunit -m recipe_09
	$ rebar3 eunit -m recipe_10
	$ rebar3 eunit -m recipe_11
	$ rebar3 eunit -m recipe_12
	$ rebar3 eunit -m recipe_13
	$ rebar3 eunit -m recipe_14
	$ rebar3 eunit -m recipe_15
	$ rebar3 eunit -m recipe_16
	$ rebar3 eunit -m recipe_17
	$ rebar3 eunit -m recipe_18
	$ rebar3 eunit -m recipe_19
	$ rebar3 eunit -m recipe_20
	$ rebar3 eunit -m recipe_21
	$ rebar3 eunit -m recipe_22
	
## Format
	$ rebar3 format
	

Build
-----

    $ rebar3 compile
