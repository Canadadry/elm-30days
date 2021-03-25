module Main exposing (main)

import Browser
import Html exposing (Html, button, div, input, table, td, text, tr)
import Html.Attributes exposing (style,value)
import Html.Events exposing (onInput)
import Matrix


type alias Model =
    { sdk : Matrix.Matrix (Maybe Int) }


type Msg
    = ChangeAt ( Int, Int ) String

toString : Maybe Int -> String
toString mi = 
    (Maybe.withDefault "" (Maybe.map String.fromInt mi))
        
initialModel : Model
initialModel =
    { sdk = Matrix.repeat ( 9, 9 ) Nothing }


update : Msg -> Model -> Model
update msg model =
    case msg of 
     ChangeAt (x,y) i -> 
        { model | sdk = Matrix.set (x,y) (String.toInt i) model.sdk }


cellView : Int -> Int -> Maybe Int -> Html Msg
cellView y x i =
    td []
        [ input
            [ style "width" "25px"
            , value (toString i)
            , onInput (ChangeAt (x,y))
            ]
            []
        ]

cellLineView : Int -> List (Maybe Int) -> Html Msg
cellLineView y l =
    tr [] (List.indexedMap (cellView y) l)


matrixView : Model -> Html Msg
matrixView model =
    table [] (List.indexedMap cellLineView (Matrix.toList model.sdk))


view : Model -> Html Msg
view m =
    div [] [ matrixView m ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
