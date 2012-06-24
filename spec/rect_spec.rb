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
end
