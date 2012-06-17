# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

gem 'minitest'

require 'minitest/spec'
require 'minitest/autorun'

require 'garnet'

include Garnet

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
end
