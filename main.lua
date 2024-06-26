-- game stuff
local xres = 640
local yres = 480
local font
local info

-- motan position
local x               -- left edge
local x2              -- right edge
local y               -- upper edge
local y2              -- lower edge
local sx              -- spawn pos
local sy
-- motan movement constants
local speed = 10      -- left, right
local gravity = 40    -- down
local jumppower = -15 -- suddenly up
local pound = 30
local grip = 0.2
-- motan movement variables
local vx = 0
local vy = 0
local midair = true
local doublejump = false
local collidedv
local collidedh
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

  tile = love.graphics.newImage('graphics/tile.png')
  spawn = love.graphics.newImage('graphics/spawn.png')
  motan = love.graphics.newImage('graphics/jej.png')
  leftimg = love.graphics.newImage('graphics/left.png')
  downimg = love.graphics.newImage('graphics/down.png')
  upimg = love.graphics.newImage('graphics/up.png')
  rightimg = love.graphics.newImage('graphics/right.png')

  motanh = motan:getHeight()
  motanw = motan:getWidth()
  love.window.setMode(xres,yres,{})
  for i=0,15 do
    for j=1,19 do
      if level[j+i*20] == 1 then
        x = j*32
        y = i*32
        sx = x
        sy = y
      end
    end
  end

  font = love.graphics.newFont("fg.ttf", 12) 
  info = love.graphics.newText(font)
end

function love.update(dt)
  --print("--------------------")

  x2 = x + motanw
  y2 = y + motanh

  if midair then
    vy = vy+gravity*dt  -- apply gravity
  end
  
  if left and not right then
    vx = math.max(-speed,vx-speed*grip)
  elseif right and not left then
    vx = math.min(speed,vx+speed*grip)
  end

  if up and not midair then
    y = y-1
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

  x = x+vx
  x = x%xres

  if y >= 1000 then
    x = sx
    y = sy
    print("respawned!")
  end
  
  collided = false
  
  -- check for horizontal collision
  for i=0,14 do
    ty = i*32   -- tile upper edge
    ty2 = ty+32 -- tile lower edge
    for j=0,19 do
      tx = j*32   -- tile left edge
      tx2 = tx+32 -- tile right edge

      if level[1+j+i*20] >= 2 then
        if x2 > tx and x <= tx2 and y2 > ty and y <= ty2 then
          collidedh = true
          if vx > 0 then  -- going right
            x = tx-32
            vx = 0
          elseif vx < 0 then  -- going left
            x = tx2
            vx = 0
          end
        end
      end
    end
  end

  y = y+vy

  -- check for vertical collision
  for i=0,14 do
    ty = i*32   -- tile upper edge
    ty2 = ty+32 -- tile lower edge
    for j=0,19 do
      tx = j*32   -- tile left edge
      tx2 = tx+32 -- tile right edge

      if level[1+j+i*20] >= 2 then
        if x2 >= tx and x <= tx2 and y2 >= ty and y <= ty2 then
          collidedv = true
          if vy < 0 then  -- going up
            y = ty2
            vy = 0
          else  -- going down or not moving vertically
            y = ty-32
            vy = 0
            midair = false
            doublejump = true
          end
        end
      end
    end
  end
  
  --print("vy: "..vy)
  if vy ~= 0 then
    midair = true
  end
  if not collided then
    midair = true
  end
  --print("collided: "..tostring(collided))
  --print("midair: "..tostring(midair))

end

function love.draw()
  for i=0,14 do
    for j=0,19 do
      if level[1+j+i*20] == 2 then
        love.graphics.draw(tile,j*32,i*32)
      elseif level[1+j+i*20] == 1 then
        love.graphics.draw(spawn,j*32,i*32)
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
          "\n        vx: "..vx..
          "\n         y: "..y..
          "\n        vy: "..vy..
          "\n    midair: "..tostring(midair)..
          "\ndoublejump: "..tostring(doublejump)..
          "\n  collided: "..tostring(collided)
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
    midair = true
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
