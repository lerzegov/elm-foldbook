module TestTime exposing (..)

import FastDict as Dict exposing (Dict)
import Task exposing (Task)
import Time exposing (Month(..), Posix, Weekday(..), here)
import TimeZone

timezoneErrorToString : TimeZone.Error -> String
timezoneErrorToString error =
    case error of
        TimeZone.NoZoneName ->
            "Couldn't get zone name"

        TimeZone.NoDataForZoneName zoneName ->
            "Couldn't get zone data for '" ++ zoneName ++ "'"


formatPosix : Time.Zone -> Posix -> String
formatPosix zone posix =
    String.join " "
        [ Time.toWeekday zone posix |> weekdayToName
        , Time.toMonth zone posix |> monthToName
        , Time.toDay zone posix |> String.fromInt |> String.padLeft 2 '0'
        , Time.toYear zone posix |> String.fromInt
        , String.join ":"
            [ Time.toHour zone posix |> String.fromInt |> String.padLeft 2 '0'
            , Time.toMinute zone posix |> String.fromInt |> String.padLeft 2 '0'
            , Time.toSecond zone posix |> String.fromInt |> String.padLeft 2 '0'
            ]
        ]


monthToName : Month -> String
monthToName m =
    case m of
        Jan ->
            "Jan"

        Feb ->
            "Feb"

        Mar ->
            "Mar"

        Apr ->
            "Apr"

        May ->
            "May"

        Jun ->
            "Jun"

        Jul ->
            "Jul"

        Aug ->
            "Aug"

        Sep ->
            "Sep"

        Oct ->
            "Oct"

        Nov ->
            "Nov"

        Dec ->
            "Dec"


weekdayToName : Weekday -> String
weekdayToName wd =
    case wd of
        Mon ->
            "Mon"

        Tue ->
            "Tue"

        Wed ->
            "Wed"

        Thu ->
            "Thu"

        Fri ->
            "Fri"

        Sat ->
            "Sat"

        Sun ->
            "Sun"

-- not runnable in elm repl
whatDayIsIt : Task x Int
whatDayIsIt =
  Task.map2 Time.toDay Time.here Time.now

testFormat = 
    let myPosix = Time.millisToPosix 1131357044194 in
    formatPosix Time.utc myPosix