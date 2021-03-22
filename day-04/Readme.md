# Day 4: a minesweeper

First switch of the day using a real matrix type to improve my code. 
That being done I focus my self on the neighbour stuff. 

I want ted to be able place mine a certain spot and have the neighbour cell telling how many mine there is around like this 


```
....1x1...
...1211...
...1x1....
...111....
```

Main blocking point today was to thing of a way of doing two stuff at the same time. Like how add a mine and update number of mine around. 
I also wanted to block putting twice a mine a the same spot. 

Again it came easily after having adapted the data model. 

There is still somethoing that borther me : I need to store the cell position in each cell.. Which is weird.. This not really part of the cells data, it should came from the Matrix library.