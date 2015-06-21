#coding: utf-8
require 'bundler'
Bundler.require

require 'sdl'

#ウィンドウに関するクラス
class Window
	@@width=500
	@@height=420
	@@windowName='オセロ'#メインウィンドウの表示名

	#getter
	attr_reader :screen

	#ウィンドウ生成処理
	# @param backColor [Array] ウィンドウの背景色
	def initialize(backColor)
		@backColor=backColor
		SDL.init(SDL::INIT_VIDEO)
		@screen = SDL::Screen.open(@@width,@@height, 16, SDL::SWSURFACE)
		SDL::WM::set_caption(@@windowName,'testsprite.rb icon')

		#背景色を赤で塗りつぶし
		@screen.fill_rect(0,0,@@width,@@height,@backColor)
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

