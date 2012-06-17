# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

require 'rexml/document'

module Test
  # Various helper methods for executing tests.
  module Helpers
    def assert_xml_declaration(xml)
      lines = xml.split("\n")
      lines.first.must_equal "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
    end
    infect_an_assertion :assert_xml_declaration, :must_have_xml_declaration, true

    def assert_svg_doctype(xml)
      lines = xml.split("\n")
      lines[1].must_equal "<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">"
    end
    infect_an_assertion :assert_svg_doctype, :must_have_svg_doctype, true
 
    def assert_valid_root(xml, chart)
      doc = REXML::Document.new xml

      doc.root.name.must_equal 'svg'

      doc.root.attributes.count.must_equal 4
      doc.root.attributes['version'].must_equal '1.1'
      doc.root.attributes['xmlns'].must_equal 'http://www.w3.org/2000/svg'
      doc.root.attributes['width'].must_equal chart.width.to_s
      doc.root.attributes['height'].must_equal chart.height.to_s
    end
    infect_an_assertion :assert_valid_root, :must_have_valid_root, true
  end
end
