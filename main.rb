#coding: utf-8
require 'bundler'
Bundler.require

require 'sdl'

require './Reversi'
require './Window'
require './Draw'

def main()
	windowSpace=10#メインウィンドウの余白
	backColor=[0,255,255]#メインウィンドウの背景色
	
	window=Window.new(backColor)
	reversi=Reversi.new()
	draw=Draw.new(window.width,window.height,windowSpace,window.screen,backColor,reversi.gridState)
	#盤面を描画
	draw.drawGrid()
	draw.drawStone()
	list=reversi.showPutStone()
	draw.availablePutStone(list)
	sdlLoop(windowSpace,reversi,window,draw)
end

def sdlLoop(windowSpace,reversi,window,draw)
	loop do
	  while event = SDL::Event.poll
		case event
		when SDL::Event::Quit#ウィンドウのバツボタンが押された時
		  exit
		when SDL::Event::MouseButtonUp#マウスの左ボタンが押されて話された時
			x,y,* =SDL::Mouse.state#マウスのクリックされた座標を取得
			puts "x("+x.to_s+')'+' y('+y.to_s+')'
			x-=windowSpace
			y-=windowSpace
			gridSize=draw.gridSize
			reversi.putStone(y/gridSize,x/gridSize)
			list=reversi.showPutStone()
			draw.availablePutStone(list)
		end
		draw.drawStone()
	  end
	  window.screen.update_rect(0, 0, 0, 0)
	  reversi.countStone()
	  draw.showText(reversi.stoneColor,reversi.turnNum,reversi.blackStoneNum,reversi.whiteStoneNum)
	end
end

main()
