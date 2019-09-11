--Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no');

--love.graphics.setDefaultFilter( "nearest" )


function love.load()
  --DIMENSIONS DE LA FENETRE
  windowWidth = love.graphics.getWidth();
  windowHeight = love.graphics.getHeight();


  img1 = love.graphics.newImage("data/sprites/pavé.png")
  img2 = love.graphics.newImage("data/sprites/ground.png")
  imgplayer = love.graphics.newImage("data/sprites/Baseperso.png")

  imgplayer1 = love.graphics.newQuad(0, 8, 32, 32, imgplayer:getDimensions())
  imgplayer2 = love.graphics.newQuad(0, 56, 32, 32, imgplayer:getDimensions())
  imgplayer3 = love.graphics.newQuad(0, 104, 32, 32, imgplayer:getDimensions())
  imgplayer4 = love.graphics.newQuad(0, 152, 32, 32, imgplayer:getDimensions())
  


  tile1 = love.graphics.newQuad(64, 0, 32, 32, img1:getDimensions())
  tile2 = love.graphics.newQuad(64, 0, 32, 32, img2:getDimensions())

  tilesize = 32

  tilemap1 = {}

  tilemap1[1]  = {0,0,0,0,0,0,1,0,0,0,0,0,0,0}
  tilemap1[2]  = {0,0,0,0,0,0,0,0,0,2,0,0,0,0}
  tilemap1[3]  = {0,0,0,0,1,0,0,0,0,0,0,0,0,0}
  tilemap1[4]  = {1,1,0,0,0,1,1,1,1,1,1,1,0,0}
  tilemap1[5]  = {0,0,1,0,0,0,0,0,0,0,0,0,0,0}
  tilemap1[6]  = {1,1,1,1,1,1,0,0,0,0,0,0,0,0}
  tilemap1[7]  = {0,0,0,0,1,0,0,0,0,2,0,2,0,0}
  tilemap1[8]  = {1,0,0,0,0,1,1,1,1,1,1,1,1,0}
  tilemap1[9]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap1[10] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1}


  hitboxmap = {}
  
  
  hitbox(tilemap1)


  startx = 320
  starty = 0

  player = {}                      -- Définition des joueurs
    
    player.img = imgplayer1
    player.x = startx
    player.y = starty
    player.w = 32
    player.h = 32
    player.vx = 0
    player.vy = 0
    --player.friction = 100
    player.speed = 3
    player.gravity = 3
    player.jump = 100
    player.state = "falling"

    timerjumping = 0

  if love.keyboard.isDown("escape") then  -- Création de la fonction pour quitter le jeu
    love.event.quit()
  end
  
end

-------------------------------------------------------------------------------------------------



function love.update(dt)
  
  
  function love.keypressed(key)
    
    if key == "space" then
      
      if player.state == "jumping" or player.state == "falling" then
        
      else
        
        player.vy = -1
        
        player.state = "jumping"
        
        timerjumping = player.jump
        
      end
      
    end
    
  end

  

  for a = 1, player.speed, 1 do
    
    
    
    checkcollisionfenetre()
    
    collisionmurs(player)
    
    physicplayer()
    
  end
  
  for a = 1, player.gravity, 1 do
    
    collisionhautbas(player)
    
    player.y = player.y + player.vy
    
    if timerjumping > 0 then
      timerjumping = timerjumping - 1
    end
    
    if player.state == "jumping" then
      if timerjumping == 0 then
        player.state = "falling"
      end
    end
    
  end
  
  
  
end

-------------------------------------------------------------------------------------------------



function love.draw()
  
  
  for a = 1, 10, 1 do
    for b = 1, 14, 1 do
      if tilemap1[a][b] == 1 then
        love.graphics.draw(img1, tile1, (b-1)*32, (a-1)*32)
      elseif tilemap1[a][b] == 2 then
        love.graphics.draw(img2, tile2, (b-1)*32, (a-1)*32)
      end
    end
  end

  love.graphics.draw(imgplayer, player.img, player.x, player.y)  -- dessin du joueur
  
  
end
-------------------------------------------------------------------------------------------------




