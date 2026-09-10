Bird = Class{}

local GRAVITY = 100

function Bird:init()
    self.image = love.graphics.newImage('images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    self.dy = 0
end

function Bird:update(dt)
    -- apply gravity (acceleration) to velocity
    self.dy = self.dy + GRAVITY * dt

    -- apply velocity to position
    self.y = self.y + self.dy * dt
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end