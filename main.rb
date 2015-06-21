#coding: utf-8
require 'bundler'
Bundler.require

require 'sdl'

require './Reversi'
require './Window'

def main()
	windowSpace=10#メインウィンドウの余白
	backColor=[0,255,255]#メインウィンドウの背景色
	
	window=Window.new(backColor)
	reversi=Reversi.new(window.width,window.height,windowSpace,window.screen)
	#盤面を描画
	reversi.drawGrid()
	
	sdlLoop(windowSpace,reversi,window)
end

def sdlLoop(windowSpace,reversi,window)
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
	  window.screen.update_rect(0, 0, 0, 0)
	end
end

main()
