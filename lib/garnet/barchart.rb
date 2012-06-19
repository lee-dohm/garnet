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
        chart.data.each do |datum|
          b.rect(:width => 4, :height => datum.to_s)
        end
      end
    end
  end
end
