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

    # Renders the chart as a standard bar chart.
    # 
    # @param [Builder::XmlMarkup] builder Builder object to use to emit XML.
    # @param [Chart] chart Object describing the chart.
    def self.render(builder, chart)
      max = chart.data.max
      scale_x = chart.display_rect[2] / (chart.data.count * 5 + 1 + 4 + 1)
      scale_y = chart.display_rect[3] / max

      builder.g(:transform => "scale(#{scale_x}, #{scale_y})") do |b|
        chart.data.each_with_index do |datum, index|
          b.rect(:x => (index * 5 + 1), :y => (max - datum), :width => 4, :height => datum.to_s)
        end
      end
    end
  end
end
