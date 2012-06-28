# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

require 'builder'

# Provide a library for easily transforming data sets into SVG chart images.
module Garnet
  # Raised when the type of chart assigned is not a valid chart type.
  class InvalidChartTypeError < StandardError
  end

  # Accepts the data and generates the chart output.
  class Chart
    # Data to be displayed in the chart.
    attr_accessor :data

    # Features of the chart other than the chart itself.
    attr_reader :features

    # Height of the generated image.
    attr_reader :height

    # Type of the chart to render.
    attr_reader :type

    # Width of the generated image.
    attr_reader :width

    # Initialize a new instance of the +Chart+ class.
    # 
    # @param width Width of the image to generate.
    # @param height Height of the image to generate.
    # @raise [ArgumentError] When width or height are negative.
    def initialize(width, height)
      raise ArgumentError, "Width cannot be negative" if width < 0
      raise ArgumentError, "Height cannot be negative" if height < 0

      @width = width
      @height = height
      @type = nil
      @features = []

      @display_rect = Rect.new(0, 0, @width, @height)

      yield self if block_given?
    end

    # Rectangle within the image to display the actual chart.
    def display_rect
      rect = @display_rect

      @features.each do |f|
        feature_rect = f.rectangle

        case f.placement
        when :left
          place_left(rect, feature_rect)
        when :right
          place_right(rect, feature_rect)
        when :above
          place_above(rect, feature_rect)
        when :below
          place_below(rect, feature_rect)
        when :behind
          place_above(rect, feature_rect[0])
          place_right(rect, feature_rect[1])
          place_below(rect, feature_rect[2])
          place_left(rect, feature_rect[3])
        end
      end

      rect
    end

    # Renders the chart as an SVG image.
    #
    # @return [String] SVG text describing the chart.
    def render
      builder = Builder::XmlMarkup.new(:indent => 2)
      
      builder.instruct! :xml, :version => "1.0", :standalone => "no"
      builder.declare! :DOCTYPE, :svg, :PUBLIC, "-//W3C//DTD SVG 1.1//EN", "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"

      options = {}
      options[:version] = '1.1'
      options[:xmlns] = 'http://www.w3.org/2000/svg' 
      options[:width] = @width
      options[:height] = @height
      builder.svg(options) do |b|
        unless @type.nil?
          type = @type.new(b, self)
          type.render
        end
      end

      builder.target!
    end

    # Sets the type of chart to render.
    def type=(type)
      raise InvalidChartTypeError, "#{type.to_s} is not a valid chart type." unless type.public_instance_methods.include?(:render)

      @type = type
    end

    private

    def place_above(rect, feature_rect)
      rect.min_y += feature_rect.height
      rect.height -= feature_rect.height
    end

    def place_below(rect, feature_rect)
      rect.height -= feature_rect.height
    end

    def place_left(rect, feature_rect)
      rect.min_x += feature_rect.width
      rect.width -= feature_rect.width
    end

    def place_right(rect, feature_rect)
      rect.width -= feature_rect.width
    end
  end
end
