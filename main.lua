-- game stuff
local xres = 640
local yres = 480

-- motan position
local x               -- -left +right
local vx
local y               -- -up +down
local vy
-- motan movement
local speed = 10      -- left, right
local gravity = 40    -- down
local jumppower = -15 -- suddenly up
local pound = 30
local grip = 0.2
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
local counter

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
end

function love.update(dt)
  vy = vy+gravity*dt  -- apply gravity
  
  if left and not right then
    vx = math.max(-speed,vx-speed*grip)
  elseif right and not left then
    vx = math.min(speed,vx+speed*grip)
  end

  if up and not midair then
    vy = jumppower
    doublejump = true
  end

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
end

function love.draw()
  counter = 1
  for i=0,15 do
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
