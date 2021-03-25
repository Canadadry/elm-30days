# Day 6: conway game of life 

Today I wanted to go back to something fresh and new and not lose my motivation. I was looking for small dev challenge like those given in tech interviews. I found a question about [conway game of life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life). Which should stairtforward to build and highly graphical so really rewarding for me. 

## Conway game of life

If you don't know the game of life, you will be disappointed beceause it's not a game. There is no player and no winner. 
Instead you have a board with an initial state and some rule for the board to evolve. You have no way of interacting with it. 

Nevertheless this "game" is really intersting, by the pattern that emerge from it.

## The rule of the game 

1. Your board is a infinite two dimmensionnals array of cells. 
2. Each cell can be `Dead` or `Alive`
3. The state of each cell represent your initial state. 
4. Next iteration is dertermined by which cell "dies" (passing from `Alive` to `Dead`) and which cells "borns" (passing from `Dead` to `Alive`) : 
    1. Any living cell with two or three alive neighbours lives, if not they dies
    2. Any dead cell with exactly three alive neighbours "borns"

Which give you those kind of result : 

![game of life example](https://upload.wikimedia.org/wikipedia/commons/e/e5/Gospers_glider_gun.gif)

## Elm

Coming back to our challenge. It was quite a fun result in the end. During the dev I tried to apply the suggestion I received, with not that much succes I guess 🤣. 

I had the same issue has yesterday and the day before. I had to compute the neighbour of my cell. This was again a pain and I whish the Matrix lib I used were more adapted to my small games. There should be somewhere a Matrix type for board game.

I tried a diffrent approach which was way more easier than excepted. Before I allways though in term of how this should be written in an imperative language (like I was visualiasing the for loop). But today I tried to think with map and filter. My issues were more around how to get the indexes than how to put everything in order.

For that I write a `List.indexedFilter` (which mimic the `List.indexedMap`). 
At first I write something like 5 functions to achieve it. But in then end I managed to get only one function 

```elm
indexedFilter :  ((Int, a) -> Bool) -> List a -> List a
indexedFilter f l =
   l
   |> (List.indexedMap Tuple.pair)
   |> (List.filter f)
   |> (List.map Tuple.second)
```

This tiny function takes me like an hour of work. 

Using this I could easily retreive the neighbour function 🙂

```elm
neighbourg : Matrix.Matrix a ->(Int,Int)-> Matrix.Matrix a
neighbourg m (x,y) =
    m
   |> Matrix.toList 
   |> indexedFilter (around y)
   |> List.map (indexedFilter (around x))
   |> Matrix.fromList
```

I am really happy on how dense and power full those function are

##  What am I concerned with

Doing that reveal to my what bother me the most with function programming. 
It's not really the syntax has I though before. The difficulty does not came from the choice made by the language designer.
It came from the complexity of the concept you are using. 

To me, it seems that thinking in terme of function is way more complicated than just reading a for loop. 
There is proverbe in go which sounds something like : 

> Don't write clever stuff, write boring stuff

To be boring your code must be dead simple, nothing should surprise the reader. I love that idea because I read more code than I write. If I had to be surprised each time I read a function, It would tkae ages to understand a whole project. 

I am not sure "boring stuff" is possible in `elm` and more generally in functionnal programming. 

I have done functionnal stuff before with [reactive programming](https://www.learnrxjs.io) and it felt the same way. 

This is a tool for clever peolpe. I want a tool for the dummies. I want to focus on my business not on the purity of my application. 

I love the types, the matcher, the no runtime error, But is elm really for me ? 