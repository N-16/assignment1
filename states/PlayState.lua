--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24



function PlayState:init()


    self.bird = Bird()
    PAUSE = false
    
    self.pipePairs = {}
    self.pauseimage = love.graphics.newImage('pause.png')
    --****image for pause****
    self.pausewidth = self.pauseimage:getWidth()
    self.pauseheight = self.pauseimage:getHeight()
    self.timer = 0
    self.score = 0
    spawntime = math.random(2,5) -- ****global variable so that it can be accesed by pipepair****
    

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(70) + 20
end


function PlayState:update(dt)
    

    --****statement for pause****
    if love.keyboard.wasPressed('p') then

        if PAUSE  then 

            PAUSE = false
            sounds['music']:play()
            sounds['resume']:play()
            --****pause of music on pause of game****
                                  
        else

            PAUSE = true
            sounds['music']:pause()
            sounds['pause']:play()
                    
        end
    end

    if not PAUSE then--****Timer stops on pause****

        self.timer = self.timer + dt

    end
    
    -- spawn a new pipe pair every second and a half
    if self.timer >  spawntime then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = math.max(-PIPE_HEIGHT + 10, 
        math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 120 - PIPE_HEIGHT))--120 the max value of gapheight
        self.lastY = y

        -- add a new pipe pair at the end of the screen at our new Y
            table.insert(self.pipePairs, PipePair(y))
        -- reset timer
        self.timer = 0

        spawntime = math.random(2,5)--****random spawn time after every spawn****
    end

      -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        -- update position of pair****if its not in pause state****
        if not PAUSE then

            pair:update(dt)  

        end
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- simple collision between bird and all pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()

                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    -- update bird based on gravity and input
    if not PAUSE then--****pausing bird update on pause****

        self.bird:update(dt)

    end

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then

        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score
        })

    end

    

end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

   
    self.bird:render()

    if PAUSE then 
       -- love.graphics.setFont(flappyFont)
       -- love.graphics.printf('pause',50,50,VIRTUAL_WIDTH,'center')
      
       love.graphics.draw(self.pauseimage,(VIRTUAL_WIDTH/2) - (self.pausewidth/2),
       (VIRTUAL_HEIGHT/2) - (self.pauseheight/2))

       --****pause image render****

    end

end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter()
    -- if we're coming from death, restart scrolling
    
    scrolling = true
           
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end