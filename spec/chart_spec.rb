# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

gem 'minitest'

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/mock'

require 'builder'
require 'garnet'
require 'helpers'
require 'pp'

include Garnet
include Test::Helpers

describe Chart do
  DEFAULT_WIDTH = 1200
  DEFAULT_HEIGHT = 900

  it 'can be instantiated' do
    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT)

    chart.width.must_equal DEFAULT_WIDTH
    chart.height.must_equal DEFAULT_HEIGHT
  end

  it 'will raise an error on negative width' do
    proc {
      Chart.new(-1, DEFAULT_HEIGHT)
    }.must_raise ArgumentError
  end

  it 'will raise an error on negative height' do
    proc {
      Chart.new(DEFAULT_WIDTH, -1)
    }.must_raise ArgumentError
  end

  it 'can be asked to render itself' do
    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT)

    image = chart.render

    image.must_have_xml_declaration
    image.must_have_svg_doctype
    image.must_have_valid_root chart
  end

  it 'will accept data' do
    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do
      set_data [1, 2, 3]
    end

    chart.data.must_equal [1, 2, 3]
  end

  it 'will have a default display rect of 0 0 width height' do
    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT)

    chart.display_rect.must_equal Rect.new(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT)
  end

  it 'can have a chart type assigned to it' do
    mock = MiniTest::Mock.new
    mock.expect(:render, nil)
    mock.expect(:must_equal, mock, [mock])

    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do
      set_type mock
    end

    chart.type.must_equal mock
  end

  it 'will raise an error if the type that is set does not respond to #render' do
    proc {
      Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do
        set_type Numeric
      end
    }.must_raise InvalidChartTypeError
  end

  it 'will call the chart type render method when render is called' do
    mock = MiniTest::Mock.new
    mock.expect(:render, nil, [Builder::XmlMarkup, Chart])
    mock.expect(:nil?, false)

    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do
      set_type mock
    end

    chart.render

    mock.verify
  end
end
