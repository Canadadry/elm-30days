module Main exposing (main)

import Array
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



type alias Cell =
    { y : Int
    , x : Int
    }


cellToString : Cell -> String
cellToString c =
    String.fromInt c.x ++ "," ++ String.fromInt c.y



type alias LineOfCell =
    Array.Array Cell


type alias Model =
    { field : Array.Array LineOfCell
    , action : String
    }


newCellAt : Int -> Int -> Cell
newCellAt y x =
    { y = y
    , x = x
    }


newLineField : Int -> Int -> LineOfCell
newLineField w y =
    Array.initialize w (newCellAt y)


newField : Int -> Int -> Array.Array LineOfCell
newField w h =
    Array.initialize h (newLineField w)


initialModel : Model
initialModel =
    { field = newField 5 8
    , action = ""
    }


type Msg
    = AddMineAt ( Int, Int )


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddMineAt ( x, y ) ->
            { model | action = String.fromInt x ++ "," ++ String.fromInt y }


cellView : Cell -> Html Msg
cellView c =
    button [ onClick (AddMineAt ( c.x, c.y )) ] [ text (cellToString c) ]


lineOfCellView : LineOfCell -> Html Msg
lineOfCellView l =
    div [] (l |> Array.map cellView |> Array.toList)


fieldView : Array.Array LineOfCell -> List (Html Msg)
fieldView f =
    f
        |> Array.map lineOfCellView
        |> Array.toList


view : Model -> Html Msg
view model =
    div [] (text model.action :: fieldView model.field)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
