#coding: utf-8
require 'bundler'
Bundler.require

require 'sdl'

require './Reversi'

def main()
	windowWidth=500
	windowHeight=420
	windowName='オセロ'#メインウィンドウの表示名
	windowSpace=10#メインウィンドウの余白
	boardGridNum=8#ボードの縦横のマス数
	SDL.init(SDL::INIT_VIDEO)
	screen = SDL::Screen.open(windowWidth,windowHeight, 16, SDL::SWSURFACE)
	SDL::WM::set_caption(windowName,'testsprite.rb icon')

	#背景色を赤で塗りつぶし
	screen.fill_rect(0,0,windowWidth,windowHeight,[0,255,255])
	
	reversi=Reversi.new(windowWidth,windowHeight,windowSpace,boardGridNum,screen)
	#盤面を描画
	reversi.drawGrid()
	#初期石を配置	
	reversi.addStone(3,3,'white')
	reversi.addStone(3,4,'black')
	reversi.addStone(4,3,'black')
	reversi.addStone(4,4,'white')

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
			gridSize=reversi.gridSize
			reversi.addStone(x/gridSize,y/gridSize,'black')
		end
		reversi.drawStone()
	  end
	  screen.update_rect(0, 0, 0, 0)
	end
end

main()
