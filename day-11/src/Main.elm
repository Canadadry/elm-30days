module Main exposing (main)

import Browser
import Html exposing (Html, div, li, ul)
import Html.Attributes exposing (style)
import Matrix


type alias Screen =
    { rayWidth : Int
    , ray : Int
    , height : Int
    , fov : Float
    }


type alias Player =
    { x : Float
    , y : Float
    , direction : Float
    }


type alias Model =
    { player : Player
    , size : Int
    , map : Matrix.Matrix Bool
    , screen : Screen
    }


initialModel : Model
initialModel =
    { player =
        { x = 3
        , y = 3
        , direction = 30
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
    , screen =
        { rayWidth = 4
        , ray = 100
        , height = 300
        , fov = 70.0
        }
    }


type Msg
    = Nothing


update : Msg -> Model -> Model
update _ model =
    model


ray : Int -> Int -> ( Float, Float ) -> Html Msg
ray width maxHeight ( y, height ) =
    li
        [ style "padding" "0px"
        , style "margin" "0px"
        , style "background-color" "blue"
        , style "display" "inline-block"
        , style "height" (String.fromInt maxHeight ++ "px")
        , style "width" (String.fromInt width ++ "px")
        ]
        [ div
            [ style "margin-top" (String.fromFloat y ++ "px")
            , style "background-color" "black"
            , style "height" (String.fromFloat height ++ "px")
            , style "width" (String.fromInt width ++ "px")
            ]
            []
        ]


getRayDirection : Float -> Float -> Int -> Int -> Float
getRayDirection fov direction count id =
    direction + fov / toFloat count * (toFloat id - toFloat count / 2)


computeDepth : Float -> Float -> Matrix.Matrix Bool -> Float -> Float
computeDepth x y dataMap direction =
    10.0


depthToYandHeight : Float -> ( Float, Float )
depthToYandHeight d =
    ( d, d )


view : Model -> Html Msg
view model =
    ul
        [ style "padding" "0px"
        , style "margin" "0px"
        ]
        (List.range 0 (model.screen.ray - 1)
            |> List.map (getRayDirection model.screen.fov model.player.direction model.screen.ray)
            |> List.map (computeDepth model.player.x model.player.y model.map)
            |> List.map depthToYandHeight
            |> List.map (ray model.screen.rayWidth model.screen.height)
        )


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
