#coding: utf-8
require 'bundler'
Bundler.require

require 'sdl'

class Reversi
	@@stoneState={'none'=>0,'white'=>1,'black'=>2}#マス目の状態を表す値を持つハッシュ
	@@boardGridNum=8#ボードの縦横のマス数
	@@stoneColor='black'#次に置く石の色

	def initialize(windowWidth,windowHeight,windowSpace,screen)
		@windowSpace=windowSpace
		@boardSize=windowWidth>windowHeight ? windowHeight-windowSpace*2 : windowWidth-windowSpace*2
		#マス目の状態格納用２次元配列(0:なし1:白2:黒)
		@gridState=Array.new(@@boardGridNum).map do
			Array.new(@@boardGridNum,0)
		end
		@screen=screen
		#初期石を配置	
		place=[[3,3,'white'],[3,4,'black'],[4,3,'black'],[4,4,'white']]
		place.each do |x,y,state|
			addStone(x,y,state)
		end
	end
	
	#盤面を描画
	# @return [nil] 戻り地なし
	def drawGrid()
		@gridSize=@boardSize/@@boardGridNum#1グリッドのサイズ
		@endPlace=@boardSize+@windowSpace#縦横の線描画する終点座標
		@lineColor=[0,0,255]#線の色

		#横ラインを描画	
		(@@boardGridNum+1).times do |i|
			y=@windowSpace+@gridSize*i
			@screen.draw_line(@windowSpace,y,@endPlace,y,@lineColor)
		end
		#縦ラインを描画
		(@@boardGridNum+1).times do |i|
			x=@windowSpace+@gridSize*i
			@screen.draw_line(x,@windowSpace,x,@endPlace,@lineColor)
		end
	end

	def drawStone()
		xy=[@windowSpace+@gridSize/2,@windowSpace+@gridSize/2]
		@color=[[0,255,255],[255,255,255],[0,0,0]]
		@@boardGridNum.times do |i|
			@@boardGridNum.times do |j|
				@screen.draw_circle(xy[0],xy[1],@gridSize/2-5,@color[@gridState[i][j]],true)
				xy[0]+=@gridSize;
			end
			xy[0]=@windowSpace+@gridSize/2
			xy[1]+=@gridSize
		end
	end

	#初期石を置く際に使用
	def addStone(x,y,state)
		if @gridState[y][x] != @@stoneState['none']
			return
		end
		@gridState[y][x]=@@stoneState[state]
	end

	#通常時石を置く際に使用
	def putStone(x,y)
		if @gridState[y][x] != @@stoneState['none']
			return
		end
		state=@@stoneColor
		reverseList=searchPlaceable(x,y,@@stoneState[state])
		if reverseList.length!=0	
			puts state
			@gridState[y][x]=@@stoneState[state]
			reverseList.each do |code|
				p code
				@gridState[code[1]][code[0]]=@@stoneState[@@stoneColor]
			end
			@@stoneColor= @@stoneColor=='black' ? 'white':'black'
		end
	end
	
	#石を置くことが可能かどうか
	def searchPlaceable(x,y,state)
		renge1=(x-1)..(x+1)
		renge2=(y-1)..(y+1)
		reverseList=Array.new#石がひっくり返るリスト
		puts 'x,y'
		renge1.each do |i|
			renge2.each do |j|
				stoneNum=getPlaceStone(i,j)
				if stoneNum==false 
					next 
				end
				puts 'i('+i.to_s+') j('+j.to_s+')='+stoneNum.to_s
				if state != stoneNum and stoneNum!=0
					tmpReverseList=Array.new
					tmpReverseList.push([i,j])
					diffX=i-x
					diffY=j-y
					searchX=x+diffX*2
					searchY=y+diffY*2
					puts 'x+diffX*2('+searchX.to_s+') y+diffY*2('+searchY.to_s+')='+getPlaceStone(searchX,searchY).to_s
					loop{
						getState=getPlaceStone(searchX,searchY)
						if getState==false 
							break
						end
						if getState==state
							puts'置ける'
							tmpReverseList.each do |item|
								reverseList.push(item)
							end
							break
						elsif getState!=@@stoneState['none']
							tmpReverseList.push([searchX,searchY])
							searchX+=diffX
							searchY+=diffY
						else
							break
						end
					}
				end
			end
		end
		return reverseList
	end

	def getPlaceStone(x,y)
		if y>=0 and x>=0 and x<@@boardGridNum and y<@@boardGridNum
			return @gridState[y][x]
		else
			return false
		end
	end

	attr_accessor :gridSize
end

