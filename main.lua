--Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no');

--love.graphics.setDefaultFilter( "nearest" )

function love.load()
  --DIMENSIONS DE LA FENETRE
  windowWidth = love.graphics.getWidth();
  windowHeight = love.graphics.getHeight();


  img1 = love.graphics.newImage("data/sprites/pavé.png")
  imgplayer = love.graphics.newImage("data/sprites/Baseperso.png")

  imgplayer1 = love.graphics.newQuad(0, 8, 32, 32, imgplayer:getDimensions())
  imgplayer2 = love.graphics.newQuad(0, 56, 32, 32, imgplayer:getDimensions())
  imgplayer3 = love.graphics.newQuad(0, 104, 32, 32, imgplayer:getDimensions())
  imgplayer4 = love.graphics.newQuad(0, 152, 32, 32, imgplayer:getDimensions())
  


tile1 = love.graphics.newQuad(64, 0, 32, 32, img1:getDimensions())

tilesize = 32

tilemap1 = {}

  tilemap1[1]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap1[2]  = {1,1,1,0,0,0,0,0,0,0,0,0,0,0}
  tilemap1[3]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap1[4]  = {1,0,0,0,0,0,1,1,1,1,1,1,0,0}
  tilemap1[5]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap1[6]  = {1,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap1[7]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap1[8]  = {1,0,0,0,0,1,1,0,0,0,0,1,1,0}
  tilemap1[9]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap1[10] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1}


  startx = 0
  starty = 64

  player = {}                      -- Définition des joueurs
    
    player.img = imgplayer1
    player.x = startx
    player.y = starty
    player.w = 32
    player.h = 32
    player.vx = 0
    player.vy = 0
    player.friction = 100
    player.gravity = 10
    player.accel = 150
    player.jump = -300
    player.state = "normal"


  if love.keyboard.isDown("escape") then  -- Création de la fonction pour quitter le jeu
    love.event.quit()
  end
  
  
  
  function checkcollisionfenetre()   -- Création de la fonction de collision des murs
  
    if player.y <= 0 then
      player.y = 0
      if player.vy < 0 then
        player.vy = 0
      end
    end
   
  
    if player.x <= 0 then
      player.x = 0
      if player.vx < 0 then
        player.vx = 0
      end
    end
    
    
    if player.y >= windowHeight - player.h then
      player.y = windowHeight - player.h
      if player.vy > 0 then
        player.vy = 0
      end
    end
   
    
    if player.x >= windowWidth - player.w then 
      player.x = windowWidth - player.w
      if player.vx > 0 then
        player.vx = 0
      end
    end
    
  end  -- fin de création de la fonction de collision des murs
  
  
  
  
  function collisionmurs(tilemap)
    
    for a = 1, 10, 1 do
      
      for b = 1, 14, 1 do
        
        if tilemap[a][b] == 1 then
          
          if player.vy >= 0 then
          
            if player.x < (b-1)*tilesize + tilesize and
              player.x > (b-1)*tilesize - player.w and
              player.y < (a-1)*tilesize  - player.h + tilesize/2 and
              player.y >= (a-1)*tilesize - player.h then
                
                if love.keyboard.isDown("q") or love.keyboard.isDown("d") then
                  
                else
                  if player.state == "jumping" then
                    player.vx = 0
                  end
                end 
                
                player.y = (a-1)*tilesize - player.h
                player.state = "normal"
                player.vy = 0
                
            end
            
          end
            
        end
        
      end
      
    end
    
  end
  
  
  
  function physicplayer(dt)
    
    -- gravité
    
    if player.state ~= "climbing" or player.state ~= "normal" then
      
      player.vy = player.vy + player.gravity*dt
      
    end
    
    -- friction
    
    --if 
    
    
    
    
  end


  function jumpplayer(dt)
    
    player.vy = player.vy + player.jump*dt
    
    player.state = "jumping"
    
  end
  
  
end



function love.update(dt)

  function love.keypressed(key)
    if key=="escape" then
        love.event.quit()
        
    elseif key=="space" then
      if player.state == "normal" then
      jumpplayer(dt)
      end
    elseif key=="q" then
      player.vx = player.vx - player.accel*dt
    elseif key=="d" then
      player.vx = player.vx + player.accel*dt
    end
  end
  
  function love.keyreleased(key)
    if key=="q" then
      if player.state == "normal"  then
        player.vx = 0
      end
    elseif key=="d" then
      if player.state == "normal"  then
        player.vx = 0
      end
    end
  end
      
  checkcollisionfenetre() 
  
  collisionmurs(tilemap1)
  
  physicplayer(dt)
  
  player.x = player.x + player.vx
  player.y = player.y + player.vy
  
  
end




function love.draw()
  
  
  for a = 1, 10, 1 do
    for b = 1, 14, 1 do
      if tilemap1[a][b] == 1 then
        love.graphics.draw(img1, tile1, (b-1)*32, (a-1)*32)
      end
    end
  end

  love.graphics.draw(imgplayer, player.img, player.x, player.y)  -- dessin du joueur
  
  
end





--Callback checking if mouse is clicked
function love.mousepressed(x, y, button, istouch, presses)
    
end



--Permit Game Extinction


