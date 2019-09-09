function love.load()
    timer = 0
    alpha = 0
 
    fadein  = 2
    display = 7
    fadeout = 9

    menuImg = love.graphics.newImage("tomb_003.png")
 
 end

 
 function love.update(dt)
   

    if love.keyboard.isDown("a") then
        if alpha < 0 then 
            alpha = 0
        else
            alpha = alpha - 0.01
        end
    elseif love.keyboard.isDown("z") then
        if alpha > 1 then 
            alpha = 1
        else
            alpha = alpha + 0.01
        end
    end

 end

 function love.draw()
    love.graphics.setColor(255, 255, 255, alpha)
    love.graphics.draw(menuImg, 0, 0)

    love.graphics.setColor(100,100,100)
    love.graphics.print("Valeur Alpha = "..alpha, 30, 530)

 end