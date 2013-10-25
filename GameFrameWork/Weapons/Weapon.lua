require 'Utils/middleclass/middleclass'


Weapon = class('GameFrameWork.Weapons.Weapon')

--constructor
function Weapon:initialize(ship_to_attach)
  self._shot_cadence=0.3
  self._last_shot=0
  self:setAttachedShip(ship_to_attach)
end

function Weapon:PlayerCadence()
	return 0.1
end

function Weapon:EnemieCadence()
	return 1.5
end

function Weapon:calculateFire()

	 --CALCULATE THE FIRE FOR THE PLAYER
	 local my_ship=self:getAttachedShip()
   	 local my_space=my_ship:getSpace()
     local position_x=my_ship:getPositionX()
     local position_y=my_ship:getPositionY()
	 local shot_emit_x=position_x+my_ship:getWidth()
	 local shot_emit_y=position_y+my_ship:getHeight()/2
	 local x_relative_step=6
	 local y_relative_step=0

	 if(my_ship:isEnemyShip()) then
	 	--CALCULATE THE FIRE FOR THE ENEMIES
   		shot_emit_x=position_x-50
   		shot_emit_y=position_y+my_ship:getHeight()/2
   		player=my_space:getPlayerShip()

   		local player_x=0
   		local player_y=0
   
   		local delta_x=-3
   
   		local delta_y=0
   
		if(player~=nil) then
		     player_x=player:getPositionX()
		     player_y=player:getPositionY()
		   
		     delta_x=-3
		     delta_y=3*((player_y-position_y)/(math.abs(player_x-position_x)))
		end
		return shot_emit_x,shot_emit_y,delta_x,delta_y
	 end

	 return shot_emit_x,shot_emit_y,x_relative_step,y_relative_step
end

function Weapon:doFire()

end

function Weapon:fire(dt)
	self._last_shot=self._last_shot+dt
	if(self._last_shot>self._shot_cadence) then
		self:doFire()
		self._last_shot=0
	end
end

function Weapon:getAttachedShip()
  return self._ship
end

function Weapon:setAttachedShip(ship)

  self._ship=ship
  if (self._ship~=nil) and  (self._ship:isEnemyShip()) then
  	self._shot_cadence=self:EnemieCadence()
  end
  
  if (self._ship~=nil) and  (self._ship:isPlayerShip()) then
  	self._shot_cadence=self:PlayerCadence()
  end
	
end