function rnd_ascii(x,y)
	local ascii="QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm"
	local num=flr(rnd(#ascii))
	print(sub(ascii,num,num),x,y,8)
	--AAAA	<-size of tile in char
	--AAAA
end

function move_player()
    local plyr_moved=0
	if (btnp(0)) and plyr.x>1
        then
        if map_tbl[plyr.x-1][plyr.y]==floor.seen
            then
            plyr.x -= plyr.spd
            plyr_moved=1
        end
    end
	if (btnp(1)) and plyr.x<#map_tbl
        then 
        if map_tbl[plyr.x+1][plyr.y]==floor.seen
            then
            plyr.x += plyr.spd
            plyr_moved=1
        end
    end
	if (btnp(2)) and plyr.y>1
        then
        if map_tbl[plyr.x][plyr.y-1]==floor.seen
            then
            plyr.y -= plyr.spd
            plyr_moved=1
        end
    end
	if (btnp(3)) and plyr.y<#map_tbl[1]
        then
        if map_tbl[plyr.x][plyr.y+1]==floor.seen
            then
            plyr.y += plyr.spd
            plyr_moved=1
        end
    end
    --if (btnp(4))
    ---------------------------------------------------------------
    if plyr_moved==1
        then
        for i=1,#map_tbl do
            for j=1,#map_tbl[1] do
                if map_tbl[i][j]==floor.partial or map_tbl[i][j]==floor.seen
                    then
                    map_tbl[i][j]=floor.unseen      --hide everything
                end
            end
        end
        --local partial={{}}
        for i=-2,2 do
            for j=-2,2 do       --show only what i close to the player
                if plyr.x+i>=1 and plyr.y+j>=1 and plyr.x+i<=#map_tbl and plyr.y+j<=#map_tbl
                    then
                    if map_tbl[plyr.x+i][plyr.y+j]==floor.unseen and i*j==0 or map_tbl[plyr.x+i][plyr.y+j]==floor.unseen and abs(i*j)==1
                        then
                        map_tbl[plyr.x+i][plyr.y+j]=floor.seen
                    end
                    if map_tbl[plyr.x+i][plyr.y+j]==floor.unseen and abs(i*j)==2 or map_tbl[plyr.x+i][plyr.y+j]==floor.unseen and abs(i*j)==4
                        then
                        map_tbl[plyr.x+i][plyr.y+j]=floor.partial
                    end
                    if map_tbl[plyr.x+i][plyr.y+j]==0
                        then
                        map_tbl[plyr.x+i][plyr.y+j]=wall.solid
                    end
                    if plyr.x+i==exit.x and plyr.y+j==exit.y then exit.visible=1 end    --make the exit always visible after being seen
                end
            end
        end
        for i=1,#map_tbl do
            for j=1,#map_tbl[1] do
                mset(i-1,j-1,map_tbl[i][j])
            end
        end
    end
end

function _init()
    plyr_spr={9,10}
    plyr={s=9,hp=10,x=-1,y=-1,spd=1,tmr=0}	--tmr 0,30
    --sprites
	floor={seen=1,partial=2,unseen=3}
    wall={solid=12}
    exit={s=18,x=-1,y=-1,visible=0}       --Hidden until the player finds it and after that it is always visible.
    -------
	size={max_x=30,max_y=15,min_x=1,min_y=1}		--1-30,1-17
	spot={x=0,y=0}
	spot.x=flr(rnd(size.max_x))+1   --+1 because flr(rnd(num)) is 0 to num-1
	spot.y=flr(rnd(size.max_y))+1
	coverage={goal=0.5*size.max_x*size.max_y,current=0}		--from 1.0 to 0.0
	d_change=0.7
	map_tbl={}
	for i=1,size.max_x do     
		map_tbl[i]={}
		for j=1,size.max_y do
			map_tbl[i][j]=0
		end
	end
    --mobs
    mob_types={
        --unknown (1)
        {hp=1,spd=1,r=4,a=0,e_type=1,s=unpod("b64:bHo0AEUAAABRAAAA8A1weHUAQyAQEARATAVwHEUcBUAMhQwFIAylDAUQBQBbAAzFDAUEAGEVDKUcBQAjAPADBQyFHAUgBRxFLAVAFVwVcFVA")},
    }
    mob={s={},x={},y={},hp={},a={},e_type={}}
    --
	gen_map()
end

function gen_map()
	local d=flr(rnd(4))	--0,3 udlr
	while coverage.goal > coverage.current do
		if d==2 and spot.x>size.min_x then spot.x=spot.x-1 end
		if d==3 and spot.x<size.max_x then spot.x=spot.x+1 end
		if d==0 and spot.y>size.min_y then spot.y=spot.y-1 end
		if d==1 and spot.y<size.max_y then spot.y=spot.y+1 end
        if spot.x>=size.min_x and spot.y>=size.min_y and spot.x<=size.max_x and spot.y<=size.max_y
            then
            if map_tbl[spot.x][spot.y]==0	--checks if the pixel is blank
                then		--if not,  then count it.
                coverage.current=coverage.current+1 
                map_tbl[spot.x][spot.y]=floor.seen		--put an orange pixel here
            end
        end
		if math.random()<d_change
			then
			d=flr(rnd(4))	--pick a random direction for next loop
		end
	end
    --map_tbl[#map_tbl][#map_tbl[1]]=2
	--place player
    local x=flr(rnd(#map_tbl)-1)+2; y=flr(rnd(#map_tbl[1])-1)+2     --flr(rnd(num)-1)+2 is 1 to num
    while plyr.x==-1 do
        x=flr(rnd(#map_tbl)-1)+2
        y=flr(rnd(#map_tbl[1])-1)+2
        if map_tbl[x][y]==floor.seen
            then
            --map_tbl[x][y]=17
            plyr.x=x
            plyr.y=y
        end
    end
    --place exit
    x=flr(rnd(#map_tbl)-1)+2; y=flr(rnd(#map_tbl[1])-1)+2
    while exit.x==-1 do
        x=flr(rnd(#map_tbl)-1)+2
        y=flr(rnd(#map_tbl[1])-1)+2
        if map_tbl[x][y]==floor.seen
            then
            --map_tbl[x][y]=17
            exit.x=x
            exit.y=y
        end
    end
    --set map with mset
    for i=1,#map_tbl do
		for j=1,#map_tbl[1] do
			mset(i-1,j-1,map_tbl[i][j])
		end
	end
end

function _draw()
	cls()
	map(0, 0)		--29,16
	
	print(plyr.x,16,16,9)
    print(plyr.y,16,2*16,9)
	if plyr.tmr<60 then plyr.tmr+=1 end
	if plyr.tmr==60 then plyr.tmr=0 end
	--if plyr.tmr<=30 then spr(plyr.s,(plyr.x*16)-16,(plyr.y*16)-16) end      --(plyr.y*16)-16
	--if plyr.tmr>30 then spr(plyr.s+1,(plyr.x*16)-16,(plyr.y*16)-16) end
    if exit.visible==1 then spr(exit.s,(exit.x*16)-16,(exit.y*16)-16) end       --draws exit
    spr(plyr.s,(plyr.x*16)-16,(plyr.y*16)-16)
    --rnd_ascii((plyr.x*16)-16,(plyr.y*16)-16)
    
end

function _update()
	move_player()
end
