# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

module Garnet
  # Represents an SVG rectangle.
  class Rect
    attr_accessor :min_x
    attr_accessor :min_y
    attr_accessor :width
    attr_accessor :height

    def initialize
      @min_x = 0
      @min_y = 0
      @width = 0
      @height = 0
    end
  end
end
