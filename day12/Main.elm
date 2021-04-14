module Main exposing (main)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode exposing (Decoder, field, string)


type alias User = 
   { firstname: String
   , lastname : String
   , realname : String
   , surname : String
   , job : String
   , address : String
   , friend : List Friend
   }
   
userDecoder : Decoder User
userDecoder =
    Json.Decode.map7 User 
    (field "firstname" string)
    (field "lastname" string)
    (field "realname" string)
    (field "surname" string)
    (field "job" string)
    (field "address" string)
    (field "friend" (Json.Decode.list friendDecoder))

type alias Friend = 
   { firstname : String
   , lastname : String 
   , relationship : String
   }
   
friendDecoder : Decoder Friend
friendDecoder =
    Json.Decode.map3 Friend 
    (field "firstname" string)
    (field "lastname" string)
    (field "relationship" string)
   
type Data
    = Nothing
    | Failure String
    | Loading
    | Success User


type alias Model =
    { content : Data
    , path : String
    }


initialModel : () -> ( Model, Cmd Msg )
initialModel _ =
    ( { content = Nothing
      , path = "https://raw.githubusercontent.com/Canadadry/elm-30days/master/day12/data.json"
      }
    , Cmd.none
    )


type Msg
    = ChangePath String
    | Query
    | GotResponse (Result Http.Error User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangePath p ->
            ( { model | path = p }, Cmd.none )

        Query ->
            ( { model | content = Loading }
            , Http.get
                { url = model.path
                , expect = Http.expectJson GotResponse userDecoder
                }
            )
          
        GotResponse rsp ->
            case rsp of 
              Ok content -> ( {model| content = (Success content)}, Cmd.none )
              Err e -> ( {model|content = Failure (httpErrToString e)}, Cmd.none )
       
httpErrToString : Http.Error -> String
httpErrToString e = 
    case e of 
        Http.BadUrl m -> "Bad url " ++ m
        Http.Timeout -> "timeout"
        Http.NetworkError -> "NetworkError"
        Http.BadStatus m -> "BadStatus " ++ (String.fromInt m)
        Http.BadBody m -> "BadBody " ++ m

viewData : Data -> Html Msg
viewData d =
    case d of
        Nothing ->
            text "Nothing queried"

        Failure s ->
            text ("Failure : " ++ s)

        Loading ->
            text "Loading"
            
        Success u ->
            text (u.firstname ++ " has " ++ (String.fromInt (List.length u.friend)) ++ " friends ")


view : Model -> Html Msg
view model =
    div []
        [ div [] [ viewData model.content ]
        , input [ onInput ChangePath, value model.path ] []
        , button [ onClick Query ] [ text "fetch" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = initialModel
        , subscriptions = subscriptions
        , view = view
        , update = update
        }
