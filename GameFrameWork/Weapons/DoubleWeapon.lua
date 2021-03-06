-- /* RenegadeKlingon - LÖVE2D GAME
--  * DoubleWeapon.lua
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
require 'GameFrameWork/Weapons/Weapon'
require 'GameFrameWork/Bullets/AnimatedBullet'

DoubleWeapon = class('GameFrameWork.Weapons.DoubleWeapon',Weapon)

--constructor
function DoubleWeapon:initialize(ship,bullet)
  self._bullet=bullet
  Weapon.initialize(self,ship)
end


function DoubleWeapon:PlayerCadence()
  return 0.3
end

function DoubleWeapon:doFire()
  local my_ship=self:getAttachedShip()
  local my_space=my_ship:getSpace()
  local shot_emit_x,shot_emit_y,x_relative_step,y_relative_step=self:calculateFire()
  local emit_delta=15

   AnimatedBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y-my_ship:getHeight()/2-emit_delta,
                     x_relative_step,y_relative_step,self._bullet)

    AnimatedBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y+my_ship:getHeight()/2-emit_delta,
                     x_relative_step,y_relative_step,self._bullet)
   
end

function DoubleWeapon:copy(x)
    Weapon.copy(self,x)
    x._bullet=self._bullet
end

function DoubleWeapon:clone()
   x=DoubleWeapon:new(nil)
   self:copy(x)
   return x
end