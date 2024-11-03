function rnd_ascii(x,y)
	local ascii="QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm"
	local num=flr(rnd(#ascii))
	print(sub(ascii,num,num),x,y,8)
	--AAAA	<-size of tile in char
	--AAAA
end

function move_player()
	if (btnp(0)) then plyr.x -= plyr.spd end
	if (btnp(1)) then plyr.x += plyr.spd end
	if (btnp(2)) then plyr.y -= plyr.spd end
	if (btnp(3)) then plyr.y += plyr.spd end
end

function _init()
    plyr={s=9,x=-1,y=-1,spd=16,tmr=0}	--tmr 0,30

	floor=1
	size={max_x=30,max_y=17,min_x=1,min_y=1}		--1-30,1-17
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
                map_tbl[spot.x][spot.y]=floor		--put an orange pixel here
            end
        end
		if math.random()<d_change
			then
			d=flr(rnd(4))	--pick a random direction for next loop
		end
	end
    map_tbl[#map_tbl][#map_tbl[1]]=2
	--place player
    local x=flr(rnd(#map_tbl)-1)+2; y=flr(rnd(#map_tbl[1])-1)+2     --flr(rnd(num)-1)+2 is 1 to num
    while plyr.x==-1 do
        x=flr(rnd(#map_tbl)-1)+2
        y=flr(rnd(#map_tbl[1])-1)+2
        if map_tbl[x][y]==floor
            then
            --map_tbl[x][y]=17
            plyr.x=(x*16)-16
            plyr.y=(y*16)-16
        end
    end
    for i=1,#map_tbl do
		for j=1,#map_tbl[1] do
			mset(i-1,j-1,map_tbl[i][j])
		end
	end
end

function _draw()
	cls()
	map(0, 0)		--29,16
	

	print(testx,16,16)
    print(testy,16,2*16)
	if plyr.tmr<60 then plyr.tmr+=1 end
	if plyr.tmr==60 then plyr.tmr=0 end
	if plyr.tmr<=30 then spr(plyr.s,plyr.x,plyr.y) end
	if plyr.tmr>30 then spr(plyr.s+1,plyr.x,plyr.y) end
end

function _update()
	move_player()
end
