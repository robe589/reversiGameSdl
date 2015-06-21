#coding: utf-8
require 'bundler'
Bundler.require

require 'sdl'

class Window
	@@width=500
	@@height=420
	@@backColor=[0,255,255]
	@@windowName='オセロ'#メインウィンドウの表示名

	#getter
	attr_reader :screen

	def initialize
		SDL.init(SDL::INIT_VIDEO)
		@screen = SDL::Screen.open(@@width,@@height, 16, SDL::SWSURFACE)
		SDL::WM::set_caption(@@windowName,'testsprite.rb icon')

		#背景色を赤で塗りつぶし
		@screen.fill_rect(0,0,@@width,@@height,@@backColor)
	end

	#getter
	def width
		@@width
	end

	#getter
	def height
		@@height
	end
end

