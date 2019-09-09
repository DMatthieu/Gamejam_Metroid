--Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no');

--love.graphics.setDefaultFilter( "nearest" )

function love.load()
    --DIMENSIONS DE LA FENETRE
    windowWidth = love.graphics.getWidth();
    windowHeight = love.graphics.getHeight();

    --include otherfile
    
    module_menu = require "menu"--on met pas.lua pour le chemin du fichier.

end

function love.update(dt)

    

end

function love.draw()
    
end

--Callback checking if mouse is clicked
function love.mousepressed(x, y, button, istouch, presses)
    
end



--Permit Game Extinction
function love.keypressed(key)
    if key=="escape" then
        love.event.quit()
    end  
end

