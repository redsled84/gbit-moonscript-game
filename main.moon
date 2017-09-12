{graphics: g} = love

class Bullet
  new: (@x, @y, @vx, @vy, @radius) =>
  update: (dt) =>
    @x += @vx * dt
    @y += @vy * dt
  draw: =>
    g.setColor 255, 255, 255
    g.rectangle "fill", @x, @y, @radius
  outOfBounds: =>
    return not (@x > 0 and @x < g.getWidth! and @y > 0 and @y < g.getHeight!)

class Player
  new: =>
    @x = 0
    @y = 0
    @width = 32
    @height = 32
    @bullets = {}
    @vx = 0
    @vy = 0
    @speed = 200
  applyVelocities: (dt) =>
    @x += @vx * dt
    @y += @vy * dt
  velocityConstants: =>
    if love.keyboard.isDown "d"
      @vx = @speed
    elseif love.keyboard.isDown "a"
      @vx = -@speed
    else
      @vx = 0
    if love.keyboard.isDown "s"
      @vy = @speed
    elseif love.keyboard.isDown "w"
      @vy = -@speed
    else
      @vy = 0
  applyBulletVelocities: (dt) =>
    for _, b in ipairs @bullets
      b\update dt
  draw: =>
    g.setColor 0, 255, 0
    g.rectangle "fill", @x, @y, @width, @height
    for _, b in ipairs @bullets
      g.setColor 255, 255, 0
      g.circle "fill", b.x, b.y, b.radius
  shoot: (key) =>
    local bullet
    local radius
    radius = 4
    local x, y
    x = @x + @width / 2
    y = @y + @height / 2
    local speedMultiplier
    speedMultiplier = 6
    if key == "right"
      bullet = Bullet x, y, @speed * speedMultiplier, 0, radius
      @bullets[#@bullets+1] = bullet
    if key == "left"
      bullet = Bullet x, y, -@speed * speedMultiplier, 0, radius
      @bullets[#@bullets+1] = bullet
    if key == "up"
      bullet = Bullet x, y, 0, -@speed * speedMultiplier, radius
      @bullets[#@bullets+1] = bullet
    if key == "down"
      bullet = Bullet x, y, 0, @speed * speedMultiplier, radius
      @bullets[#@bullets+1] = bullet
  boundBullets: =>
    -- how to loop reverse?
    for i = #@bullets, 1, -1
      local b
      b = @bullets[i]
      if b\outOfBounds!
        table.remove(@bullets, i)


player = Player!

-- required love2d functions
love.load = ->
  love.update = (dt) ->
    player\velocityConstants!
    player\applyVelocities dt
    player\applyBulletVelocities dt
    print #player.bullets
    player\boundBullets!

  love.draw = ->
    player\draw!
  love.keypressed = (key) ->
    if key == "escape"
      love.event.quit!
    player\shoot key