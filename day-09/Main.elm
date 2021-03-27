module Main exposing (main)

import Browser
import Dict exposing (Dict)
import Html exposing (Html, button, div, input, li, p, table, td, text, tr, ul)
import Html.Attributes exposing (style, value)
import Html.Events exposing (onInput)
import Matrix


type alias Model =
    { sdk : Matrix.Matrix (Maybe Int) }


type Msg
    = ChangeAt ( Int, Int ) String


toString : Maybe Int -> String
toString mi =
    Maybe.withDefault "" (Maybe.map String.fromInt mi)


initialModel : Model
initialModel =
    { sdk = Matrix.repeat ( 9, 9 ) Nothing }


removeDuplicate : List comparable -> List comparable
removeDuplicate l =
    l
        |> List.foldl
            (\key dict ->
                Dict.update key
                    (\value ->
                        case value of
                            Nothing ->
                                Just 1

                            Just v ->
                                Just (v + 1)
                    )
                    dict
            )
            Dict.empty
        |> Dict.keys


hasDuplicate : List comparable -> Bool
hasDuplicate l =
    List.length l /= List.length (removeDuplicate l)


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeAt ( x, y ) i ->
            { model | sdk = Matrix.set ( x, y ) (String.toInt i) model.sdk }


cellView : Int -> Int -> Maybe Int -> Html Msg
cellView y x i =
    td []
        [ input
            [ style "width" "25px"
            , value (toString i)
            , onInput (ChangeAt ( x, y ))
            ]
            []
        ]


cellLineView : Int -> List (Maybe Int) -> Html Msg
cellLineView y l =
    tr [] (List.indexedMap (cellView y) l)


matrixView : Model -> Html Msg
matrixView model =
    table [] (List.indexedMap cellLineView (Matrix.toList model.sdk))


printDuplicated : Bool -> Html Msg
printDuplicated v =
    if v then
        li [] [ text "Invalid" ]

    else
        li [] [ text "Valid" ]


transpose : a -> Matrix.Matrix a -> Matrix.Matrix a
transpose default m =
    let
        ( width, height ) =
            Matrix.size m
    in
    Matrix.initialize ( height, width ) (\( x, y ) -> Matrix.get ( y, x ) m |> Maybe.withDefault default)


lineCheckView : Matrix.Matrix (Maybe Int) -> Html Msg
lineCheckView m =
    m
        |> Matrix.toList
        |> List.map (List.filterMap (\a -> a))
        |> List.map hasDuplicate
        |> List.map printDuplicated
        |> (\l -> ul [] l)


blockId : Int -> Int -> ( Int, Int )
blockId chunckSize id =
    ( modBy chunckSize id * chunckSize, id // chunckSize * chunckSize )


extractBlock : Int -> ( Int, Int ) -> Matrix.Matrix a -> List a
extractBlock chunckSize ( x, y ) m =
    m
        |> Matrix.slice ( x, y ) ( x + chunckSize, y + chunckSize )
        |> Matrix.toList
        |> List.concat


block : Int -> Matrix.Matrix a -> Int -> List a
block chunckSize m id =
    extractBlock chunckSize (blockId chunckSize id) m


matrixByBlock : Int -> Matrix.Matrix a -> Matrix.Matrix a
matrixByBlock chunckSize m =
    List.range 0 (chunckSize * chunckSize - 1)
        |> List.map (block chunckSize m)
        |> Matrix.fromList


view : Model -> Html Msg
view m =
    div []
        [ matrixView m
        , table []
            [ tr []
                [ td []
                    [ p []
                        [ text "check row"
                        , lineCheckView m.sdk
                        ]
                    ]
                , td []
                    [ p []
                        [ text "check column"
                        , lineCheckView (transpose Nothing m.sdk)
                        ]
                    ]
                , td []
                    [ p []
                        [ text "check block"
                        , lineCheckView (matrixByBlock 3 m.sdk)
                        ]
                    ]
                ]
            ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }

