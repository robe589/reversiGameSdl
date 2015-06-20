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

	SDL.init(SDL::INIT_VIDEO)
	screen = SDL::Screen.open(windowWidth,windowHeight, 16, SDL::SWSURFACE)

	SDL::WM::set_caption(windowName,'testsprite.rb icon')

	#ウィンドウサイズで縦横のどちらか短い方を盤面の縦横サイズに
	boardSize=windowWidth>windowHeight ? windowHeight-windowSpace*2 : windowWidth-windowSpace*2
	#盤面を描画
	drawGrid(windowSpace,boardGridNum,boardSize,screen)
	
	loop do
	  while event = SDL::Event.poll
		case event
		when SDL::Event::Quit
		  exit
		end
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
end

main()
