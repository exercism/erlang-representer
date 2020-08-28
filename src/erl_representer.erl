-module(erl_representer).

%% API exports
-export([main/1]).

-define(APP, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

%% escript Entry point
main(_Args) ->
    ok = application:load(?APP), %% We need to load the application to its keys
                                 %% available later on.
    Version = version(),
    io:format("Version: ~s~n", [Version]),
    erlang:halt(0).

%%====================================================================
%% Internal functions
%%====================================================================

version() ->
    {ok, Version0} = application:get_key(?APP, vsn),
    Version1 = string:split(Version0, "-"),
    case Version1 of
        [Date, "dirty"] ->
            format_date(Date) ++ "-dirty-commit";
        [Date, Commit] ->
            format_date(Date) ++ "-" ++ Commit;
        ["dev"] ->
            "inofficial-dev-build"
    end.

format_date(Date0) ->
    {Year, Date1} = lists:split(4, Date0),
    {Month, Date2} = lists:split(2, Date1),
    {Day, Time0} = lists:split(2, Date2),
    {Hour, Time1} = lists:split(2, Time0),
    {Minute, Seconds} = lists:split(2, Time1),
    lists:flatten(io_lib:format("~s-~s-~sT~s:~s:~sZ", [Year, Month, Day, Hour, Minute, Seconds])).
