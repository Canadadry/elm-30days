# Day 2: a balance parenthesis checker

Since Yesterday I had a hard time with loop I decided to go for a project designed for loop.

The purpose of this exercice was to write a function that check if a list of parenthesis (open or close) is balanced. See below example : 

```
() Valid
(( Invalid
)( Invalid
(()) Valid
()() Valid
...
```

Today I bug on the same thing than yesterday : I was on that function for at least 2 hours : 

```elm
computeValid : List Parenthesis -> Maybe(Int) 
computeValid p = 
    List.foldl checkParenthesis Just(0) p
```

I got for that a compile error really strange : for it this line was returning a `Maybe (List Parenthesis)` and for me it was a `Maybe(Int)`

Again like yesterday the fix was pretty obvious : 

```elm
computeValid : List Parenthesis -> Maybe(Int) 
computeValid p = 
    List.foldl checkParenthesis (Just(0)) p
```

But on the way I discovered the `List.foldl` function. Really cool function, for the first time I have used and understand a reduce function \o/ 