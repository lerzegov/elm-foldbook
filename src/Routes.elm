module Routes exposing (..)

import Task
import Url exposing (Protocol(..), Url)
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, string, top)


type Page
    = HomePage (Maybe String)
    | DatasetPage String (Maybe String)


parseUrl : Url -> Page
parseUrl url =
    let
        anchor =
            url.fragment
    in
    case parse (oneOf [ datasetParser, homeParser ]) url of
        Just (DatasetPage datasetRef _) ->
            DatasetPage datasetRef anchor

        Just (HomePage _) ->
            HomePage anchor

        Nothing ->
            HomePage Nothing



-- parseUrl : Url -> Page
-- parseUrl url =
--     case url.fragment of
--         Just fragment ->
--             let
--                 protocolString =
--                     case url.protocol of
--                         Http -> "http"
--                         Https -> "https"
--                 baseUrl =
--                     case url.port_ of
--                         Just jPort -> protocolString ++ "://" ++ url.host ++ ":" ++ String.fromInt jPort -- ++ "/"
--                         Nothing -> protocolString ++ "://" ++ url.host --  "/"
--                 fragmentWithoutHash =
--                         fragment
--             in
--             case Url.fromString (baseUrl ++ fragmentWithoutHash) of
--                 Just parsedUrl ->
--                     case parse (oneOf [ datasetParser, homeParser ]) parsedUrl of
--                         Just page ->
--                             page
--                         Nothing ->
--                             HomePage
--                 Nothing ->
--                     HomePage
--         Nothing ->
--             HomePage


datasetParser : Parser (Page -> a) a
datasetParser =
    map (\datasetRef -> DatasetPage datasetRef Nothing) (s "dataset" </> string)


homeParser : Parser (Page -> a) a
homeParser =
    map (HomePage Nothing) top
