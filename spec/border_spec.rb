# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

gem 'minitest'

require 'minitest/spec'
require 'minitest/autorun'

require 'garnet'

include Garnet

describe Border do
  it 'can be instantiated' do
    border = Border.new

    border.margin.must_equal 0
    border.padding.must_equal 5
    border.thickness.must_equal 1
  end
end
