local g
g = love.graphics
local Bullet
do
  local _class_0
  local _base_0 = {
    update = function(self, dt)
      self.x = self.x + (self.vx * dt)
      self.y = self.y + (self.vy * dt)
    end,
    draw = function(self)
      g.setColor(255, 255, 255)
      return g.rectangle("fill", self.x, self.y, self.radius)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, vx, vy, radius)
      self.x, self.y, self.vx, self.vy, self.radius = x, y, vx, vy, radius
    end,
    __base = _base_0,
    __name = "Bullet"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Bullet = _class_0
end
local Player
do
  local _class_0
  local _base_0 = {
    applyVelocities = function(self, dt)
      self.x = self.x + (self.vx * dt)
      self.y = self.y + (self.vy * dt)
    end,
    velocityConstants = function(self)
      if love.keyboard.isDown("d") then
        self.vx = self.speed
      elseif love.keyboard.isDown("a") then
        self.vx = -self.speed
      else
        self.vx = 0
      end
      if love.keyboard.isDown("s") then
        self.vy = self.speed
      elseif love.keyboard.isDown("w") then
        self.vy = -self.speed
      else
        self.vy = 0
      end
    end,
    applyBulletVelocities = function(self, dt)
      for _, b in ipairs(self.bullets) do
        b:update(dt)
      end
    end,
    draw = function(self)
      g.setColor(0, 255, 0)
      g.rectangle("fill", self.x, self.y, self.width, self.height)
      for _, b in ipairs(self.bullets) do
        g.setColor(255, 255, 0)
        g.circle("fill", b.x, b.y, b.radius)
      end
    end,
    shoot = function(self, key)
      local bullet
      local radius
      radius = 4
      local x, y
      x = self.x + self.width / 2
      y = self.y + self.height / 2
      local speedMultiplier
      speedMultiplier = 6
      if key == "right" then
        bullet = Bullet(x, y, self.speed * speedMultiplier, 0, radius)
        self.bullets[#self.bullets + 1] = bullet
      end
      if key == "left" then
        bullet = Bullet(x, y, -self.speed * speedMultiplier, 0, radius)
        self.bullets[#self.bullets + 1] = bullet
      end
      if key == "up" then
        bullet = Bullet(x, y, 0, -self.speed * speedMultiplier, radius)
        self.bullets[#self.bullets + 1] = bullet
      end
      if key == "down" then
        bullet = Bullet(x, y, 0, self.speed * speedMultiplier, radius)
        self.bullets[#self.bullets + 1] = bullet
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.x = 0
      self.y = 0
      self.width = 32
      self.height = 32
      self.bullets = { }
      self.vx = 0
      self.vy = 0
      self.speed = 200
    end,
    __base = _base_0,
    __name = "Player"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Player = _class_0
end
local player = Player()
love.load = function()
  love.update = function(dt)
    player:velocityConstants()
    player:applyVelocities(dt)
    return player:applyBulletVelocities(dt)
  end
  love.draw = function()
    return player:draw()
  end
  love.keypressed = function(key)
    if key == "escape" then
      love.event.quit()
    end
    return player:shoot(key)
  end
end
