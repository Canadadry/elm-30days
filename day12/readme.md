# Day 12: Json

More than a week has passed since the last challenge. I moved out and it cut my routine. Assembling ikea furniture and unpacking stuff take me too much time. I had to cut elm...

So today I'll continue my journey with a fresh subject, it was a bit daunting to finish the last project. It needed something smaller.

So I pick the next scary stuff that pop up in my mind.... **JSON**

Okay lets try to unmarshal this json file

```json
{
    "firstname":"clark",
    "lastname":"kend",
    "realname":"kal-el",
    "surname":"superman",
    "job":"reporter",
    "address":"the big farm in smallville",
    "friend":[
        {
            "lastname":"lane",
            "firstname":"lois",
            "relationship":"lover"
        },
        {
            "lastname":"who knows",
            "firstname":"jimmy",
            "relationship":"cokorker"
        }
    ]
}
```

And this was pretty easy, I find this is the example that allow elm to shine the most. You clearly see all the errors handling and why out cannot have strange runtime issue.

It won't remove the runtime issue when you receive a unexpected json file. The only part I don't like and don't see expanding is the json decoding. I was obliged to use a `map7` , to decode 7 fields. For  fields, you use `map9` ave for 256 fields you use `map256`...
In fact this not true because `map7`, `map9`, `map256` are real function written by hand, so this is only valid for 9 or less fields....

And more you have to Decode field in the order of field declaration which feel odd and error prone. Did I have written firstname or lastname in first ?
