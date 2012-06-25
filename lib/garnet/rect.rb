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

    # Generates SVG-compliant instructions on how to transform this object into +rect+.
    #
    # @param rect Rectangle to transform this object into.
    # @return [String] SVG transformation instructions, if any.
    def transform(rect)
      scale_x = clean_divide(rect.width, @width)
      scale_y = clean_divide(rect.height, @height)

      translate_x = rect.min_x - @min_x
      translate_y = rect.min_y - @min_y

      instructions = []
      instructions << "scale(#{scale_x}, #{scale_y})" unless scale_x == 1 && scale_y == 1
      instructions << "translate(#{translate_x}, #{translate_y})" unless translate_x == 0 && translate_y == 0

      instructions.join(", ")
    end

    # Determines equality between this and the given +rect+.
    # 
    # @param rect Rectangle to compare this object with.
    # @return [Boolean] +true+ if the two objects are equal.
    def ==(rect)
      @min_x == rect.min_x &&
      @min_y == rect.min_y &&
      @width == rect.width &&
      @height == rect.height
    end

    # Performs integer division if +num+ is a multiple of +den+, otherwise performs floating-point division.
    # 
    # @param num Numerator in the division.
    # @param den Denominator in the division.
    # @return [Numeric] Result of the division.
    def clean_divide(num, den)
      if num % den == 0
        num / den
      else
        num.to_f / den
      end
    end
    private :clean_divide
  end
end
