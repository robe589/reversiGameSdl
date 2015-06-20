#coding: utf-8
require 'bundler'
Bundler.require

require 'sdl'

def main()
	windowWidth=500
	windowHeight=420
	windowName='オセロ'#メインウィンドウの表示名
	windowSpace=10#メインウィンドウの余白
	boardGridNum=8#ボードの縦横のマス数
	gridState=Array.new(boardGridNum) do Array.new(boardGridNum,0) end#マス目の状態格納用２次元配列(0:なし1:白2:黒)
	stoneState={'none'=>0,'white'=>1,'black'=>2}#マス目の状態を表す値を持つハッシュ
	initStonePlace=[[3,3,'white'],[3,4,'black'],[4,3,'black'],[4,4,'white']]

	SDL.init(SDL::INIT_VIDEO)
	screen = SDL::Screen.open(windowWidth,windowHeight, 16, SDL::SWSURFACE)
	SDL::WM::set_caption(windowName,'testsprite.rb icon')

	#背景色を赤で塗りつぶし
	screen.fill_rect(0,0,windowWidth,windowHeight,[0,255,255])
	#ウィンドウサイズで縦横のどちらか短い方を盤面の縦横サイズに
	boardSize=windowWidth>windowHeight ? windowHeight-windowSpace*2 : windowWidth-windowSpace*2
	#盤面を描画
	gridSize=drawGrid(windowSpace,boardGridNum,boardSize,screen)
	#初期石を配置	
	gridState[3][3]=stoneState['white']
	gridState[3][4]=stoneState['black']
	gridState[4][3]=stoneState['black']
	gridState[4][4]=stoneState['white']

	loop do
	  while event = SDL::Event.poll
		case event
		when SDL::Event::Quit
		  exit
		when SDL::Event::MouseButtonUp
			x,y,* =SDL::Mouse.state
			puts "x("+x.to_s+')'+' y('+y.to_s+')'
			x-=windowSpace
			y-=windowSpace
			gridState[y/gridSize][x/gridSize]=stoneState['black']
		end
		drawStone(gridState,gridSize,windowSpace,boardGridNum,screen)
	  end
	  screen.update_rect(0, 0, 0, 0)
	end
end

#盤面を描画
# @param [int] space ウィンドウの余白サイズ
# @param [int] gridNum 縦横のグリッド数
# @param [int] boardSize 縦横のボードの長さ
# @param [SDL::Screen] screen 
# @return [nil] 戻り地なし
def drawGrid(space,gridNum,boardSize,screen)
	gridSize=boardSize/gridNum#1グリッドのサイズ
	endPlace=boardSize+space#縦横の線描画する終点座標
	lineColor=[0,0,255]#線の色

	#横ラインを描画	
	(gridNum+1).times do |i|
		y=space+gridSize*i
		screen.draw_line(space,y,endPlace,y,lineColor)
	end
	#縦ラインを描画
	(gridNum+1).times do |i|
		x=space+gridSize*i
		screen.draw_line(x,space,x,endPlace,lineColor)
	end
	
	return gridSize
end

def drawStone(gridState,gridSize,space,gridNum,screen)
	initxy=[space+gridSize/2,space+gridSize/2]
	color=[[0,255,255],[255,255,255],[0,0,0]]
	gridNum.times do |i|
		gridNum.times do |j|
			screen.draw_circle(initxy[0],initxy[1],gridSize/2-5,color[gridState[i][j]],true)
			initxy[0]+=gridSize;
		end
		initxy[0]=space+gridSize/2
		initxy[1]+=gridSize
	end
end

main()
