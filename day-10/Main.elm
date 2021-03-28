module Main exposing (main)

import Browser
import Html exposing (Html, button, div, li, text, ul)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Matrix


type alias Player =
    { x : Float
    , y : Float
    , direction : Float
    }


type alias Model =
    { player : Player
    , size : Int
    , map : Matrix.Matrix Bool
    }


columnToAngle : Float -> Int -> Int -> Float
columnToAngle focal count id =
    atan2 focal (toFloat id / toFloat count - 0.5)


initialModel : Model
initialModel =
    { player =
        { x = 3
        , y = 3
        , direction = 0
        }
    , size = 10
    , map =
        Matrix.fromList
            [ [ True, True, True, True, True, True, True, True, True, True ]
            , [ True, False, False, False, False, False, False, False, False, True ]
            , [ True, False, False, False, False, False, False, False, False, True ]
            , [ True, False, False, False, False, False, False, False, False, True ]
            , [ True, False, False, False, True, False, False, False, False, True ]
            , [ True, False, False, False, False, False, False, False, False, True ]
            , [ True, False, False, False, False, False, False, False, False, True ]
            , [ True, False, False, False, False, False, False, False, False, True ]
            , [ True, False, False, False, False, False, False, False, False, True ]
            , [ True, True, True, True, True, True, True, True, True, True ]
            ]
    }


type Msg
    = Nothing


update : Msg -> Model -> Model
update msg model =
    model


ray : Int -> Int -> Int -> Int -> Html Msg
ray width maxHeight y height =
    li
        [ style "padding" "0px"
        , style "margin" "0px"
        , style "background-color" "blue"
        , style "display" "inline-block"
        , style "height" (String.fromInt maxHeight ++ "px")
        , style "width" (String.fromInt width ++ "px")
        ]
        [ div
            [ style "margin-top" (String.fromInt y ++ "px")
            , style "background-color" "black"
            , style "height" (String.fromInt height ++ "px")
            , style "width" (String.fromInt width ++ "px")
            ]
            []
        ]


screenRay : Int -> Int -> Html Msg
screenRay y height =
    ray 5 100 y height


screen : List ( Int, Int )
screen =
    [ ( 0, 100 )
    , ( 5, 90 )
    , ( 10, 80 )
    , ( 15, 70 )
    , ( 15, 70 )
    , ( 15, 70 )
    , ( 15, 70 )
    , ( 15, 70 )
    , ( 15, 70 )
    , ( 15, 70 )
    , ( 15, 70 )
    , ( 15, 70 )
    , ( 15, 70 )
    , ( 10, 80 )
    , ( 5, 90 )
    , ( 0, 100 )
    , ( 0, 100 )
    , ( 0, 100 )
    , ( 0, 100 )
    , ( 0, 100 )
    , ( 0, 100 )
    , ( 0, 100 )
    , ( 0, 100 )
    ]


view : Model -> Html Msg
view model =
    ul
        [ style "padding" "0px"
        , style "margin" "0px"
        ]
        (List.map (\( y, h ) -> screenRay y h) screen)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
