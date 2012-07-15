require File.expand_path('../test_helper', __FILE__)

class MapBeardGrowTest < Test::Unit::TestCase
  def test_beard1
    map1_string = <<EOS
##########
#**  \\\\\\\\#
#.R..    #
# \\  ..*\\#
#!   ..*!#
####   # #
#\\\\... # L
#\\\\.W... #
#\\\\.     #
##########

Growth 15
Razors 0
EOS

    map1_res_string = <<EOS
##########
#*   \\\\\\\\#
#.       #
#  R ..*\\#
#!   ..*!#
####*W # #
#\\\\.W. # L
#\\\\.W... #
#\\\\.WWW  #
##########
EOS
    map1 = Icfpc2012::Map.new(map1_string)
    map1_res = Icfpc2012::Map.new(map1_res_string)
    map2 = map1
    "RRDDDDUUULLDWWWWWWWWWWWWWWWWRWU".split(//).each {|cmd| map2 = map2.step(cmd)}
    map3 = map1
    "RRDDDDUUULLDWWWWWWWWWWWWWWWWWRU".split(//).each {|cmd| map3 = map3.step(cmd)}

    assert_equal(map1_res.map_array.inspect, map2.map_array.inspect)
    assert_equal(map1_res.map_array.inspect, map3.map_array.inspect)
  end

    def test_beard2
    map1_string = <<EOS
########
#R *   #
#  * W #
#  *   #
#######L

Growth 1
EOS

    map1_res_string = <<EOS
########
#R  WWW#
#   *WW#
#  *WWW#
#######L
EOS
    map1 = Icfpc2012::Map.new(map1_string)
    map1_res = Icfpc2012::Map.new(map1_res_string)
    map2 = map1.step("W")

    assert_equal(map1_res.map_array.inspect, map2.map_array.inspect)
  end

    def test_beard3
    map1_string = <<EOS
        ################
        #*****#!!  1   #
        #..\\..#        #
#########\\\\\\\\ # .\\\\\\.  #
#.............# *      #
#.. .\\\\\\#..!..#\\**     #
#.. LW\\\\#W  ..##### ####
#..R\\\\\\\\#.. ..*\\*\\*W...#
#.......A.. ...\\.\\...\\\\#
#..........     **     #
############....\\.######
           #.....!#
           ########

Growth 10
Trampoline A targets 1

EOS

    map1_res_string = <<EOS
        ################
        #*****#!!  1   #
        #..\\..#        #
#########\\\\\\\\ # .\\\\\\.  #
#.............# *      #
#.. .\\\\\\#..!..#\\**WWW  #
#.. LW\\\\#WWW..#####W####
#.. \\\\\\\\#..W..*\\ \\ W...#
#.. ....A.. ...   WR.\\\\#
#..            ***     #
############....\\.######
           #.....!#
           ########
EOS
    map1 = Icfpc2012::Map.new(map1_string)
    map1_res = Icfpc2012::Map.new(map1_res_string)
    map2 = map1
    "DDRRRRRRRRRRRRURRRWR".split(//).each {|cmd| map2 = map2.step(cmd)}

    assert_equal(map1_res.map_array.inspect, map2.map_array.inspect)
  end

end
