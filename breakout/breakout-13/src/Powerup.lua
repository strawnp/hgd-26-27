Powerup = Class{}

function Powerup:init(x, y)
    self.x = x
    self.y = y

    self.dy = 80

    self.remove = false
end

function Powerup:update(dt)
    self.y = self.y + self.dy * dt
end

function Powerup:render()
    love.graphics.draw(gTextures['main'], gFrames['powerups'][3], self.x, self.y)
end