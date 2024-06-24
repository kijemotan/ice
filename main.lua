-- game stuff
local xres = 640
local yres = 480
local font
local info

-- motan position
local x               -- -left +right
local y               -- -up +down
-- motan movement constants
local speed = 10      -- left, right
local gravity = 40    -- down
local jumppower = -15 -- suddenly up
local pound = 30
local grip = 0.2
-- motan movement variables
local vx
local vy
local midair = true
local doublejump = false
-- motan media
local motan           -- sprite
local motanh          -- height
local motanw          -- width
-- motan controls
local left
local down
local up
local right

-- control images
local leftimg
local downimg
local upimg
local rightimg
local leftdraw
local downdraw
local updraw
local rightdraw

-- level stuff
local level = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,0,
               0,0,0,0,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,0,0,2,2,2,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,0,2,2,2,2,0,0,0,0,0,0,0,
               0,0,0,0,0,0,0,0,2,2,2,2,2,0,0,0,0,0,0,0,
               0,1,0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0,0,0,
               2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2}

function love.load()  -- load assets
  love.graphics.setDefaultFilter('nearest','nearest')

  motan = love.graphics.newImage('graphics/jej.png')
  leftimg = love.graphics.newImage('graphics/left.png')
  downimg = love.graphics.newImage('graphics/down.png')
  upimg = love.graphics.newImage('graphics/up.png')
  rightimg = love.graphics.newImage('graphics/right.png')

  motanh = motan:getHeight()
  motanw = motan:getWidth()
  love.window.setMode(xres,yres,{})
  vx = 0
  vy = 0
  for i=0,15 do
    for j=1,19 do
      if level[j+i*20] == 1 then
        x = j*32
        y = i*32
      end
    end
  end

  font = love.graphics.newFont("fg.ttf", 12) 
  info = love.graphics.newText(font)
end

function love.update(dt)
  if midair then
    vy = vy+gravity*dt  -- apply gravity
  end
  
  if left and not right then
    vx = math.max(-speed,vx-speed*grip)
  elseif right and not left then
    vx = math.min(speed,vx+speed*grip)
  end

  if up and not midair then
    vy = jumppower
    doublejump = true
  end

  --[[
  y = y+vy
  y = math.min(y,yres-motanh)
  x = x+vx
  x = x%xres

  if y == yres-motanh then
    midair = false
    doublejump = true
  else
    midair = true
  end
  ]]--

  x = math.floor(x+0.5)
  vx = math.floor(vx+0.5)
  y = math.floor(y+0.5)
  vy = math.floor(vy+0.5)

  for i=0,14 do
    for j=0,19 do
      if level[1+j+i*20] <= 2 then

        if vx > 0 then  -- going right
          if x > j*32 and y > i*32 and y < i*32+32 then
            x = x-(x-j*32)
            vx = 0
          end
        elseif vx < 0 then  -- going left
          if x < j*32+32 and y > i*32 and y < i*32+32 then
            x = x+(j*32+32-x)
            vx = 0
          end
        end

        if vy > 0 then  -- going down
          if y > i*32 and x > j*32 and x < j*32+32 then
            y = y-(y-i*32)
            vy = 0
            midair = false
            doublejump = true
          end
        elseif vy < 0 then  -- going up
          if y < i*32+32 and x > j*32 and x < j*32+32 then
            y = y+(i*32+32-y)
            vy = 0
          end
        end

      end
    end
  end

  y = y+vy
  x = x+vx
  x = x%xres  -- loop horizontally

  if vy ~= 0 then
    midair = true
  end


end

function love.draw()
  for i=0,14 do
    for j=0,19 do
      if level[1+j+i*20] == 2 then
        love.graphics.draw(motan,j*32,i*32)
      end
    end
  end

  love.graphics.draw(motan,math.floor(x+0.5),math.floor(y+0.5))

  if leftdraw then
    love.graphics.draw(leftimg,x-16+motanw/4,y-40)
  end
  if downdraw then
    love.graphics.draw(downimg,x+motanw/4,y-24)
  end
  if updraw then
    love.graphics.draw(upimg,x+motanw/4,y-56)
  end
  if rightdraw then
    love.graphics.draw(rightimg,x+16+motanw/4,y-40)
  end

  info:set({"         x: "..x..
          "\n         y: "..y..
          "\n        vx: "..vx..
          "\n        vy: "..vy..
          "\n    midair: "..tostring(midair)..
          "\ndoublejump: "..tostring(doublejump)
          ,{1,1,1}
           })
  love.graphics.draw(info,0,0)
end

function love.keypressed(key, unused, isrepeat)
  if key == "left" then
    left = true
    leftdraw = true
  end
  if key == "right" then
    right = true
    rightdraw = true
  end
  if key == "up" then
    up = true
    updraw = true
    if doublejump and not isrepeat then
      vy = jumppower
      doublejump = false
    end
  end
  if key == "down" then
    downdraw = true
    vy = pound
  end
end

function love.keyreleased(key)
  if key == "left" then
    left = false
    leftdraw = false
  end
  if key == "right" then
    right = false
    rightdraw = false
  end
  if key == "up" then
    up = false
    updraw = false
  end
  if key == "down" then
    downdraw = false
  end
end
