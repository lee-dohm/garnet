# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

module Garnet
  # Creates a border around the outside of the image.
  class Border
    # Margin outside the border.
    attr_accessor :margin

    # Padding inside the border.
    attr_accessor :padding

    # Thickness of the border.
    attr_accessor :thickness

    # Sets the defaults for the border.
    def initialize
      @margin = 0
      @padding = 5
      @thickness = 1
    end
  end
end
