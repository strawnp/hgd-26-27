Bird = Class{}

local GRAVITY = 930
local ANTI_GRAVITY = 270

local debug = true

function Bird:init()
    self.image = love.graphics.newImage('images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    self.dy = 0
end

function Bird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    -- apply gravity (acceleration) to velocity
    self.dy = self.dy + GRAVITY * dt

    -- apply anti-gravity acceleration force
    if love.keyboard.wasPressed('space') then
        self.dy = -ANTI_GRAVITY
    end

    -- apply velocity to position
    self.y = self.y + self.dy * dt
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
    
    if debug then
        love.graphics.rectangle('line', self.x + 2, self.y + 2, self.width - 6, self.height - 6)
    end
end