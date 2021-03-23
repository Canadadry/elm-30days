# Day 5: a random int generator and suffling list

Small step today, 

I needed to understand how randomness could be generated to shuffle mine position at start. 

So I needed to leave the sandbox application because random is a side effect, I don't really get why. 
This seems to be philosophic to me. 
Since there is no access to pseudo pure random in the browser like `/dev/random`, I guess under the hood a classical pseudo random number generator is used. Something like : 

```elm
generator : Int -> Int-> Int -> Int -> Int
generator a b c previous =
    modBy c ( previous*a+b )

rand : Int->Int
rand  previous =
    generator 1103515245 12345 2^32
```

This is the basic implementation by gcc. To be sure to have a different result each time, just pass the current number of second since 1970 int the first call and your good to go. It's good enough for gaming but not for password generation. 

That aside, that feel strange to me, being mandatory to pass by the update function each time I need a random number. I don't say this is a bad idea but it feel off... Update should be called when an event as occur, like a user event, a result of a request... but here ? 

I end up with this simple update function 

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace (Random.int 1 100)
            )

        NewFace newFace ->
            ( { model | rolls = newFace :: (List.take 9 model.rolls) }
            , Cmd.none
            )
        Shuffle ->
            ( model  
            ,  Random.generate NewList (Random.List.shuffle model.rolls)
            )
        NewList l -> 
            ( {model | rolls = l}
            , Cmd.none
            )
```

But how well does it scale ? If I have hundred of need for random. Will it be pretty tedious ? 