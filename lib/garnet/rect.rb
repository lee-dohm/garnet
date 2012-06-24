# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

module Garnet
  # Represents an SVG rectangle.
  class Rect
    # Left side of the rectangle.
    attr_accessor :min_x

    # Top of the rectangle.
    attr_accessor :min_y

    # Width of the rectangle.
    attr_accessor :width

    # Height of the rectangle.
    attr_accessor :height

    # Initializes a new instance of the +Rect+ class.
    def initialize(min_x = 0, min_y = 0, width = 0, height = 0)
      @min_x = min_x
      @min_y = min_y
      @width = width
      @height = height
    end

    # Generates SVG-compliant instructions on how to transform this object
    # into +rect+.
    #
    # @param rect Rectangle to transform this object into.
    def transform(rect)
      if rect.width % @width == 0
        scale_x = rect.width / @width
      else
        scale_x = rect.width.to_f / @width
      end

      if rect.height % @height == 0        
        scale_y = rect.height / @height
      else
        scale_y = rect.height.to_f / @height
      end

      "scale(#{scale_x}, #{scale_y})"
    end
  end
end
