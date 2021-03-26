module Main exposing (main)

import Browser
import Dict exposing (Dict)
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onClick, onInput)


type alias Model =
    { input : String }


type Msg
    = Change String
    | RemoveDuplicate


updateOccurence : Maybe Int -> Maybe Int
updateOccurence value =
    case value of
        Nothing ->
            Just 1

        Just v ->
            Just (v + 1)


stepOccurence : comparable -> Dict comparable Int -> Dict comparable Int
stepOccurence key dict =
    Dict.update key updateOccurence dict


occurence : List comparable -> Dict comparable Int
occurence l =
    List.foldl stepOccurence Dict.empty l


removeDuplicate : List comparable -> List comparable
removeDuplicate l =
    l
        |> occurence
        |> Dict.keys


removeDuplicate2 : List comparable -> List comparable
removeDuplicate2 l =
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


clean : String -> String
clean s =
    s
        |> String.split ","
        |> List.map String.toInt
        |> List.filterMap identity
        |> removeDuplicate2
        |> List.map String.fromInt
        |> String.join ","


initialModel : Model
initialModel =
    { input = "1,2,3,4" }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change s ->
            { model | input = s }

        RemoveDuplicate ->
            { model | input = clean model.input }


view : Model -> Html Msg
view m =
    div []
        [ input [ value m.input, onInput Change ] []
        , button [ onClick RemoveDuplicate ] [ text "Clean" ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
