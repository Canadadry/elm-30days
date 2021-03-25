module Main exposing (main)

import Browser
import Html exposing (Html, button, div, table, td, text, tr)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Matrix


type Living
    = Alive
    | Dead


livingToColor : Living -> String
livingToColor l =
    case l of
        Dead ->
            "white"

        Alive ->
            "black"

type alias Cell =
    { st : Living
    }

type alias Model = 
    { matrix : Matrix.Matrix Cell
    , mode : TouchMode
    } 
    
type TouchMode 
    = Set
    | Update

initialModel : Model
initialModel =
    { matrix = Matrix.repeat ( 10, 10 ) { st = Dead }
    , mode = Set
    }

type Msg
    = Swap ( Int, Int )
    | ChMode TouchMode

swap : Maybe Cell -> Cell
swap mc =
    case mc of
        Nothing ->
            { st = Dead }

        Just c ->
            case c.st of
                Dead ->
                    { st = Alive }

                Alive ->
                    { st = Dead }

 
indexedFilter :  ((Int, a) -> Bool) -> List a -> List a
indexedFilter f l =
   l
   |> (List.indexedMap Tuple.pair)
   |> (List.filter f)
   |> (List.map Tuple.second)
   

around : Int -> (Int,a) -> Bool
around p (i,_) =
    if p-i < -1 then
        False
    else if p-i > 1 then 
        False
    else 
        True

neighbourg : Matrix.Matrix a ->(Int,Int)-> Matrix.Matrix a
neighbourg m (x,y) =
    m
   |> Matrix.toList 
   |> indexedFilter (around y)
   |> List.map (indexedFilter (around x))
   |> Matrix.fromList
 
sumCell : Matrix.Matrix Cell -> Int
sumCell m = 
     m
     |> Matrix.toList
     |> List.map (List.foldl foldlCell 0)
     |> List.foldl (+) 0

foldlCell : Cell -> Int -> Int
foldlCell c s = 
    case c.st of 
        Dead -> 
            s
        Alive ->
            s + 1
          
conwayCell :Matrix.Matrix Cell -> Cell -> Cell
conwayCell  n c =
    let 
        sum = sumCell n
    in
        case c.st of 
            Dead ->
                if sum == 3 then
                    { st = Alive }
                else 
                    { st = Dead }
            Alive ->
                if sum == 3 || sum == 4 then
                    { st = Alive }
                else 
                    { st = Dead }

                    

applyConWayCellTo : Matrix.Matrix Cell-> (Int,Int) -> Cell -> Cell
applyConWayCellTo m (x,y) c =
    conwayCell (neighbourg m (x,y)) c   


conway : Model -> Model
conway model =
    { model | matrix = Matrix.indexedMap (applyConWayCellTo model.matrix) model.matrix }

update : Msg -> Model -> Model
update msg model =
    case msg of
        Swap ( x, y ) ->
            case model.mode of
                Set ->
                   {model | matrix = Matrix.set ( x, y ) (swap (Matrix.get ( x, y ) model.matrix)) model.matrix }
                Update ->
                    conway model
        ChMode m ->
            { model | mode = m }

cellView : Int -> Int -> Cell -> Html Msg
cellView y x c =
    td
        [ style "border" "1px black solid"
        , style "width" "25px"
        , style "height" "25px"
        , style "background-color" (livingToColor c.st)
        , onClick (Swap ( x, y ))
        ]
        []


cellLineView : Int -> List Cell -> Html Msg
cellLineView y ls =
    tr [] (List.indexedMap (cellView y) ls)


matrixView : Model -> Html Msg
matrixView model =
    table [] (List.indexedMap cellLineView (Matrix.toList model.matrix))

view : Model -> Html Msg
view model = 
    div [] 
        [ matrixView model
        , button [onClick (ChMode Set)][text "Set"]
        , button [onClick (ChMode Update)][text "Up"]
        ]
        
main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
