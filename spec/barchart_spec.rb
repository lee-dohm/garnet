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
    @mock = MiniTest::Mock.new
    @mock.expect(:data, [10, 20, 30])
    @mock.expect(:display_rect, [0, 0, 1200, 900])
  end

  it 'will render the chart within a group' do
    xml = BarChart.render(Builder::XmlMarkup.new(:indent => 2), @mock)

    xml.must_have_root_name "g"
  end

  it 'will render each bar as four units wide' do
    xml = BarChart.render(Builder::XmlMarkup.new(:indent => 2), @mock)

    xml.must_have_count_elements "g/rect", 3
    xml.must_have_attribute_on_element_equal "width", "g/rect", "4"
  end

  it 'will render each bar as its value high' do
    data = [10, 20, 30]

    xml = BarChart.render(Builder::XmlMarkup.new(:indent => 2), @mock)

    xml.must_have_count_elements "g/rect", 3
    xml.must_have_attribute_on_element_equal "height", "g/rect", data
  end
end
