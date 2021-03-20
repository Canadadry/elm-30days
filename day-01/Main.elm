module Main exposing (main)

import Array
import Browser
import Html exposing (Html, button, div, h1, input, span, table, td, text, tr)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


type alias Todo =
    { title : String, done : Bool }


type alias Model =
    { todos : Array.Array Todo, input : String }


todoFromString : String -> Todo
todoFromString str =
    { title = str, done = False }


todosFromListOfString : List String -> List Todo
todosFromListOfString strs =
    List.map todoFromString strs


initialModel : Model
initialModel =
    { todos = Array.fromList (todosFromListOfString [ "something", "something-else" ])
    , input = ""
    }


type Msg
    = Check Int
    | Add
    | Change String


toogleTodo : Todo -> Todo
toogleTodo todo =
    { todo | done = not todo.done }


updateTodos : Int -> Todo -> Model -> Model
updateTodos idx todo model =
    { model | todos = Array.set idx todo model.todos }


appendTodo : String -> Model -> Model
appendTodo str model =
    { model | todos = Array.push (todoFromString str) model.todos }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Check idx ->
            case Array.get idx model.todos of
                Just todo ->
                    updateTodos idx (toogleTodo todo) model

                Nothing ->
                    model

        Add ->
            appendTodo model.input model

        Change str ->
            { model | input = str }


icon : Bool -> String
icon c =
    case c of
        True ->
            "far fa-check-square"

        False ->
            "far fa-square"


line : Int -> Todo -> Html Msg
line idx model =
    tr [ onClick (Check idx) ]
        [ td [] [ span [ class (icon model.done) ] [] ]
        , td [] [ text model.title ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "My First ToDo List" ]
        , table [ class "table" ] (Array.toList (Array.indexedMap line model.todos))
        , div [ class "form-inline" ]
            [ input [ class "form-control", placeholder "Add task todo", value model.input, onInput Change ] []
            , button [ class "ml-2 btn btn-primary", onClick Add ]
                [ span [ class "fa fa-plus" ] []
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
