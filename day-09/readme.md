# Day 9: a sudoku grid validator

I finnaly finish my sudoku grod validator. Now I can write a solver 🤭

Well today was way better, I found myself more confortable writting elm, it was easier to write bigger function without cutting them in small chunck. 

So for validator, We use my yesterday `removeDuplicate` then we extrat whatever we want to validate : row, column or bloc and reduce to its unique value and if the length with duplicated is the same has the one without then it's valid. 

Checking row its easy due to the fact that a `Matrix a` is just a `List List a` so a list of row. 

For column we have to transpose it. Small issue on that, since it's not provided I had to hanlde the `Maybe` returned by the `Matrix.get`  so I needed an hardcoded default value 😕

Block was the hardest part. It allways is evet in imperative programmig. I could do it thanks to the `Matrix.slice` which extract a rectangular sub matrix. I just had to do some calculation to determine the position of each block from it's id

```
id -> start -> start/3
0 -> (0,0) -> (0,0)
1 -> (0,3) -> (0,1)
2 -> (0,6) -> (0,2)
3 -> (3,0) -> (1,0)
4 -> (3,3) -> (1,1)
5 -> (3,6) -> (1,2)
...
```

So to me it was easy to see a modulo for x and an interger division on y from that the `\blockId blockSize ->( modBy blockSize blockId * blockSize, blockId // blockSize * blockSize )` was obvious

But It was not that easy because my validation function had to take a `Matrix` as input and with my block extraction I had a `List Matrix a`  with a list of small 3x3 matrix. And nothing was diplaying. 

It was my **first runtime bug**. \o/ finally I have written enough elm code to bump into one. But I didnot know how to fix it. Thanks to `Wolfgang Schuster (wolfadex)` from the elm's slack I discover the `Debug.log` which allow me to find the culprit and fix my bug. (an error in some artimetic formula)