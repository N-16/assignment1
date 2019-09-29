--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score

    self.beginner = love.graphics.newImage('beginner.png')--****importing medals designed in minecraft****

    self.bwidth = self.beginner:getWidth()--****width for placement****

    self.veteran = love.graphics.newImage('veteran.png')

    self.vwidth = self.veteran:getWidth()


    self.epic = love.graphics.newImage('epic.png')

    self.ewidth = self.epic:getWidth()

end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 128, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 160, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 220, VIRTUAL_WIDTH, 'center')

    if self.score <= 5 then

        love.graphics.draw(self.beginner,(VIRTUAL_WIDTH/2)-(self.bwidth/2),15)

    end
    



    if self.score <= 10 then
        if self.score >  5 then
    
    

        love.graphics.draw(self.veteran,(VIRTUAL_WIDTH/2)-(self.vwidth/2),15)

        end

    end

     

    if self.score > 10 then

        love.graphics.draw(self.epic,(VIRTUAL_WIDTH/2)-(self.ewidth/2),15)

    end

   -- ****0-5 = beginner
    --5-10 = veteran
    --10 and above = epic ****

    
end
