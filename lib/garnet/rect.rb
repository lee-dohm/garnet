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

    # Creates a mask on the given side and of the given size.
    # 
    # @param side One of :left, :right, :top or :bottom.
    # @param size The thickness of the mask.
    # @return [Rect] A rectangle describing the masked off area.
    def create_mask(side, size)
      case side
      when :left
        Rect.new(@min_x, @min_y, size, @height)
      when :right
        Rect.new(@width - size, @min_y, size, @height)
      when :top
        Rect.new(@min_x, @min_y, @width, size)
      when :bottom
        Rect.new(@min_x, @height - size, @width, size)
      end
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

    # Removes a portion of this rectangle defined by the given rectangle.
    # 
    # @param [Rect] rect Rectangle to remove.
    # @return [Rect] New dimensions of the rectangle.
    def -(rect)
      if rect.min_x == 0 && rect.min_y == 0
        if @height == rect.height
          Rect.new(@min_x + rect.width, @min_y, @width - rect.width, @height)
        else
          Rect.new(@min_x, @min_y + rect.height, @width, @height - rect.height)
        end
      else
        if @height == rect.height
          Rect.new(@min_x, @min_y, @width - rect.width, @height)
        else
          Rect.new(@min_x, @min_y, @width, @height - rect.height)
        end
      end
    end

    # Performs integer division if +num+ is a multiple of +den+, otherwise performs floating-point division.
    # 
    # @param num Numerator in the division.
    # @param den Denominator in the division.
    # @return [Numeric] Result of the division.
    def clean_divide(num, den)
      num % den == 0 ? num / den : num.to_f / den
    end
    private :clean_divide
  end
end
