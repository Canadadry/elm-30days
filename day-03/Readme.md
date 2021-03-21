# Day 3: a minesweeper

Today I wanted to write a simple minesweeper. But for that I needed a grid system. 

It was way easier than exepected due to one understanding : 

> There is no call function like imperative programming language. 
> If You write `Just(5)` this equivalent of `Just 5`
> All is evaluated from left to right so parenthesis are only here for changing priority 

**Issue** of today : I found myself spending much more time on thinking about my model than I would have expected. 

I needed a grid : I thought about three options : 

1. a `{ content : Array Thing, width : Int}`  which could be problematic if the length of my array is not divisible by my width. What would that mean ? Does my last row lack a few cell ? And it's hard to iterate by row... 

```
######
######
##
```

Could this be a valid Grid ? 

2. a `{content :Array Array Thing}` this is much simple because I don't require a width  but it has a worst problem since this is posible : 

```
#######
######
##
#######
```

But it has the advandage of being way more simple to deal with, to `map`  and we are good to go  

3. a `{content: Matrix Thing }` but I don't know if this basic type exist. Maybe I could build it with private field that ensure every row has the same width. 

It still lacks a way of findind neightbourg easly I want something like this 

```elm
neightgourg4 : Matrix -> Int -> Int -> List (Int, Int)
```

The `4` mean I don't want the diagonal neightbour.