# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

gem 'minitest'

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/mock'

require 'garnet'
require 'helpers'
require 'nokogiri'

include Garnet
include Test::Helpers

describe BarChart do
  before do
    @data = [10, 20, 30]
    @display_rect = [0, 0, 1200, 900]

    @mock = MiniTest::Mock.new
    @mock.expect(:data, @data)
    @mock.expect(:data, @data)
    @mock.expect(:data, @data)
    @mock.expect(:display_rect, @display_rect)
    @mock.expect(:display_rect, @display_rect)
  end

  it 'will render the chart within a group' do
    xml = BarChart.render(Builder::XmlMarkup.new(:indent => 2), @mock)

    xml.must_have_root_name "g"
  end

  it 'will render each bar as four units wide' do
    xml = BarChart.render(Builder::XmlMarkup.new(:indent => 2), @mock)

    xml.must_have_count_elements "g/rect", @data.count
    xml.must_have_attribute_on_element_equal "width", "g/rect", "4"
  end

  it 'will render each bar as its value high' do
    xml = BarChart.render(Builder::XmlMarkup.new(:indent => 2), @mock)

    xml.must_have_count_elements "g/rect", @data.count
    xml.must_have_attribute_on_element_equal "height", "g/rect", @data
  end

  it 'will render each bar at an x-position of five times its index plus one' do
    data = 0.upto(2).map { |i| 5 * i + 1 }

    xml = BarChart.render(Builder::XmlMarkup.new(:indent => 2), @mock)

    xml.must_have_count_elements "g/rect", @data.count
    xml.must_have_attribute_on_element_equal "x", "g/rect", data
  end

  it 'will render each bar at a y-position of the max value minus its value' do
    max = @data.max
    data = @data.map { |n| max - n }

    xml = BarChart.render(Builder::XmlMarkup.new(:indent => 2), @mock)

    xml.must_have_count_elements "g/rect", @data.count
    xml.must_have_attribute_on_element_equal "y", "g/rect", data
  end

  it 'will add a transform attribute to the group to scale to the display rect' do
    # Width divided by x-coord of the last bar plus width of the last bar plus one for the margin at the edge.
    scale_x = @display_rect[2] / (@data.count * 5 + 1 + 4 + 1)
    scale_y = @display_rect[3] / @data.max

    xml = BarChart.render(Builder::XmlMarkup.new(:indent => 2), @mock)

    xml.must_have_attribute_on_element_equal "transform", "g", "scale(#{scale_x}, #{scale_y})"
  end
end
