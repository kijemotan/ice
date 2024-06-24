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
local grip = 0.2
local midair = true
local doublejump = false
-- motan media
local motan           -- sprite
local motanh          -- height
local motanw          -- width
-- motan controls
local left

-- fun stuff
local lastsec
local sec

-- control images
local leftimg
local downimg
local upimg
local rightimg
local leftdraw
local downdraw
local updraw
local rightdraw

function love.load()  -- load assets
  love.graphics.setDefaultFilter('nearest','nearest')

  motan = love.graphics.newImage('graphics/motan.png')
  leftimg = love.graphics.newImage('graphics/left.png')
  downimg = love.graphics.newImage('graphics/down.png')
  upimg = love.graphics.newImage('graphics/up.png')
  rightimg = love.graphics.newImage('graphics/right.png')

  motanh = motan:getHeight()
  motanw = motan:getWidth()
  love.window.setMode(xres,yres,{})
  x = xres/2-motanw/2 -- center player
  y = yres/2-motanh/2
  vx = 0
  vy = 0

  sec = love.timer.getTime()
end

function love.update(dt)
  vy = vy+gravity*dt  -- apply gravity

  if left then
    vx = math.max(-speed,vx-speed*grip)
  elseif right then
    vx = math.min(speed,vx+speed*grip)
  end

  y = y+vy
  y = math.min(y,yres-motanh)
  x = x+vx
  x = x % xres

  if y == yres-motanh then
    midair = false
    doublejump = true
  else
    midair = true
  end
end

function love.draw()
  love.graphics.draw(motan,math.floor(x+0.5),math.floor(y+0.5))

  if leftdraw then
    love.graphics.draw(leftimg,0,16)
  end
  if downdraw then
    love.graphics.draw(downimg,16,16)
  end
  if updraw then
    love.graphics.draw(upimg,16,0)
  end
  if rightdraw then
    love.graphics.draw(rightimg,32,16)
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
    updraw = true
    if not isrepeat then
      if not midair then      -- 1st jump from the ground
        vy = jumppower
        doublejump = true
      elseif doublejump then  -- 2nd jump in the air
        vy = jumppower
        doublejump = false
      end
    end
  end
  if key == "down" then
    downdraw = true
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
    updraw = false
  end
  if key == "down" then
    downdraw = false
  end
end
