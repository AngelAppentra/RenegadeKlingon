-- /* RenegadeKlingon - LÖVE2D GAME
--  * ButtonRead.lua
--  * Copyright (C) Angel Baltar Diaz
--  *
--  * This program is free software: you can redistribute it and/or
--  * modify it under the terms of the GNU General Public
--  * License as published by the Free Software Foundation; either
--  * version 3 of the License, or (at your option) any later version.
--  *
--  * This program is distributed in the hope that it will be useful,
--  * but WITHOUT ANY WARRANTY; without even the implied warranty of
--  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--  * General Public License for more details.
--  *
--  * You should have received a copy of the GNU General Public
--  * License along with this program.  If not, see
--  * <http://www.gnu.org/licenses/>.
--  */

require 'Utils/Debugging'

ButtonRead = class('GameFrameWork.ButtonRead')

local _instance=nil
--constructor
local __initialize_joy=function(self)
	self._joypad=false
	self._joy=nil
	self._joypadButton=0
end

local __initialize_key=function(self)
	self._keyboard=false
	self._key="unknown"
	self._unicode=0
end

local __initialize_mouse=function(self)
	self._mouse=false
	self._mouse_x=0
	self._mouse_y=0
end

local __initialize = function(self)
	__initialize_key(self)
	__initialize_joy(self)
	__initialize_mouse(self)
end

--return the width of this ship
function ButtonRead.getInstance()
  if _instance==nil then
  	_instance=ButtonRead:new()
  	__initialize(_instance)
  end
  return _instance
end

function ButtonRead:cleanBuffer()
	__initialize(self)
end

function ButtonRead:setMouse(x,y)
	self._mouse=true
	self._mouse_x=x
	self._mouse_y=y
end

function ButtonRead:setKey(key,unicode)
	self._keyboard=true
	self._key=key
	self._unicode=unicode
end

function ButtonRead:setJoyButton(joypad,button)
	self._joypad=true
	self._joy=joypad
	self._joypadButton=button
end

--returns true if there is something to read in the buffer
function ButtonRead:isSomethingToRead()
	return self._keyboard or self._joypad or self._mouse
end

function ButtonRead:getKey()
	if not self._keyboard then
		return nil
	else
		key=self._key
		__initialize_key(self)--only 1 read
		DEBUG_PRINT("button read "..key)
		return key
	end
	
end

function ButtonRead:getJoys()
	if not self._joypad then
		DEBUG_PRINT("button read nil")
		return nil,nil
	else
		joy=self._joy
		button=self._joypadButton
		__initialize_joy(self) --only 1 read
		DEBUG_PRINT("button read "..button)
		return joy,button
	end
end

function ButtonRead:getMouse()
	if not self._mouse then
		return nil,nil
	else

		local x=self._mouse_x
		local y=self._mouse_y
		__initialize_mouse(self)--only 1 read
		return x,y
	end
end