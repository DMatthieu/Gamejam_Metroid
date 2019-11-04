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

  tilemap1[1]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  tilemap1[2]  = {0,0,0,0,0,0,0,0,0,2,0,0,0,0}
  tilemap1[3]  = {0,2,2,0,2,0,0,0,0,0,0,0,0,0}
  tilemap1[4]  = {0,2,2,2,0,0,0,1,1,1,1,1,0,0}
  tilemap1[5]  = {0,0,1,2,0,0,0,0,0,0,0,0,0,0}
  tilemap1[6]  = {1,1,1,1,1,1,0,0,0,0,0,0,0,0}
  tilemap1[7]  = {0,0,0,0,1,0,1,0,0,2,0,2,0,0}
  tilemap1[8]  = {0,0,0,0,0,1,1,1,1,0,0,0,0,0}
  tilemap1[9]  = {0,0,0,0,0,0,0,0,0,1,1,1,0,0}
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
    player.friction = 300
    player.accel = 100
    player.maxspeed = 3
    player.gravity = 20
    player.jump = 400
    player.state = "falling"

    timerjumping = 0

  if love.keyboard.isDown("escape") then  -- Création de la fonction pour quitter le jeu
    love.event.quit()
  end
  
end

-------------------------------------------------------------------------------------------------




function love.update(dt)
  
  
  function love.keypressed(key)
    
    if key == "space" then  -- pour le saut
      
      if player.state ~= "jumping" and player.state ~= "falling" then -- si personnage n'est pas déja en l'air
        
        player.vy = player.vy - player.jump*dt  -- alors application d'une force de saut donnée
        
        player.state = "jumping"
        
      end
      
    end
    
  end

  
  -- début de la gestion de la physique du joueur
  
    -- physique horizontale
  
  move(dt, player)    -- fonction de déplacement avec friction en cas d'arrêt hors saut
  
  checkcollisionfenetre()  -- premier check de collision du bord de la fenêtre
  
  collisionmurs(player)   -- premier check de collision avec les murs

  if vx ~= 0 then
    
    for a = 1, math.abs(player.vx), 1 do       -- pour chaque pixel de déplacement en fonction de la vitesse du joueur
      
      checkcollisionfenetre()           -- je vérifie la collision avec le bord de la fenêtre
      
      collisionmurs(player)             -- je vérifie la collision avec les murs formés par ma hitboxmap
      
      if player.vx > 0 then                                       -- en fonction de mon vx je déplace le joueur : 
        
        player.x = player.x + 1                                         -- vers la droite
        
      elseif player.vx < 0 then
        
        player.x = player.x - 1                                         -- vers la gauche
        
      elseif player.vx == 0 then
        
        break                                                           -- si pas de déplacement à faire (collision) : fin prématurée de la boucle de déplacement 
        
      end
      
    end
    
  end
  
  
    -- physique verticale
  
  if player.state == "falling" or player.state == "jumping" then
    
    player.vy = player.vy + player.gravity*dt  -- si le joueur saute ou tombe on lui applique une gravité
    
    if player.state == "jumping" and player.vy > 0 then
      
      player.state = "falling"
      
    end
    
  end
  
  
  collisionhautbas(player)   -- premier test de détermination de l'état du joueur
  
  physicplayer()             -- attribution d'un vy en fonction de l'état (voir fonction)
  
  if player.vy ~= 0 then     -- si mon joueur est en déplacement vertical alors boucle de déplacement
    
    for a = 1, math.abs(player.vy), 1 do   -- j'effectue un déplacement pixel par pixel égal à ma vitesse de déplacement verticale (vy)
      
      checkcollisionfenetre()              -- Pour chaque pixel : -- je vérifie les bords de la fenêtre
      
      collisionhautbas(player)                                    -- je vérifie les collisions avec les hitbox qui modifient l'état du joueur si besoin (voir fonction)
      
      physicplayer()                                              -- j'annule la gravité si nécessaire
      
      if player.vy > 0 then                                       -- en fonction de mon vy je déplace le joueur : 
        
        player.y = player.y + 1                                         -- vers le bas
        
      elseif player.vy < 0 then
        
        player.y = player.y - 1                                         -- vers le haut
        
      elseif player.vy == 0 then
        
        break                                                           -- si pas de déplacement à faire (collision bas) : fin prématurée de la boucle de déplacement 
        
      end
      
    end
    
  end
  
  -- fin de la gestion de la physique joueur
  
end

-------------------------------------------------------------------------------------------------



