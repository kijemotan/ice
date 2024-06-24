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
local gravity = 15    -- down
local jumppower = 10  -- suddenly up
-- motan media
local motan           -- sprite
local motanh          -- height
local motanw          -- width

-- fun stuff
local lastsec
local sec

function love.load()  -- load assets
  love.graphics.setDefaultFilter('nearest','nearest')
  motan = love.graphics.newImage('graphics/motan.png')
  motanh = motan:getHeight()
  motanw = motan:getWidth()
  love.window.setMode(xres,yres,{})
  x = xres/2-motanw/2 -- center player
  y = yres/2-motanh/2
  vx = 5
  vy = -10

  sec = love.timer.getTime()
end

function love.update(dt)
  vy = vy+gravity*dt  -- apply gravity

  lastsec = love.timer.getTime()
  if lastsec-sec >= 1 then
    sec = lastsec
    vy = -10
  end

  y = y+vy
  y = y % yres
  x = x+vx
  x = x % xres
end

function love.draw()
  love.graphics.draw(motan,math.floor(x+0.5),math.floor(y+0.5))
end
