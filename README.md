## 3d2d-clipping

✂️ Simple library for efficient and cross-platform clipping of 3D2D GUI in Garry's Mod

## Example

<p align="center">
    <img alt="Example" src="https://i.imgur.com/1L73wtQ.gif"/>
    <br/><br/>
    <b>Left:</b> No clipping
    <br/>
    <b>Right:</b> 2D clipped
</p>

## Usage

### Loading the Library
```lua
my_addon.clip = include("lib/clip.lua")
```

### Clipping 2D Rectangles
```lua
local width, height = 200, 400
cam.Start3D2D(pos, ang, scale)
    my_addon.clip:Scissor2D(width, height)
        -- Draw 2D clipped stuff here!
    my_addon.clip()
cam.End3D2D()
```

### Clipping 3D Bounding Boxes
```lua
local mins, maxs = ent:OBBMins(), ent:OBBMaxs()
-- or
local mins, maxs = ent:GetModelBounds()

my_addon.clip:Scissor3D(pos, ang, mins, maxs)
    cam.Start3D2D(pos, ang, scale)
        -- Draw 3D clipped stuff here!
    cam.End3D2D()
my_addon.clip()
```