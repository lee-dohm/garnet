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
    chart.features.must_equal []
    chart.display_rect.must_equal Rect.new(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT)
    chart.type.must_be_nil
    chart.data.must_be_nil
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
    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
      c.data = [1, 2, 3]
    end

    chart.data.must_equal [1, 2, 3]
  end

  it 'will have a default display rect of 0 0 width height' do
    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT)

    chart.display_rect.must_equal Rect.new(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT)
  end

  it 'can have a chart type assigned to it' do
    type_mock = MiniTest::Mock.new
    instance_mock = MiniTest::Mock.new
    type_mock.expect(:new, instance_mock, [Builder::XmlMarkup, Chart])
    type_mock.expect(:public_instance_methods, [:render])
    instance_mock.expect(:render, nil)
    instance_mock.expect(:nil?, false)

    Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
      c.type = type_mock
    end
  end

  it 'will raise an error if the type that is set does not respond to #render' do
    mock = MiniTest::Mock.new
    mock.expect(:public_instance_methods, [])

    proc {
      Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
        c.type = mock
      end
    }.must_raise InvalidChartTypeError
  end

  it 'will call the chart type render method when render is called' do
    type_mock = MiniTest::Mock.new
    instance_mock = MiniTest::Mock.new
    type_mock.expect(:new, instance_mock, [Builder::XmlMarkup, Chart])
    type_mock.expect(:public_instance_methods, [:render])
    type_mock.expect(:nil?, false)
    instance_mock.expect(:render, nil)

    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
      c.type = type_mock
    end

    chart.render

    type_mock.verify
    instance_mock.verify
  end

  it 'will allow features to be added to the chart' do
    mock = MiniTest::Mock.new

    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
      c.features << mock
    end

    chart.features.must_include mock
  end

  it 'will allow features to be placed to the left of the chart' do
    mock = MiniTest::Mock.new
    mock.expect(:placement, :left)
    mock.expect(:rectangle, Rect.new(0, 0, 100, DEFAULT_HEIGHT))

    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
      c.features << mock
    end

    chart.display_rect.must_equal Rect.new(100, 0, DEFAULT_WIDTH - 100, DEFAULT_HEIGHT)
  end

  it 'will allow features to be placed to the right of the chart' do
    mock = MiniTest::Mock.new
    mock.expect(:placement, :right)
    mock.expect(:rectangle, Rect.new(0, 0, 100, DEFAULT_HEIGHT))

    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
      c.features << mock
    end

    chart.display_rect.must_equal Rect.new(0, 0, DEFAULT_WIDTH - 100, DEFAULT_HEIGHT)
  end

  it 'will allow features to be placed above the chart' do
    mock = MiniTest::Mock.new
    mock.expect(:placement, :above)
    mock.expect(:rectangle, Rect.new(0, 0, DEFAULT_WIDTH, 100))

    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
      c.features << mock
    end

    chart.display_rect.must_equal Rect.new(0, 100, DEFAULT_WIDTH, DEFAULT_HEIGHT - 100)
  end

  it 'will allow features to be placed below the chart' do
    mock = MiniTest::Mock.new
    mock.expect(:placement, :below)
    mock.expect(:rectangle, Rect.new(0, 0, DEFAULT_WIDTH, 100))

    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
      c.features << mock
    end

    chart.display_rect.must_equal Rect.new(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT - 100)
  end
end
