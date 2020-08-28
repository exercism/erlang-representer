-module(erl_representer).

%% API exports
-export([main/1]).

-define(APP, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

%% escript Entry point
main(Args) ->
    ok = application:load(?APP), %% We need to load the application to its keys
                                 %% available later on.
    io:format("Args: ~p~n", [Args]),
    {ok, Version} = application:get_key(?APP, vsn),
    io:format("Version: ~s~n", [Version]),
    erlang:halt(0).

%%====================================================================
%% Internal functions
%%====================================================================