function love.draw()
  
  
  for a = 1, 10, 1 do      -- dessin des tiles
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
-- LISTE DES FONCTIONS UTILISEES


  function hitbox(tilemap)
    
    for a = 1, 10, 1 do
      
      for b = 1, 14, 1 do
        
        if tilemap[a][b] ~= 0 then
          
          hitboxmap[#hitboxmap + 1] = {}
            
            hitboxmap[#hitboxmap].x = (b-1)*tilesize
            hitboxmap[#hitboxmap].y = (a-1)*tilesize
            hitboxmap[#hitboxmap].w = tilesize
            hitboxmap[#hitboxmap].h = tilesize
            hitboxmap[#hitboxmap].coll = false
            hitboxmap[#hitboxmap].state = tilemap[a][b]
          
        end
        
      end
      
    end
    
  end
  
  
  
  function checkcollisionfenetre()   -- Création de la fonction de collision bord de la fenêtre
    
    if player.y <= 0 then
      player.y = 0
      if player.vy < 0 then
        player.vy = 0
        player.state = "falling"
      end
    end
   
    
    if player.x <= 0 then
      player.x = 0
    end
    
    
    if player.y >= windowHeight - player.h then
      player.y = windowHeight - player.h
      if player.vy > 0 then
        player.vy = 0
        player.state = "normal"
      end
    end
   
    
    if player.x >= windowWidth - player.w then 
      player.x = windowWidth - player.w
    end
    
  end  -- fin de création de la fonction de collision bord de la fenêtre
  
  
  
  function move(dt, player) 
    
    if player.state == "normal" then
        
      if love.keyboard.isDown("q") then
        
        player.vx = player.vx - player.accel*dt
        
        if math.abs(player.vx) >= player.maxspeed then
          
          player.vx = - player.maxspeed
          
        end
        
      elseif love.keyboard.isDown("d") then
        
        player.vx = player.vx + player.accel*dt
        
        if math.abs(player.vx) >= player.maxspeed then
          
          player.vx = player.maxspeed
          
        end
        
      else
        
        if player.vx < 0 then
          
          player.vx = player.vx + player.friction*dt
          
          if player.vx > 0 then
            
            player.vx = 0
            
          end
          
        elseif player.vx > 0 then
          
          player.vx = player.vx - player.friction * dt
          
          if player.vx < 0 then
            
            player.vx = 0
            
          end
          
        end
        
      end
      
    end
    
  end
  
  
  
  function resetcollisions()
    
    for a = 1, #hitboxmap, 1 do
      hitboxmap[a].coll = false
    end
    
  end
  
  
  
  
  function collisionmurs(player)  -- test collision gauche et droite du joueur
    
          if love.keyboard.isDown("q") then -- gauche
            
            local collisiongauche = false
            
            for a = 1, #hitboxmap, 1 do
              
              if hitboxmap[a].state == 1 then
              
              if player.y > hitboxmap[a].y - player.h and
              player.y < hitboxmap[a].y + hitboxmap[a].h and
              player.x > hitboxmap[a].x - player.w and
              player.x <= hitboxmap[a].x + hitboxmap[a].w then
                hitboxmap[a].coll = true
              end
              
              if hitboxmap[a].coll == true then
                player.x = hitboxmap[a].x + hitboxmap[a].w
                collisiongauche = true
              end
              
              end
              
            end
            
            if collisiongauche == false then
              
            else             ------------------------------- EFFET CLIMBING A AJOUTER
              
              player.vx = 0
              
            end
            
            resetcollisions() 
            
          end    
          
          
          
          if love.keyboard.isDown("d") then  -- droite
            
            local collisiondroite = false
            
            for a = 1, #hitboxmap, 1 do
              
              if hitboxmap[a].state == 1 then
              
              if player.y > hitboxmap[a].y - player.h and
              player.y < hitboxmap[a].y + hitboxmap[a].h and
              player.x >= hitboxmap[a].x - player.w and
              player.x < hitboxmap[a].x + hitboxmap[a].w then
                hitboxmap[a].coll = true
              end
              
              if hitboxmap[a].coll == true then
                player.x = hitboxmap[a].x - player.w
                collisiondroite = true
              end
              
              end
              
            end
            
            if collisiondroite == false then
              
            else             ------------------------------- EFFET CLIMBING A AJOUTER
              
              player.vx = 0
              
            end
            
            resetcollisions() 
            
          end    
         
  end              -- fin du test collision gauche droite
  
  
  
  function physicplayer()
    
    if player.state == "normal" or player.state == "climbing" then
      
      player.vy = 0
      
    end
    
  end
  
  
  
  
  function collisionhautbas(player)  -- test de collision haut ou bas du joueur
    
    if player.vy < 0 then                   -- haut
      
      local collisionhaut = false
      
      for a = 1, #hitboxmap, 1 do
        
        if hitboxmap[a].state == 1 then
        
        if player.y > hitboxmap[a].y - player.h and
        player.y <= hitboxmap[a].y + hitboxmap[a].h and
        player.x > hitboxmap[a].x - player.w and
        player.x < hitboxmap[a].x + hitboxmap[a].w then
          
          hitboxmap[a].coll = true
          
        end
        
        if hitboxmap[a].coll == true then
          player.y = hitboxmap[a].y + hitboxmap[a].h
          collisionhaut = true
        end
        
        end
        
      end
      
      if collisionhaut == true then
        player.vy = 0
        player.state = "falling"
      end
      
      resetcollisions() 
      
    end
    
    
    if player.vy >= 0 then                   -- bas
      
      local collisionbas = false
      
      for a = 1, #hitboxmap, 1 do
        
        if hitboxmap[a].state == 1 then
        
        if player.y >= hitboxmap[a].y - player.h and
        player.y < hitboxmap[a].y + hitboxmap[a].h and
        player.x > hitboxmap[a].x - player.w and
        player.x < hitboxmap[a].x + hitboxmap[a].w then
          hitboxmap[a].coll = true
        end
        
        if hitboxmap[a].coll == true then
          player.y = hitboxmap[a].y - player.h
          collisionbas = true
        end
        
        elseif hitboxmap[a].state == 2 then
        
        if player.y == hitboxmap[a].y - player.h then
          
          if player.y >= hitboxmap[a].y - player.h and
        player.y < hitboxmap[a].y + hitboxmap[a].h and
        player.x > hitboxmap[a].x - player.w and
        player.x < hitboxmap[a].x + hitboxmap[a].w then
          hitboxmap[a].coll = true
        end
        
        if hitboxmap[a].coll == true then
          player.y = hitboxmap[a].y - player.h
          collisionbas = true
        end
          
        end
        
        end
        
      end
      
      if collisionbas == true then
        
        player.state = "normal"
        
      elseif collisionbas == false then
        
        player.state = "falling"
        
      end
      
      resetcollisions() 
      
    end
    
  end                   -- fin du test collision haut et bas 

