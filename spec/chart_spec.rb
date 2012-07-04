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
  FEATURE_WIDTH = 100
  FEATURE_HEIGHT = 100

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

  it 'can have a chart instance assigned to it' do
    mock = MiniTest::Mock.new
    mock.expect(:render, nil)
    mock.expect(:nil?, false)

    Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
      c.type = mock
    end
  end

  it 'will raise an error if the type that is set does not respond to #render' do
    mock = MiniTest::Mock.new

    proc {
      Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
        c.type = mock
      end
    }.must_raise InvalidChartTypeError
  end

  it 'will call the chart type render method when render is called' do
    mock = MiniTest::Mock.new
    mock.expect(:render, nil, [Builder::XmlMarkup, Chart])
    mock.expect(:nil?, false)

    chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
      c.type = mock
    end

    chart.render

    mock.verify
  end

  describe 'features' do
    before do
      @mock = MiniTest::Mock.new
      @mock.expect(:width, FEATURE_WIDTH)
      @mock.expect(:height, FEATURE_HEIGHT)
    end

    it 'will allow features to be added' do
      expected_min_x = (DEFAULT_WIDTH - FEATURE_WIDTH).to_f / 2
      expected_min_y = (DEFAULT_HEIGHT - FEATURE_HEIGHT).to_f / 2
      @mock.expect(:display_rect=, nil, [Rect.new(expected_min_x, expected_min_y, FEATURE_WIDTH, FEATURE_HEIGHT)])

      chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
        c.add_feature @mock, :behind
      end

      @mock.verify
      chart.display_rect.must_equal Rect.new(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT)
      chart.features.count.must_equal 1
    end

    it 'will allow features to be placed to the left of the chart' do
      expected_min_x = 0
      expected_min_y = (DEFAULT_HEIGHT - FEATURE_HEIGHT).to_f / 2
      @mock.expect(:display_rect=, nil, [Rect.new(expected_min_x, expected_min_y, FEATURE_WIDTH, FEATURE_HEIGHT)])

      chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
        c.add_feature @mock, :left
      end

      @mock.verify
      chart.display_rect.must_equal Rect.new(FEATURE_WIDTH, 0, DEFAULT_WIDTH - FEATURE_WIDTH, DEFAULT_HEIGHT)
      chart.features.count.must_equal 1
    end

    it 'will allow features to be placed above the chart' do
      expected_min_x = (DEFAULT_WIDTH - FEATURE_WIDTH).to_f / 2
      expected_min_y = 0
      @mock.expect(:display_rect=, nil, [Rect.new(expected_min_x, expected_min_y, FEATURE_WIDTH, FEATURE_HEIGHT)])

      chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
        c.add_feature @mock, :top
      end

      @mock.verify
      chart.display_rect.must_equal Rect.new(0, FEATURE_HEIGHT, DEFAULT_WIDTH, DEFAULT_HEIGHT - FEATURE_HEIGHT)
      chart.features.count.must_equal 1
    end

    it 'will allow features to be placed to the right of the chart' do
      expected_min_x = DEFAULT_WIDTH - FEATURE_WIDTH
      expected_min_y = (DEFAULT_HEIGHT - FEATURE_HEIGHT).to_f / 2
      @mock.expect(:display_rect=, nil, [Rect.new(expected_min_x, expected_min_y, FEATURE_WIDTH, FEATURE_HEIGHT)])

      chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
        c.add_feature @mock, :right
      end

      @mock.verify
      chart.display_rect.must_equal Rect.new(0, 0, DEFAULT_WIDTH - FEATURE_WIDTH, DEFAULT_HEIGHT)
      chart.features.count.must_equal 1
    end

    it 'will allow features to be placed below the chart' do
      expected_min_x = (DEFAULT_WIDTH - FEATURE_WIDTH).to_f / 2
      expected_min_y = DEFAULT_HEIGHT - FEATURE_HEIGHT
      @mock.expect(:display_rect=, nil, [Rect.new(expected_min_x, expected_min_y, FEATURE_WIDTH, FEATURE_HEIGHT)])

      chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
        c.add_feature @mock, :bottom
      end

      @mock.verify
      chart.display_rect.must_equal Rect.new(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT - FEATURE_HEIGHT)
      chart.features.count.must_equal 1
    end

    it 'will handle the case where the display rect is not at the origin' do
      left_mock = MiniTest::Mock.new
      left_mock.expect(:width, FEATURE_WIDTH)
      left_mock.expect(:height, FEATURE_HEIGHT)
      left_mock.expect(:display_rect=, nil, [Rect])

      top_mock = MiniTest::Mock.new
      top_mock.expect(:width, FEATURE_WIDTH)
      top_mock.expect(:height, FEATURE_HEIGHT)
      top_mock.expect(:display_rect=, nil, [Rect])

      mock = MiniTest::Mock.new
      mock.expect(:width, FEATURE_WIDTH)
      mock.expect(:height, FEATURE_HEIGHT)
      mock.expect(:display_rect=, nil, [Rect.new(FEATURE_WIDTH, 
                                                FEATURE_HEIGHT + (DEFAULT_HEIGHT - 2 * FEATURE_HEIGHT).to_f / 2, 
                                                FEATURE_WIDTH, 
                                                FEATURE_HEIGHT)])

      chart = Chart.new(DEFAULT_WIDTH, DEFAULT_HEIGHT) do |c|
        c.add_feature left_mock, :left
        c.add_feature top_mock, :top
        c.add_feature mock, :left
      end

      mock.verify
      chart.features.count.must_equal 3
    end
  end
end
