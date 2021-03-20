module Main exposing (main)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onInput)


type alias Model =
    { parenthesis : String }


type Parenthesis
    = Left
    | Right


initialModel : Model
initialModel =
    { parenthesis = "()" }


type Msg
    = Change String


isParenthesis : Char -> Bool
isParenthesis c =
    c == '(' || c == ')'
    

charToParenthesis : Char -> Parenthesis
charToParenthesis c = 
    if c == '(' then 
        Left
    else
        Right
        
stringToListOfParenthsis :  String -> List Parenthesis
stringToListOfParenthsis str =
    List.map charToParenthesis (String.toList ( onlyParenthesis str))

onlyParenthesis : String -> String
onlyParenthesis str =
    String.filter isParenthesis str

checkParenthesis : Parenthesis -> Maybe(Int) -> Maybe(Int)
checkParenthesis p count = 
    case p of 
        Left -> Maybe.map  ((+) 1) count
        Right -> 
            case count of
               Nothing -> Nothing
               Just v ->
                   if v == 0 then
                       Nothing
                   else 
                       Just(v-1)
                       
isValid : Maybe(Int) -> Bool
isValid  count = 
    case count of 
        Nothing -> False
        Just v -> v == 0
        
computeValid : List Parenthesis -> Maybe(Int) 
computeValid p = 
    List.foldl checkParenthesis (Just(0)) p

boolToString : Bool -> String
boolToString b = 
    case b of 
        True -> "Valid"
        False -> "Invalid"
        
wholeCheck : String -> String
wholeCheck str = 
    str
    |> stringToListOfParenthsis
    |> computeValid
    |> isValid
    |> boolToString
    
update : Msg -> Model -> Model
update msg model =
    case msg of
        Change str ->
            { model | parenthesis = onlyParenthesis str }


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text (wholeCheck model.parenthesis) ]
        , input [ class "form-control", placeholder "type a series of ()", value model.parenthesis, onInput Change ] []
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
