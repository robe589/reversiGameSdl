#coding: utf-8
require 'bundler'
Bundler.require

require 'sdl'

class Reversi
	@@stoneState={'none'=>0,'white'=>1,'black'=>2}#マス目の状態を表す値を持つハッシュ
	
	def initialize(windowWidth,windowHeight,windowSpace,boardGridNum,screen)
		@windowSpace=windowSpace
		@boardSize=windowWidth>windowHeight ? windowHeight-windowSpace*2 : windowWidth-windowSpace*2
		@boardGridNum=boardGridNum
		#マス目の状態格納用２次元配列(0:なし1:白2:黒)
		@gridState=Array.new(boardGridNum) do
			Array.new(boardGridNum,0)
		end
		@screen=screen
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

	def drawStone()
		xy=[@windowSpace+@gridSize/2,@windowSpace+@gridSize/2]
		@color=[[0,255,255],[255,255,255],[0,0,0]]
		@boardGridNum.times do |i|
			@boardGridNum.times do |j|
				@screen.draw_circle(xy[0],xy[1],@gridSize/2-5,@color[@gridState[i][j]],true)
				xy[0]+=@gridSize;
			end
			xy[0]=@windowSpace+@gridSize/2
			xy[1]+=@gridSize
		end
	end
	
	def addStone(x,y,state)
		p state
		@gridState[y][x]=@@stoneState[state]
	end
	
	def getBoardGridSize()
		return @gridSize
	end
end

