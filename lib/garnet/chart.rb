# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

module Garnet
  # Accepts the data and generates the chart output.
  class Chart
    # Height of the generated image.
    attr_reader :height

    # Width of the generated image.
    attr_reader :width

    # Initialize a new instance of the +Garnet::Chart+ class.
    # 
    # @param width Width of the image to generate.
    # @param height Height of the image to generate.
    def initialize(width, height)
      @width = width
      @height = height
    end
  end
end
