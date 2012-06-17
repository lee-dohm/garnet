# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

require 'builder'

# Provide a library for easily transforming data sets into SVG chart images.
module Garnet
  # Accepts the data and generates the chart output.
  class Chart
    # Data to be displayed in the chart.
    attr_reader :data

    # Rectangle within the image to display the actual chart.  Expressed as an array of four numbers: min-x, min-y, width, height.
    attr_reader :display_rect

    # Height of the generated image.
    attr_reader :height

    # Width of the generated image.
    attr_reader :width

    # Initialize a new instance of the +Chart+ class.
    # 
    # @param width Width of the image to generate.
    # @param height Height of the image to generate.
    # @param block Instructions on how to build the chart.
    # @raise [ArgumentError] When width or height are negative.
    def initialize(width, height, &block)
      raise ArgumentError, "Width cannot be negative" if width < 0
      raise ArgumentError, "Height cannot be negative" if height < 0

      @width = width
      @height = height

      @display_rect = [0, 0, @width, @height]

      unless block.nil?
        instance_exec(&block)
      end
    end

    # Renders the chart as an SVG image.
    #
    # @return [String] SVG text describing the chart.
    def render
      b = Builder::XmlMarkup.new(:indent => 2)
      
      b.instruct! :xml, :version => "1.0", :standalone => "no"
      b.declare! :DOCTYPE, :svg, :PUBLIC, "-//W3C//DTD SVG 1.1//EN", "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"

      options = {}
      options[:version] = '1.1'
      options[:xmlns] = 'http://www.w3.org/2000/svg' 
      options[:width] = @width
      options[:height] = @height
      b.svg(options)

      b.target!
    end

    # Sets the data to use to render the chart.
    def set_data(data)
      @data = data
    end
    private :set_data
  end
end
