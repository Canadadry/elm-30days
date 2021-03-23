module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Matrix
import Tuple


type alias Cell =
    { y : Int
    , x : Int
    , around : Int
    , hasMine : Bool
    }


cellToString : Cell -> String
cellToString c =
    case c.hasMine of
        True ->
            "x"

        False ->
            String.fromInt c.around


type alias Model =
    { field : Matrix.Matrix Cell
    , numberOfMine : Int
    }


newCellAt : Pos -> Cell
newCellAt p =
    { y = posY p
    , x = posX p
    , around = 0
    , hasMine = False
    }


initialModel : Model
initialModel =
    { field = Matrix.initialize 8 5 newCellAt
    , numberOfMine = 0
    }


type alias Pos =
    ( Int, Int )


pos : Cell -> Pos
pos c =
    ( c.y, c.x )


posX : Pos -> Int
posX =
    Tuple.second


posY : Pos -> Int
posY =
    Tuple.first


offset : Pos -> Pos -> Pos
offset o p =
    ( (+) (Tuple.first p) (Tuple.first o)
    , (+) (Tuple.second p) (Tuple.second o)
    )


type Diff
    = Nothing
    | Neighbourg
    | Target


isNeighbourg : Pos -> Pos -> Diff
isNeighbourg p1 p2 =
    let
        dx =
            abs ((-) (posX p1) (posX p2))

        dy =
            abs ((-) (posY p1) (posY p2))
    in
    if dx == 0 && dy == 0 then
        Target

    else if dx > 1 || dy > 1 then
        Nothing

    else
        Neighbourg


updateIfNeighbourgCell : Pos -> Cell -> Cell
updateIfNeighbourgCell p c =
    case (isNeighbourg (pos c) p) of
        Target ->
            { c | hasMine = True }
        Neighbourg ->
            { c | around = c.around + 1 }

        Nothing ->
            c


updateAllNeighbourgCellOf : Matrix.Matrix Cell -> Cell -> Matrix.Matrix Cell
updateAllNeighbourgCellOf m c =
    Matrix.map (updateIfNeighbourgCell (pos c)) m


type Msg
    = AddMineAt Cell


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddMineAt c ->
            if c.hasMine then 
                model 
            else 
            { field = updateAllNeighbourgCellOf model.field c
            , numberOfMine = model.numberOfMine + 1
            }


cellView : Cell -> Html Msg
cellView c =
    button [ onClick (AddMineAt c) ] [ text (cellToString c) ]


lineOfCellView : List Cell -> Html Msg
lineOfCellView l =
    div [] (l |> List.map cellView)


fieldView : Matrix.Matrix Cell -> List (Html Msg)
fieldView f =
    f
        |> Matrix.toLists
        |> List.map lineOfCellView


view : Model -> Html Msg
view model =
    div [] (text (String.fromInt model.numberOfMine) :: fieldView model.field)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
