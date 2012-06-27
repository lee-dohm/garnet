# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

module Garnet
  # Defines the standard bar chart type.
  class BarChart
    # Width of bars.
    attr_accessor :bar_width

    # Margin between bars.
    attr_accessor :between_bar_margin

    # Color or colors to use to draw bars.
    attr_accessor :colors

    # Colors:
    # 89 154 211
    # 241 89 95
    # 121 195 106
    # 249 166 90
    # 158 102 171
    # 205 112 88
    # 215 127 179
    # 114 114 114

    # Initializes a new instance of the +BarChart+ class.
    # 
    # @param [Builder::XmlMarkup] builder Builder object to use to emit XML.
    # @param [Chart] chart Object describing the chart.
    def initialize(builder, chart)
      @builder = builder
      @chart = chart
      @colors = "rgb(89, 154, 211)"
      @bar_width = 4
      @between_bar_margin = 1
    end

    # Renders the chart from the data.
    def render
      data = @chart.data
      max = data.max
      chart_rect = Rect.new(0, 0, chart_width, max)

      @builder.g(:transform => chart_rect.transform(@chart.display_rect)) do |b|
        data.each_with_index do |datum, index|
          case @colors
          when Array
            color = @colors[index % @colors.count]
          else
            color = @colors
          end

          b.rect(:x => (index * (@bar_width + @between_bar_margin)), 
                 :y => (max - datum), 
                 :width => @bar_width, 
                 :height => datum.to_s,
                 :fill => color)
        end
      end
    end

    # Calculates the width of the chart before any transformations.
    # 
    # @return [Numeric] Width of the chart.
    def chart_width
      (@chart.data.count * @bar_width) + ((@chart.data.count - 1) * @between_bar_margin)
    end
    private :chart_width
  end
end