-------------------------------------------------------------------------------------------------

  function hitbox(tilemap)
    
    for a = 1, 10, 1 do
      
      for b = 1, 14, 1 do
        
        if tilemap[a][b] == 1 then
          
          hitboxmap[#hitboxmap + 1] = {}
            
            hitboxmap[#hitboxmap].x = (b-1)*tilesize
            hitboxmap[#hitboxmap].y = (a-1)*tilesize
            hitboxmap[#hitboxmap].w = tilesize
            hitboxmap[#hitboxmap].h = tilesize
            hitboxmap[#hitboxmap].coll = false
          
        end
        
      end
      
    end
    
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
    end
    
    
    if player.y >= windowHeight - player.h then
      player.y = windowHeight - player.h
      if player.vy > 0 then
        player.vy = 0
      end
    end
   
    
    if player.x >= windowWidth - player.w then 
      player.x = windowWidth - player.w
    end
    
  end  -- fin de création de la fonction de collision des murs
  
  
  
  
  function resetcollisions()
    
    for a = 1, #hitboxmap, 1 do
      hitboxmap[a].coll = false
    end
    
  end
  
  
  
  
  function collisionmurs(player)
    
    --if player ~= nil then
      
      -- for player
        
          if love.keyboard.isDown("q") then
            
            local collisiongauche = false
            
            for a = 1, #hitboxmap, 1 do                            -- check de la collision avec chaque cube touche Z
              
              if player.y > hitboxmap[a].y - player.h and  -- test des 4 côtés
              player.y < hitboxmap[a].y + hitboxmap[a].h and
              player.x > hitboxmap[a].x - player.w and
              player.x <= hitboxmap[a].x + hitboxmap[a].w then
                hitboxmap[a].coll = true
              end
              
              if hitboxmap[a].coll == true then                 -- si collision alors position fixée
                player.x = hitboxmap[a].x + hitboxmap[a].w
                collisiongauche = true
              end
              
              
            end  -- fin du for des collisions touche Z
            
            if collisiongauche == false then
              player.x = player.x - 1  
            end
            
            resetcollisions() 
            
          end    
          
          
          
          if love.keyboard.isDown("d") then
            
            local collisiondroite = false
            
            for a = 1, #hitboxmap, 1 do                            -- check de la collision avec chaque cube touche Z
              
              if player.y > hitboxmap[a].y - player.h and  -- test des 4 côtés
              player.y < hitboxmap[a].y + hitboxmap[a].h and
              player.x >= hitboxmap[a].x - player.w and
              player.x < hitboxmap[a].x + hitboxmap[a].w then
                hitboxmap[a].coll = true
              end
              
              if hitboxmap[a].coll == true then                 -- si collision alors position fixée
                player.x = hitboxmap[a].x - player.w
                collisiondroite = true
              end
              
              
            end  -- fin du for des collisions touche Z
            
            if collisiondroite == false then
              player.x = player.x + 1  
            end
            
            resetcollisions() 
            
          end    
          
        --end
        
      --end
      
    --end
    
  end
  
  
  
  function physicplayer()
    
    if player.state == "falling" then
      
      player.vy = 1
      
    elseif player.state == "normal" then
      
      player.vy = 0
      
    elseif player.state == "jumping" then 
      
      timerjumping = timerjumping - 1
      
      if timerjumping == 0 then
        
        player.state = "falling"
        
      end
      
    end
    
  end
  
  
  
  
  function collisionhautbas(player)
    
    if player.vy < 0 then
      
      local collisionhaut = false
      
      for a = 1, #hitboxmap, 1 do                            -- check de la collision avec chaque cube touche Z
        
        if player.y > hitboxmap[a].y - player.h and  -- test des 4 côtés
        player.y <= hitboxmap[a].y + hitboxmap[a].h and
        player.x > hitboxmap[a].x - player.w and
        player.x < hitboxmap[a].x + hitboxmap[a].w then
          
          hitboxmap[a].coll = true
          
        end
        
        if hitboxmap[a].coll == true then                 -- si collision alors position fixée
          player.y = hitboxmap[a].y + hitboxmap[a].h
          collisionhaut = true
        end
        
        
      end  -- fin du for des collisions touche Z
      
      if collisionhaut == true then
        player.vy = 1
        player.state = "falling"
      end
      
      resetcollisions() 
      
    end
    
    
    if player.vy >= 0 then
      
      local collisionbas = false
      
      for a = 1, #hitboxmap, 1 do                            -- check de la collision avec chaque cube touche Z
        
        if player.y >= hitboxmap[a].y - player.h and  -- test des 4 côtés
        player.y < hitboxmap[a].y + hitboxmap[a].h and
        player.x > hitboxmap[a].x - player.w and
        player.x < hitboxmap[a].x + hitboxmap[a].w then
          hitboxmap[a].coll = true
        end
        
        if hitboxmap[a].coll == true then                 -- si collision alors position fixée
          player.y = hitboxmap[a].y - player.h
          collisionbas = true
        end
        
      end  -- fin du for des collisions touche Z
      
      if collisionbas == true then
        player.vy = 0
        player.state = "normal"
        
      elseif collisionbas == false then
        player.vy = 1
        player.state = "falling"
        
      end
      
      resetcollisions() 
      
    end
    
  end


--Permit Game Extinction


