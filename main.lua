--Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no');

--love.graphics.setDefaultFilter( "nearest" )

--BITE EN BOAAAAAAAAAAAAAAAAAAAAAAAAAA

function love.load()
  --DIMENSIONS DE LA FENETRE
  windowWidth = love.graphics.getWidth();
  windowHeight = love.graphics.getHeight();


img2 = love.graphics.newImage("data/sprites/pavé.png")
imgplayer = love.graphics.newImage("data/sprites/Baseperso.png")

  imgplayer1 = love.graphics.newQuad(0, 8, 32, 32, imgplayer:getDimensions())
  imgplayer2 = love.graphics.newQuad(0, 56, 32, 32, imgplayer:getDimensions())
  imgplayer3 = love.graphics.newQuad(0, 104, 32, 32, imgplayer:getDimensions())
  imgplayer4 = love.graphics.newQuad(0, 152, 32, 32, imgplayer:getDimensions())
  


tile2 = love.graphics.newQuad(64, 0, 32, 32, img2:getDimensions())


tilemap = {}

  tilemap[1]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap[2]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap[3]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap[4]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap[5]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap[6]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap[7]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap[8]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap[9]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap[10] = {2,2,2,2,2,2,2,2,2,2,2,2,2,2}


  player = {}                      -- Définition des joueurs
    
    player.img = imgplayer1
    player.x = 64
    player.y = 64
    player.w = 32
    player.h = 32
    player.vx = 0
    player.vy = 0
    player.friction = 150
    player.gravity = 10
    player.accel = 500
    player.jump = -190
    player.state = "normal"


  if love.keyboard.isDown("escape") then  -- Création de la fonction pour quitter le jeu
    love.event.quit()
  end
  
  
  
  function checkcollisionfenetre()   -- Création de la fonction de collision des murs
  
    if player.y <= 0 then
      player.y = 0
    end
   
  
    if player.x <= 0 then
      player.x = 0
    end
    
    
    if player.y >= windowHeight - player.h then
      player.y = windowHeight - player.h
    end
   
    
    if player.x >= windowWidth - player.w then 
      player.x = windowWidth- player.w
    end
    
  end  -- fin de création de la fonction de collision des murs
  
  
  function physicplayer(dt)
    
    -- gravité
    
    if player.state ~= "climbing" then
      
      player.vy = player.vy + player.gravity*dt
      
    end
    
    -- friction
    
    --if 
    
    
    player.x = player.x + player.vx
    player.y = player.y + player.vy
    
  end
  
  
  function collisionmurs()
    
    for a = 1, 10, 1 do
      
      for b = 1, 14, 1 do
        
        
        
      end
      
    end
    
  end

    
end

function love.update(dt)

  

  physicplayer(dt)


  checkcollisionfenetre() 
  

end



function love.draw()
  
  
  for a = 1, 10, 1 do
    for b = 1, 14, 1 do
      if tilemap[a][b] == 2 then
        love.graphics.draw(img2, tile2, (b-1)*32, (a-1)*32)
      end
    end
  end

  love.graphics.draw(imgplayer, player.img, player.x, player.y)  -- dessin du joueur
  
  
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

