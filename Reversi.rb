#coding: utf-8
require 'bundler'
Bundler.require

require 'sdl'
require 'pp'

class Reversi
	@@stoneState={'none'=>0,'white'=>1,'black'=>2}#マス目の状態を表す値を持つハッシュ
	
	#初期化処理
	# @param windowWidth 画面の幅
	# @param windowHeight 画面の高さ
	# @param windowSpace 画面左上からの盤面までの上下左右の空白
	# @param screen 画面グラフィック表示用
	# @param backColor ウィンドウ背景色
	def initialize(windowWidth,windowHeight,windowSpace,screen,backColor)
		@boardGridNum=8#ボードの縦横のマス数
		@windowSpace=windowSpace
		@boardSize=windowWidth>windowHeight ? windowHeight-windowSpace*2 : windowWidth-windowSpace*2
		#マス目の状態格納用２次元配列(0:なし1:白2:黒)
		@gridState=Array.new(@boardGridNum).map do
			Array.new(@boardGridNum,0)
		end
		@screen=screen
		@backColor=backColor
		#初期石を配置	
		place=[[3,3,'white'],[3,4,'black'],[4,3,'black'],[4,4,'white']]
		place.each do |x,y,state|
			addStone(x,y,state)
		end
		#ターン数を初期化
		@turnNum=1
		@stoneColor='black'#次に置く石の色
	end
	
	#盤面を描画
	# @return [nil] 戻り地なし
	def drawGrid()
		@gridSize=@boardSize/@boardGridNum#1グリッドのサイズ
		@endPlace=@boardSize+@windowSpace#縦横の線描画する終点座標
		@lineColor=[0,0,255]#線の色

		#横ラインを描画	
		(@boardGridNum+1).times do |i|
			y=@windowSpace+@gridSize*i
			@screen.draw_line(@windowSpace,y,@endPlace,y,@lineColor)
		end
		#縦ラインを描画
		(@boardGridNum+1).times do |i|
			x=@windowSpace+@gridSize*i
			@screen.draw_line(x,@windowSpace,x,@endPlace,@lineColor)
		end
	end

	#盤面上に石を描画
	def drawStone()
		point={'x'=>@windowSpace+@gridSize/2,'y'=>@windowSpace+@gridSize/2}
		@color=[[0,255,255],[255,255,255],[0,0,0]]
		
		@boardGridNum.times do |i|
			@boardGridNum.times do |j|
				color=@color[getPlaceStone(i,j)]
				@screen.draw_circle(point['x'],point['y'],@gridSize/2-5,color,true)
				point['x']+=@gridSize;
			end
			point['x']=@windowSpace+@gridSize/2
			point['y']+=@gridSize
		end
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
				drawStone()
				@screen.update_rect(0,0,0,0)
				SDL.delay(300)
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
		pp putStonePlaceList
		
		rectSpace=2
		#リストに基づけ画面に描画
		point={'x'=>@windowSpace+rectSpace,'y'=>@windowSpace+rectSpace}
		color=[255,0,0]
		@boardGridNum.times do |i|
			@boardGridNum.times do |j|
				isPut=false
				putStonePlaceList.each do |x,y|
					pp [x,y]
					if x==i and y==j
						isPut=true
					end
				end
				width=@gridSize-rectSpace*2
				height=@gridSize-rectSpace*2
				x=point['x']
				y=point['y']
				if isPut==true 
					@screen.draw_rect(x,y,width,height,color,false)
				else
					@screen.draw_rect(x,y,width,height,@color[0],false)
				end
				point['x']+=@gridSize;
			end
			point['x']=@windowSpace+rectSpace
			point['y']+=@gridSize
		end
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
		if y>=0 and x>=0 and x<@boardGridNum and y<@boardGridNum
			return @gridState[x][y]
		else
			return false
		end
	end

	#画面にメッセージを描画
	def showText()
		font=SDL::TTF.open('font/msgothic.ttc',24)
		#フォントの高さを取得
		fontHeight=font.height+1
		showStr=[@stoneColor+'の番です',
			 @turnNum.to_s+'ターン目です',
			 '黒:'+"%2d" % @blackStoneNum.to_s+'白:'+"%2d" % @whiteStoneNum.to_s
			]
		startX=500
		startY=0
		fontColor=[0,0,0]
		showStr.each do |str|
			font.draw_shaded_utf8(@screen,str,startX,startY,*fontColor,*@backColor)
			startY+=fontHeight
		end

		font.close
	end
	
	#黒白それぞれの石の数を数える
	def countStone()
		@blackStoneNum=@whiteStoneNum=0

		@gridState.each do |state|
			state.each do |state2|
				if state2==@@stoneState['black']
					@blackStoneNum+=1
				elsif state2==@@stoneState['white']
					@whiteStoneNum+=1
				end
			end
		end
	end

	attr_accessor :gridSize
end

