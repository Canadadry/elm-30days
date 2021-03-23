module Main exposing (main)

import Browser
import Html exposing (Html, button, div, li, text, ul)
import Html.Events exposing (onClick)
import Random
import Random.List

type alias Model =
    { rolls : List Int }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { rolls = [] }
    , Cmd.none
    )


type Msg
    = Roll
    | NewFace Int
    | NewList (List Int)
    | Shuffle 


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace (Random.int 1 100)
            )

        NewFace newFace ->
            ( { model | rolls = newFace :: (List.take 9 model.rolls) }
            , Cmd.none
            )
        Shuffle ->
            ( model  
            ,  Random.generate NewList (Random.List.shuffle model.rolls)
            )
        NewList l -> 
            ( {model | rolls = l}
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewRoll : Int -> Html Msg
viewRoll r =
    li [] [ text (String.fromInt r) ]


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Roll ]  [ text "Roll" ]
        , button [ onClick Shuffle ]  [ text "Shuffle" ]
        , ul [] (List.map viewRoll model.rolls )
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
