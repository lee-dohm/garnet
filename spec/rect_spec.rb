# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

gem 'minitest'

require 'minitest/spec'
require 'minitest/autorun'

require 'garnet'

include Garnet

describe Rect do
  it 'can be initialized' do
    rect = Rect.new

    rect.min_x.must_equal 0
    rect.min_y.must_equal 0
    rect.width.must_equal 0
    rect.height.must_equal 0
  end

  it 'can be initialized to values' do
    rect = Rect.new(1, 2, 3, 4)

    rect.min_x.must_equal 1
    rect.min_y.must_equal 2
    rect.width.must_equal 3
    rect.height.must_equal 4
  end

  it 'will generate no instructions if rects are equal' do
    orig_rect = Rect.new(10, 20, 1200, 900)
    new_rect = Rect.new(10, 20, 1200, 900)

    orig_rect.transform(new_rect).must_be_empty
  end

  it 'can generate scale instructions' do
    orig_rect = Rect.new(0, 0, 12, 9)
    new_rect = Rect.new(0, 0, 1200, 900)

    orig_rect.transform(new_rect).must_equal "scale(100, 100)"
  end

  it 'can generate scale instructions for only the x-axis' do
    orig_rect = Rect.new(0, 0, 12, 900)
    new_rect = Rect.new(0, 0, 1200, 900)

    orig_rect.transform(new_rect).must_equal "scale(100, 1)"
  end

  it 'can generate scale instructions for only the y-axis' do
    orig_rect = Rect.new(0, 0, 1200, 9)
    new_rect = Rect.new(0, 0, 1200, 900)

    orig_rect.transform(new_rect).must_equal "scale(1, 100)"
  end

  it 'can generate shrinking scale instructions too' do
    orig_rect = Rect.new(0, 0, 1200, 900)
    new_rect = Rect.new(0, 0, 12, 9)

    orig_rect.transform(new_rect).must_equal "scale(0.01, 0.01)"
  end

  it 'can generate translation instructions' do
    orig_rect = Rect.new(0, 0, 1200, 900)
    new_rect = Rect.new(10, 20, 1200, 900)

    orig_rect.transform(new_rect).must_equal "translate(10, 20)"
  end
end
