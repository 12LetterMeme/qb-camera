# QB-Camera

A simple camera script made for qbcore. Creates a usable camera item that takes picutres ingame and uploads to discord. Configurable zoom, zoom speeds and much! Made for the police on my server to document crime scenes and conduct investigations

![qb-camera copy](https://user-images.githubusercontent.com/91357757/167040019-92e7fb4c-e3bd-4816-bb2c-a0bdb6135a27.png)

# Author
slapped together by: 12LetterMeme#0001

# Read Me

Add this into your resource folder and remember to ensure qb-camera in your CFG

Don't forget to add the webhook! It's kinda the whole point of the script

Toss the image in your inventorys image section

Add this into your items.lua
```
["dslrcamera"]= { ["name"] = "dslrcamera", ["label"] = "PD Camera", ["weight"] = 1000, ["type"] = "item", ["image"] = "dslrcamera.png", ["unique"] = true, ["useable"] = true, ["shouldClose"] = true, ["combinable"] = nil, ["description"] = "DSLR Camera, with cloud uplink.. cool right?"},
```
qbcore camera script/qb-core camera script/FiveM camera script
