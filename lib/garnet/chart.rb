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

    # Rectangle within the image to display the actual chart.
    attr_reader :display_rect

    # Features of the chart other than the chart itself.
    attr_reader :features

    # Height of the generated image.
    attr_accessor :height

    # Type of the chart to render.
    attr_reader :type

    # Width of the generated image.
    attr_accessor :width

    # Initialize a new instance of the +Chart+ class.
    # 
    # @param width Width of the image to generate.
    # @param height Height of the image to generate.
    # @raise [ArgumentError] When width or height are negative.
    # @yieldparam chart [Chart] To allow for modifying settings.
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

    # Adds a feature, such as axes or a legend, to the image.
    # 
    # @param [Feature] feature Feature class or object describing the feature to add.
    # @param [:left, :right, :top, :bottom, :behind] placement Where to place the feature in the image.
    # @return [nil]
    def add_feature(feature, placement)
      width = feature.width
      height = feature.height

      case placement
      when :behind
        feature.display_rect = Rect.new(@display_rect.min_x + (@width - width).to_f / 2,
                                        @display_rect.min_y + (@height - height).to_f / 2,
                                        width,
                                        height)
      when :left
        feature.display_rect = Rect.new(@display_rect.min_x,
                                        @display_rect.min_y + (@display_rect.height - height).to_f / 2,
                                        width,
                                        height)
        @display_rect.min_x += width
        @display_rect.width -= width
      when :top
        feature.display_rect = Rect.new(@display_rect.min_x + (@display_rect.width - width).to_f / 2,
                                        @display_rect.min_y,
                                        width,
                                        height)
        @display_rect.min_y += height
        @display_rect.height -= height
      when :right
        feature.display_rect = Rect.new(@display_rect.min_x + @display_rect.width - width,
                                        @display_rect.min_y + (@display_rect.height - height).to_f / 2,
                                        width,
                                        height)
        @display_rect.width -= width
      when :bottom
        feature.display_rect = Rect.new(@display_rect.min_x + (@display_rect.width - width).to_f / 2,
                                        @display_rect.min_y + @display_rect.height - height,
                                        width,
                                        height)
        @display_rect.height -= height
      end

      @features << feature
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
          type.render(b, self)
        end
      end

      builder.target!
    end

    # Sets the type of chart to render.
    def type=(type)
      raise InvalidChartTypeError, "#{type.to_s} is not a valid chart type." unless type.respond_to?(:render)

      @type = type
    end
  end
end
