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
    @display_rect = Rect.new(0, 0, 1400, 1050)

    @mock = MiniTest::Mock.new
    @mock.expect(:data, @data)
    @mock.expect(:data, @data)
    @mock.expect(:data, @data)
    @mock.expect(:display_rect, @display_rect)
    @mock.expect(:display_rect, @display_rect)

    @chart = BarChart.new(Builder::XmlMarkup.new(:indent => 2), @mock)
  end

  it 'will render the chart within a group' do
    xml = @chart.render

    xml.must_have_root_name "g"
  end

  it 'will render each bar as four units wide' do
    xml = @chart.render

    xml.must_have_count_elements "g/rect", @data.count
    xml.must_have_attribute_on_element_equal "width", "g/rect", "4"
  end

  it 'will render each bar as its value high' do
    xml = @chart.render

    xml.must_have_count_elements "g/rect", @data.count
    xml.must_have_attribute_on_element_equal "height", "g/rect", @data
  end

  it 'will render each bar at an x-position of five times its index' do
    data = 0.upto(2).map { |i| 5 * i }

    xml = @chart.render

    xml.must_have_count_elements "g/rect", @data.count
    xml.must_have_attribute_on_element_equal "x", "g/rect", data
  end

  it 'will render each bar at a y-position of the max value minus its value' do
    max = @data.max
    data = @data.map { |n| max - n }

    xml = @chart.render

    xml.must_have_count_elements "g/rect", @data.count
    xml.must_have_attribute_on_element_equal "y", "g/rect", data
  end

  it 'will render each bar with a default color if none is supplied' do
    xml = @chart.render

    xml.must_have_attribute_on_element_equal "fill", "g/rect", "rgb(89, 154, 211)"
  end

  it 'will render each bar in the assigned color' do
    @chart.colors = "blue"
    xml = @chart.render

    xml.must_have_attribute_on_element_equal "fill", "g/rect", "blue"
  end

  it 'will render each bar in the color that matches its index in the color array' do
    data = ["blue", "red", "green"]
    @chart.colors = data
    xml = @chart.render

    xml.must_have_attribute_on_element_equal "fill", "g/rect", data
  end

  it 'will start over with the first color if we run out of colors' do
    data = ["blue", "red", "blue"]
    @chart.colors = ["blue", "red"]
    xml = @chart.render

    xml.must_have_attribute_on_element_equal "fill", "g/rect", data
  end

  it 'will add a transform attribute to the group to scale to the display rect' do
    # Width divided by x-coord of the last bar plus width of the last bar.
    scale_x = @display_rect.width / ((@data.count - 1) * 5 + 4)
    scale_y = @display_rect.height / @data.max

    xml = @chart.render

    xml.must_have_attribute_on_element_equal "transform", "g", "scale(#{scale_x}, #{scale_y})"
  end

  it 'will add a translate transformation if the display_rect does not have a min-x of 0' do
    @display_rect.min_x = 5
    scale_x = @display_rect.width / ((@data.count - 1) * 5 + 4)
    scale_y = @display_rect.height / @data.max

    xml = @chart.render

    xml.must_have_attribute_on_element_equal "transform", "g", "scale(#{scale_x}, #{scale_y}), translate(5, 0)"
  end

  it 'will add a translate transformation if the display_rect does not have a min-y of 0' do
    @display_rect.min_y = 5
    scale_x = @display_rect.width / ((@data.count - 1) * 5 + 4)
    scale_y = @display_rect.height / @data.max

    xml = @chart.render

    xml.must_have_attribute_on_element_equal "transform", "g", "scale(#{scale_x}, #{scale_y}), translate(0, 5)"
  end
end
