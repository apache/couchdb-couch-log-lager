% Licensed under the Apache License, Version 2.0 (the "License"); you may not
% use this file except in compliance with the License. You may obtain a copy of
% the License at
%
%   http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
% WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
% License for the specific language governing permissions and limitations under
% the License.

-module(couch_log_lager).

-behaviour(couch_log).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-export([
    debug/2,
    info/2,
    notice/2,
    warning/2,
    error/2,
    critical/2,
    alert/2,
    emergency/2,
    set_level/1
]).

-spec debug(string(), list()) -> ok.
debug(Fmt, Args) ->
    lager:debug(Fmt, Args).

-spec info(string(), list()) -> ok.
info(Fmt, Args) ->
    lager:info(Fmt, Args).

-spec notice(string(), list()) -> ok.
notice(Fmt, Args) ->
    lager:notice(Fmt, Args).

-spec warning(string(), list()) -> ok.
warning(Fmt, Args) ->
    lager:warning(Fmt, Args).

-spec error(string(), list()) -> ok.
error(Fmt, Args) ->
    lager:error(Fmt, Args).

-spec critical(string(), list()) -> ok.
critical(Fmt, Args) ->
    lager:critical(Fmt, Args).

-spec alert(string(), list()) -> ok.
alert(Fmt, Args) ->
    lager:alert(Fmt, Args).

-spec emergency(string(), list()) -> ok.
emergency(Fmt, Args) ->
    lager:emergency(Fmt, Args).

-spec set_level(atom()) -> ok.
set_level(Level) ->
    {ok, Handlers} = application:get_env(lager, handlers),
    lists:foreach(fun({Handler, _}) ->
        lager:set_loglevel(Handler, Level)
    end, Handlers).


-ifdef(TEST).

callbacks_test_() ->
    {setup,
        fun setup/0,
        fun cleanup/1,
        [
            ?_assertEqual(info, lager:get_loglevel(lager_console_backend)),
            ?_assertEqual(ok, set_level(debug)),
            ?_assertEqual(debug, lager:get_loglevel(lager_console_backend)),
            ?_assertEqual(ok, set_level(alert)),
            ?_assertEqual(alert, lager:get_loglevel(lager_console_backend))
        ]
    }.

setup() ->
    setup_lager().

setup_lager() ->
    error_logger:tty(false),
    application:load(lager),
    application:set_env(lager, handlers, [{lager_console_backend, info}]),
    application:set_env(lager, error_logger_redirect, false),
    application:set_env(lager, async_threshold, undefined),
    lager:start().

cleanup(_) ->
    application:stop(lager),
    application:stop(goldrush),
    error_logger:tty(true).

-endif.
