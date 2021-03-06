-- /* RenegadeKlingon - LÖVE2D GAME
--  * Hud.lua
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
require 'GameFrameWork/SpaceObject'
require 'Utils/GameConfig'

Hud = class('GameFrameWork.Hud',SpaceObject)

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Hud:initialize(space)
  local bar=love.graphics.newImage("Resources/gfx/hud.png")
  self._score=0
  self._enemy=nil
  SpaceObject.initialize(self,space, bar,0,0,200000)
end

--return the width of this ship
function Hud:getWidth()
	return SpaceObject.getSpace(self):getXend()
end

--Performs movements changing the position of the object, firing bullets...
function Hud:pilot(dt)
  if(self._enemy~=nil and self._enemy:isDead())then
    self._enemy=nil
  end
end

--overwrite draw function
function Hud:draw()

  local my_space=SpaceObject.getSpace(self)
  local bar=SpaceObject.getDrawableObject(self)
  local sx,sy=GameConfig.getInstance():getScale()
  local x_pos=self:getPositionX()+bar:getWidth()*sx
  local y_pos=self:getPositionY()


  local player=self._space:getPlayerShip()
  local player_health=0
  local health_str=" Health: "
  local score_str=" Score: "..math.floor(self._score)

  local weaponpw=0
  local shieldpw=0
  local totalpw=0

  if player~=nil then
    player_health=math.floor(player:getHealth())
    weaponpw=player:getWeaponPower()
    shieldpw=player:getShieldPower()
    totalpw=player:getTotalPower()
  end

  health_str=health_str..player_health

  love.graphics.setColor(0,0,0,120)
  love.graphics.rectangle("fill",0,0,self:getWidth(),self:getHeight())

  love.graphics.setColor(255,255,255,255)

  love.graphics.print(health_str, x_pos, y_pos)

  y_pos=y_pos+love.graphics.getFont():getHeight()
  
  love.graphics.print(score_str, x_pos, y_pos)
  y_pos=y_pos-love.graphics.getFont():getHeight()
  x_pos=x_pos+love.graphics.getFont():getWidth(score_str)+love.graphics.getFont():getWidth("A")*3
  
  love.graphics.setColor(255,0,0,127+(weaponpw/totalpw)*128)
  love.graphics.print("weapon", x_pos, y_pos)
  
  x_pos=x_pos+love.graphics.getFont():getWidth("weapon")+40
  
  love.graphics.setColor(0,255,0,127+(shieldpw/totalpw)*128)
  love.graphics.print("shield", x_pos, y_pos)
  x_pos=x_pos-love.graphics.getFont():getWidth("weapon")-40
  
  love.graphics.setColor(255,0,0,127+(weaponpw/totalpw)*128)
  love.graphics.rectangle("fill",x_pos,y_pos+love.graphics.getFont():getHeight(),weaponpw*10,10)
  love.graphics.setColor(0,255,0,127+(shieldpw/totalpw)*128)
  x_pos=x_pos+love.graphics.getFont():getWidth("weapon")+40
  love.graphics.rectangle("fill",x_pos,y_pos+love.graphics.getFont():getHeight(),shieldpw*10,10)


  if(self._enemy~=nil) then
    x_pos=x_pos+200
    local r,g,b=self._enemy:getShipColor()
    love.graphics.setColor(r,g,b,255)
    love.graphics.print(self._enemy:toString()..":"..math.floor(self._enemy:getHealth()),
                       x_pos, y_pos)
  end
  love.graphics.setColor(255,255,255,255)

  SpaceObject.draw(self)
end

--hud does not get hurt
function Hud:collision(object,damage)
  return nil
end

--im the Hud, ovewritting from SpaceObject
function Hud:isHud()
	return true
end

--gets the score
function Hud:getScore()
  return math.floor(self._score)
end

--adds sc points to score
function Hud:addToScore(sc)
  self._score=self._score+sc
end

function Hud:setEnemy(enemy)
  self._enemy=enemy
end