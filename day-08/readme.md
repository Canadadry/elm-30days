# Day 8: removing duplicated

Today I wanted to check the validity of a sudoku grid and for that I will cut the problem into two smaller one. 
1. Finding all the number of a region, (row, column, block)
2. Searching for duplicate. 

So I though comparing the lenght of list and the same list without duplicate would be a first good step. 

I tried to follow some of the advice I recieved. Like reducing number of small function. 

So I move from that 


```elm
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
```

To that 

```elm
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
```


I am sure would be complety incapable of writing the second version without writing the first version. 

I feel like not knowing all the `List.foldl` or `Dict.update` function signature be heart restrain me to progress. 

In other language, everything feel natural, the for loop, the while, the affectation... Here everything is different. This is not worst or better. 

I was a bit frustrated the previous days. It's because elm is the hardest language I've learn since C 15 years ago. Aside from the Rust borrow checker.

Changing paradigm is like learning a new language. Everything feel news. 

