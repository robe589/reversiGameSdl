#coding: utf-8
require 'bundler'
Bundler.require

require 'sdl'
require 'pp'

class Reversi
	@@stoneState={'none'=>0,'white'=>1,'black'=>2}#マス目の状態を表す値を持つハッシュ
	
	attr_accessor :gridState,:stoneColor,:turnNum,:blackStoneNum,:whiteStoneNum
	
	#初期化処理
	def initialize()
		@boardGridNum=8#ボードの縦横のマス数
		#マス目の状態格納用２次元配列(0:なし1:白2:黒)
		@gridState=Array.new(@boardGridNum).map do
			Array.new(@boardGridNum,0)
		end
		#初期石を配置	
		place=[[3,3,'white'],[3,4,'black'],[4,3,'black'],[4,4,'white']]
		place.each do |x,y,state|
			addStone(x,y,state)
		end
		#ターン数を初期化
		@turnNum=1
		@stoneColor='black'#次に置く石の色
	end	

	#初期石を置く際に使用
	#@param x x座標
	#@param y y座標
	#@param state 黒石か白石か
	def addStone(x,y,stoneColor)
		if getPlaceStone(x,y) != @@stoneState['none']#すでに石が置かれている
			return false
		end
		@gridState[x][y]=@@stoneState[stoneColor]
	end

	#通常時石を置く際に使用
	def putStone(x,y)
		if getPlaceStone(x,y) != @@stoneState['none']#すでに石が置かれている
			return false
		end

		reverseList=searchPlaceable(x,y,@stoneColor)
		if reverseList.length!=0#盤上に置く場所があるとき	
			@gridState[x][y]=@@stoneState[@stoneColor]
			puts 'reverseList='+ reverseList.to_s
			reverseList.reverse_each do |code|
				p code
				@gridState[code[0]][code[1]]=@@stoneState[@stoneColor]
			end
			@stoneColor= @stoneColor=='black' ? 'white':'black'
			@turnNum+=1
		end
	end
	
	def showPutStone()
		putStonePlaceList=Array.new
		
		#置ける場所のリストを作成
		@boardGridNum.times do |i|
			@boardGridNum.times do |j|
				if getPlaceStone(i,j)!=@@stoneState['none']
				   next
				end
				reverseList=searchPlaceable(i,j,@stoneColor)
				if reverseList.length !=0
					putStonePlaceList.push([i,j])
				end
			end
		end
		return putStonePlaceList	
	end
	
	#石を置くことが可能かどうか
	#@param x x座標
	#@param y y座標
	#@param stoneColor [String] 置く石の色
	def searchPlaceable(x,y,stoneColor)
		state=@@stoneState[stoneColor]
		renge1=(x-1)..(x+1)
		renge2=(y-1)..(y+1)
		reverseList=Array.new#石がひっくり返るリスト
		
		puts 'x,y'
		renge1.each do |i|
			renge2.each do |j|
				stoneNum=getPlaceStone(i,j)
				if stoneNum==false#座標範囲外の時
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
						if getState==false#座標が範囲外の時 
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

	#指定したマス目の状態を取得
	#@param x x座標
	#@param y y座標
	def getPlaceStone(x,y)
		if y>=0 and x>=0 and x<@boardGridNum and y<@boardGridNum
			return @gridState[x][y]
		else
			return false
		end
	end	
	
	#黒白それぞれの石の数を数える
	def countStone()
		@blackStoneNum=@whiteStoneNum=0

		@gridState.each do |state|
			@blackStoneNum+=state.count(@@stoneState['black'])
			@whiteStoneNum+=state.count(@@stoneState['white'])
		end
	end
end

