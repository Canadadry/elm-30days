# Day 1 

Nothing really specific today, this is just a basic todo list. 
My only pain point was how to send the toogle event. 

```elm
type Msg
    = Check Int
    | Add
    | Change String

-- ....

line : Int -> Todo -> Html Msg
line idx model =
    tr [ onClick (Check idx) ]
        [ td [] [ span [ class (icon model.done) ] [] ]
        , td [] [ text model.title ]
        ]
```

I had hard time to figure the `(Check ids)` I did not see that parenthesis was important here. 

Also It was a bit strange for me not to have a loop to iterate my list and update the one I needed