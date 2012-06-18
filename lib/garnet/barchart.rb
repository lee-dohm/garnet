# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

module Garnet
  # Defines the standard bar chart type.
  class BarChart
    def self.render(builder, chart)
      builder.g do |b|
        chart.data.each do |datum|
          b.rect(:width => 4)
        end
      end
    end
  end
end
