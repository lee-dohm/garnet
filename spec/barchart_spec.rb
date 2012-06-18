# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

gem 'minitest'

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/mock'

require 'garnet'
require 'rexml/document'

include Garnet

describe BarChart do
  it 'will render the chart within a group' do
    mock = MiniTest::Mock.new

    xml = BarChart.render(Builder::XmlMarkup.new(:indent => 2), mock)
    doc = REXML::Document.new xml

    doc.root.name.must_equal "g"
    mock.verify
  end  
end
