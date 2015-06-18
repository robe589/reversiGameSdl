#coding: utf-8
require 'bundler'
Bundler.require

require 'sdl'

def main()
	windowWidth=500
	windowHeight=400
	windowName='オセロ'

	SDL.init(SDL::INIT_VIDEO)
	screen = SDL::Screen.open(windowWidth,windowHeight, 16, SDL::SWSURFACE)

	SDL::WM::set_caption(windowName,'testsprite.rb icon')

	
	drawGrid(10,8,screen,windowWidth,windowHeight)
	
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

def drawGrid(space,gridSize,screen,windowWidth,windowHeight)
	if windowWidth>windowHeight
		max=windowHeight-space*2
	else
		max=windowWidth-space*2
	end

	#横ラインを描画	
	(gridSize+1).times do |i|
		screen.draw_line(space,space+max/gridSize*i,max+space,space+max/gridSize*i,[0,0,255])
	end
	#縦ラインを描画
	(gridSize+1).times do |i|
		screen.draw_line(space+max/gridSize*i,space,space+max/gridSize*i,max+space,[0,0,255])
	end
end

main()
