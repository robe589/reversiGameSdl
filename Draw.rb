#coding: utf-8
require 'bundler'
Bundler.require

require 'sdl'

#描画に関する処理を行うクラス
class Draw
	@@stoneState={'none'=>0,'white'=>1,'black'=>2}#マス目の状態を表す値を持つハッシュ
	attr_accessor :gridSize 
	#初期化処理
	# @param windowWidth 画面の幅
	# @param windowHeight 画面の高さ
	# @param windowSpace 画面左上からの盤面までの上下左右の空白
	# @param screen 画面グラフィック表示用
	# @param backColor ウィンドウ背景色
	def initialize(windowWidth,windowHeight,windowSpace,screen,backColor,gridState)
		@windowSpace=windowSpace
		@boardGridNum=8#ボードの縦横のマス数
		@boardSize=windowWidth>windowHeight ? windowHeight-windowSpace*2 : windowWidth-windowSpace*2
		@screen=screen
		@backColor=backColor
		@gridState=gridState
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
			@screen.draw_line(x,@windowSpace,x,@endPlace,@lineColor)		end
	end
	
	#盤面上に石を描画
	def drawStone()
		point={'x'=>@windowSpace+@gridSize/2,'y'=>@windowSpace+@gridSize/2}
		@color=[[0,255,255],[255,255,255],[0,0,0]]
		
		@boardGridNum.times do |i|
			@boardGridNum.times do |j|
				color=@color[@gridState[i][j]]
				@screen.draw_circle(point['x'],point['y'],@gridSize/2-5,color,true)
				point['x']+=@gridSize;
			end
			point['x']=@windowSpace+@gridSize/2
			point['y']+=@gridSize
		end
	end

	def availablePutStone(putStonePlaceList)
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

	#画面にメッセージを描画
	def showText(stoneColor,turnNum,blackStoneNum,whiteStoneNum)
		font=SDL::TTF.open('font/msgothic.ttc',24)
		#フォントの高さを取得
		fontHeight=font.height+1
		#表示する文字列
		showStr=[stoneColor+'の番です',
			 turnNum.to_s+'ターン目です',
			 '黒:'+"%2d" % blackStoneNum.to_s+'白:'+"%2d" % whiteStoneNum.to_s
			]
		#開始座標
		startX=500
		startY=0
		fontColor=[0,0,0]
		showStr.each do |str|
			font.draw_shaded_utf8(@screen,str,startX,startY,*fontColor,*@backColor)
			startY+=fontHeight
		end

		font.close
	end
end
