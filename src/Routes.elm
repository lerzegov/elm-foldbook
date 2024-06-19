module Routes exposing (..)

import Url exposing (Url, Protocol(..))
import Url.Parser exposing (Parser, oneOf, s, parse, top, (</>), string, map)

type Page
    = HomePage
    | DatasetPage String

parseUrl : Url -> Page
parseUrl url =
    case url.fragment of
        Just fragment ->
            let
                protocolString =
                    case url.protocol of
                        Http -> "http"
                        Https -> "https"
                baseUrl = 
                    case url.port_ of
                        Just jPort -> protocolString ++ "://" ++ url.host ++ ":" ++ String.fromInt jPort -- ++ "/"
                        Nothing -> protocolString ++ "://" ++ url.host --  "/"
                
                fragmentWithoutHash = 
                        fragment
            in
            case Url.fromString (baseUrl ++ fragmentWithoutHash) of
                Just parsedUrl ->
                    case parse (oneOf [ datasetParser, homeParser ]) parsedUrl of
                        Just page ->
                            page
                        Nothing ->
                            HomePage
                Nothing ->
                    HomePage
        Nothing ->
            HomePage

homeParser : Parser (Page -> a) a
homeParser =
    map HomePage top

datasetParser : Parser (Page -> a) a
datasetParser = -- assumes /dataset/{datasetRef}
    map DatasetPage (s "dataset" </> string)


-- for testing

dummyUrl : Url
dummyUrl =
    { protocol = Http
    , host = "localhost"
    , port_ = Nothing
    , path = "/over/there" 
    , fragment = Just "dataset123"
    , query = Nothing
    }

testUrl : Page
testUrl =
    let
        myUrl = Url.fromString "http://localhost:60545/#/dataset/Ce"
    in
    case myUrl of
        Just url ->
            parseUrl url
        Nothing ->
            HomePage

testDummyUrl : Page
testDummyUrl =
    parseUrl dummyUrl

testToString : String
testToString =
    Url.toString dummyUrl


testUrlFragment : Maybe String
testUrlFragment =
    let
        myUrl =
            Url.fromString "http://localhost:60545/#/dataset/Ce"

        fragment =
            case myUrl of
                Just url ->
                    url.fragment

                Nothing ->
                    Nothing

        parser =
            s "dataset" </> string

        parsedFragment =
            case fragment of
                Just frag ->
                    -- no / after port number, no # before the fragment
                    parse parser (Url.fromString ("http://localhost:60545" ++ frag) |> Maybe.withDefault (Url Http "" Nothing "" Nothing Nothing))

                Nothing ->
                    Nothing
    in
    parsedFragment

