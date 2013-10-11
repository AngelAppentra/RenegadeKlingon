require 'GameFrameWork/SpaceObject'
require 'Utils/Debugging'
require 'Utils/GameConfig'

TextMessageObject = class('GameFrameWork.TextMessageObject',SpaceObject)

local frame_exit_char='#'

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function TextMessageObject:initialize(space,tile,posx,posy,messageFile)
  --100 health for the player
 
  self._msgTxt=""
  self._msgDraw=""
  self._ch_act=0
  self._last_frame=os.clock()
  self._frame_rate=12
  self._skip_frame=false
  self._height=0
  self._width=0
  self._msgDraw={}
  self._transparency=0
  --DEBUG_PRINT("Opening "..messageFile)
  if not love.filesystem.exists(messageFile) then
    return nil
  end
  
  local iterator=love.filesystem.lines(messageFile)
  for line in iterator do
        self._msgTxt=self._msgTxt..line.."\n"
  end
  --DEBUG_PRINT(self._msgTxt)
  
 local font = love.graphics.newFont("Resources/fonts/klingon_blade.ttf",30)
 love.graphics.setFont(font)
 local ch_act=0
 local count=0
 while (ch_act<string.len(self._msgTxt)) do

   self._msgDraw[count]=""
   n_lines=1
   for i = ch_act, string.len(self._msgTxt) do
        ch=string.sub(self._msgTxt, i, i)
        ch_act=i
        if(ch==frame_exit_char) then
          ch_act=i+1
          break
        end
        if(ch=='\n') then
          n_lines=n_lines+1
        end
        self._msgDraw[count]=self._msgDraw[count]..ch
    end

    if(self._width<font:getWidth(self._msgDraw[count])) then
      self._width=font:getWidth(self._msgDraw[count])
    end

    if(self._height<font:getHeight()*n_lines) then
      self._height=font:getHeight()*n_lines
    end

    count=count+1
 end
 self._height=self._height*1.5
 self._NumMsgs=count
 self._msgNum=0
 SpaceObject.initialize(self,space, tile,posx,posy,2000)
end

--return the width of this ship
function TextMessageObject:getWidth()
	return self._width
end

--return the height of this ship
function TextMessageObject:getHeight()
	return self._height
end


function TextMessageObject:die()

--DEBUG_PRINT("Text dies")
self:getSpace():unfreeze()
SpaceObject.die(self)
  
  ---
end

function TextMessageObject:readPressed()

  local config=GameConfig.getInstance()
  if config:isDownEnter() then
    self._skip_frame=true --skip message frame on intro
  end
end

--updates de message
function TextMessageObject:pilot(dt)
    
    
    if(self._msgNum==0) then
      self:getSpace():freeze(self)
    end

    if(self._msgNum>=self._NumMsgs) then
      self:die()
      --all message was done
    end

    if(self._transparency<220) then
      self._transparency=self._transparency+dt*40
    end
    

    if ((not self._skip_frame) and (os.clock()-self._last_frame<=self._frame_rate)) then
      return nil
    end
    
    self._skip_frame=false

    self._last_frame=os.clock()
    self._msgNum=self._msgNum+1
    self._transparency=0
   
end

--Draws the object in the screen
function TextMessageObject:draw()
    local x=self:getPositionX()
    local y=self:getPositionY()

    if self._msgDraw[self._msgNum]==nil then
      return nil
    end
    local r, g, b, a = love.graphics.getColor( )
    love.graphics.setColor(10,10,150,140)
    love.graphics.rectangle("fill",x,y,self._width,self._height)

    love.graphics.setColor(255,0,0,self._transparency)
    love.graphics.print("  "..self._msgDraw[self._msgNum],x+0.1*self._width, y)
    love.graphics.setColor(r,g,b,a)

end

function TextMessageObject:isTextMessage()
  return true
end
