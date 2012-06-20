# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

module Garnet
  # Defines the standard bar chart type.
  class BarChart
    # Renders the chart as a standard bar chart.
    # 
    # @param [Builder::XmlMarkup] builder Builder object to use to emit XML.
    # @param [Chart] chart Object describing the chart.
    def self.render(builder, chart)
      builder.g do |b|
        max = chart.data.max
        chart.data.each_with_index do |datum, index|
          b.rect(:x => (index * 5 + 1), :y => (max - datum), :width => 4, :height => datum.to_s)
        end
      end
    end
  end
end
