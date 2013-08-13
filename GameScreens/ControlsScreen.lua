require 'GameScreens/Screen'
require 'Utils/GameConfig'

ControlsScreen = class('ControlsScreen', Screen)

local NONE_OPTION=0
local UP_OPTION=1
local DOWN_OPTION=2
local LEFT_OPTION=3
local RIGHT_OPTION=4
local FIRE_OPTION=5
local ENTER_OPTION=6
local ESCAPE_OPTION=7

local config=GameConfig.getInstance()

local _loadMenus=function(self)
  self._controlsMenu=Menu:new(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
  self._controlsMenu:addItem("Up----->"..config:getKeyUp())
  self._controlsMenu:addItem("Down--->"..config:getKeyDown())
  self._controlsMenu:addItem("Left--->"..config:getKeyLeft())
  self._controlsMenu:addItem("Right-->"..config:getKeyRight())
  self._controlsMenu:addItem("Fire--->"..config:getKeyFire())
  self._controlsMenu:addItem("Enter-->"..config:getKeyEnter())
  self._controlsMenu:addItem("Escape->"..config:getKeyEscape())
  self._selectedOption=NONE_OPTION
end

function ControlsScreen:initialize()
  self._selectedOption=NONE_OPTION
  _loadMenus(self)
end 


function ControlsScreen:draw()

	if(self._selectedOption==NONE_OPTION) then
		self._controlsMenu:print()
	else
		
		love.graphics.print("Press the key...", love.graphics.getWidth()/2,love.graphics.getHeight()/2)
	end
end

function ControlsScreen:update(dt)
	return 1
end

function ControlsScreen:readPressed()
    if(self._selectedOption==NONE_OPTION) then
      if config:isDownEscape() then
        return Screen:getExitMark()
      end
      self._selectedOption=self._controlsMenu:readPressed()
    return 1
   elseif (self._selectedOption==UP_OPTION) then
      config:setKeyUp(key)
   elseif (self._selectedOption==DOWN_OPTION) then
      config:setKeyDown(key)
   elseif (self._selectedOption==LEFT_OPTION) then
      config:setKeyLeft(key)
   elseif (self._selectedOption==RIGHT_OPTION) then
      config:setKeyRight(key)
   elseif (self._selectedOption==FIRE_OPTION) then
      config:setKeyFire(key)
   elseif (self._selectedOption==ENTER_OPTION) then
    config:setKeyEnter(key)
   elseif (self._selectedOption==ESCAPE_OPTION) then
    config:setKeyEscape(key)
   end
   _loadMenus(self)
   return 1

end