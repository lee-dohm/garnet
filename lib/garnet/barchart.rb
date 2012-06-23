# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

module Garnet
  # Defines the standard bar chart type.
  class BarChart
    # Colors:
    # 89 154 211
    # 241 89 95
    # 121 195 106
    # 249 166 90
    # 158 102 171
    # 205 112 88
    # 215 127 179
    # 114 114 114

    # Margin to the left of the leftmost bar and to the right of the rightmost bar.
    OUTSIDE_BAR_MARGIN = 1

    # Margin between bars.
    BETWEEN_BAR_MARGIN = 1

    # Width of bars.
    BAR_WIDTH = 4

    # Initializes a new instance of the +BarChart+ class.
    # 
    # @param [Builder::XmlMarkup] builder Builder object to use to emit XML.
    # @param [Chart] chart Object describing the chart.
    def initialize(builder, chart)
      @builder = builder
      @chart = chart
    end

    # Renders the chart from the data.
    def render
      data = @chart.data
      max = data.max
      count = data.count

      display_rect = @chart.display_rect
      scale_x = display_rect[2] / ((count * BAR_WIDTH) + ((count - 1) * BETWEEN_BAR_MARGIN) + (2 * OUTSIDE_BAR_MARGIN))
      scale_y = display_rect[3] / max

      @builder.g(:transform => "scale(#{scale_x}, #{scale_y})") do |b|
        data.each_with_index do |datum, index|
          b.rect(:x => (index * (BAR_WIDTH + BETWEEN_BAR_MARGIN) + OUTSIDE_BAR_MARGIN), 
                       :y => (max - datum), 
                       :width => BAR_WIDTH, 
                       :height => datum.to_s)
        end
      end
    end
  end
end
