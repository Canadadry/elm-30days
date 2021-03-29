# Day 10: Raycasting viewer

Today was the day where I left ellie. I did not thought I could finish this app in ellie. Which should mean I may have taken a challenge a bit too hard.

Well, I choose to leave ellie for atom. I tried VScode but the elm plugin was doing to much for me. Each time I write something my elm code was a christmas tree. I search for a plugin which does only syntax highlight and maybe code formating but I could not find it.

So atom was here for me. I only have installed the `language-elm` plugin and the `elm-format`.

For the project I write a small makefile to help me build and run my elm app

```
build:
	elm make src/Main.elm --output main.js

run:
	python -m SimpleHTTPServer
```

It's hard to have less 😁

And After some time, I felt needing the rebuild on save too. For that I install `chokidar` which is a npm tool that watch a direction and run `make build` if it see something moving.

It may not seems but it was quite challenging to have a viable env to work.

So I did not have much time to code.

I only prepare the squeletton of my app to receive the two most important functions :

```elm
computeDepth : Float -> Float -> Matrix.Matrix Bool -> Float -> Float
computeDepth x y dataMap direction =
```

and

```elm
depthToYandHeight : Float -> ( Float, Float )
depthToYandHeight d =
```

I draw something yesterday for the first function. I'll tried to implement it tomorrow. For the last one I guess a cross multiplication will be enough but I have no idea what to write right now.
