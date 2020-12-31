--[[
################################################################################

                         3D2D Stencil Clipping Library
              https://github.com/WilliamVenner/gmod-3d2d-clipping

################################################################################

MIT License

Copyright (c) 2020 William Venner

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

################################################################################
]]

AddCSLuaFile()
if SERVER then return end

local render = render
local Vector = Vector
local STENCIL_ALWAYS = STENCIL_ALWAYS
local STENCIL_KEEP = STENCIL_KEEP
local STENCIL_REPLACE = STENCIL_REPLACE
local STENCIL_EQUAL = STENCIL_EQUAL
local MATERIAL_CULLMODE_CW = MATERIAL_CULLMODE_CW
local MATERIAL_CULLMODE_CCW = MATERIAL_CULLMODE_CCW

local transparent = Color(0, 0, 0, 0)
local clipping = false

local clip = {}
setmetatable(clip, {
	__call = function()
		if clipping then
			clipping = false
			render.SetStencilEnable(false)
		end
	end
})
setfenv(1, clip)

local stencil do
local stenciling = false
function stencil()
	if stenciling then
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		stenciling = false
		return
	end

	render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()

	render.SetStencilEnable(true)
	render.SetStencilReferenceValue(1)

	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_REPLACE)

	stenciling = true
end end

do
	local vert1, vert2, vert3, vert4 = Vector(), Vector(), Vector(), Vector()
	function clip:Scissor2D(w, h)
		clip()

			vert2[2] = h

			vert3[1] = w
			vert3[2] = h

			vert4[1] = w

		stencil()

			render.CullMode(MATERIAL_CULLMODE_CW)
				render.SetColorMaterial()
				render.DrawQuad(vert1, vert2, vert3, vert4, transparent)
			render.CullMode(MATERIAL_CULLMODE_CCW)

		stencil()

		clipping = true
	end
end

do
	function clip:Scissor3D(pos, ang, mins, maxs)
		clip()

		stencil()

			render.SetColorMaterial()
			render.DrawBox(pos, ang, mins, maxs, transparent, true)

		stencil()

		clipping = true
	end
end

return clip