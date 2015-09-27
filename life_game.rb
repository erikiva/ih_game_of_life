require 'pry'

class Cell
  def initialize(state, neighbours)
    @state = state # either 1 or 0 for alive or dead
    @neighbours = neighbours # an array that represents the surrounding cells
  end

  def regenerate
    lneighbours = @neighbours.reduce{ |sum, n| sum + n }
    @state = (@state == 0 )? regenerate_dead(lneighbours)  : regenerate_live(lneighbours) 
  end

  def regenerate_live neighbor_num
     (2..3).include?(neighbor_num) ? @state : 0
  end

  def regenerate_dead neighbor_num
    neighbor_num == 3 ? 1 : @state
  end
end

class Grid  

  attr_accessor :grid, :size

  def initialize size
    @size = size 
    @grid = Array.new(size) { Array.new(size, 0) }
  end 

  def set_live x, y
    @grid[x][y] = 1 if (x.abs < size && y.abs < size)
  end
  
  def neighbour_coordinates coordinates, x_diff, y_diff 
    x = coordinates[0] + x_diff    
    y = coordinates[1] + y_diff 
    #binding.pry
    if  !(0..@size-1).include?(x) || !(0..@size-1).include?(y)
      x = nil 
      y = nil
    end 
    return x, y
  end

  def get_neighbours grid, coordinates
    neighbouring_positions = [[0,1],[0,-1],[1,0],[-1,0],[-1,-1],[1,1],[1,-1],[-1,1]]
    neighbours = []
    neighbouring_positions.each do |pos_diff|
      #binding.pry
      x, y = neighbour_coordinates coordinates, pos_diff[0], pos_diff[1]
      #binding.pry
      neighbours << ((x && y) ? grid[x][y] : 0)
    end
    neighbours
  end

  def swipe 
    tmp_grid = @grid.map(&:dup)
    @grid.each_with_index do |line, i|
      line.each_with_index do |cell, j|
        neighbours = get_neighbours tmp_grid, [i, j]
        #binding.pry
        @grid[i][j] = Cell.new(@grid[i][j], neighbours).regenerate
      end
    end
    print_grid
  end

  def print_grid
    (0..@size-1).each do |i|
        (0..size-1).each do |j|
          print "#{@grid[i][j]} "
        end
        print "\n"
      end
  end

end 

grid = Grid.new 6

# (0..grid.size-1).each do |i|
#         (0..grid.size-1).each do |j|
#           print "[#{i}][#{j}] "
#         end
#         print "\n"
#       end
#       print "-----------\n"

grid.set_live 3,2
grid.set_live 3,3
grid.set_live 3,4
grid.set_live 3,1
grid.set_live 3,5
grid.set_live 2,3
grid.set_live 2,4

#grid.print_grid
10.times do 
  grid.swipe
  sleep(1)
  system "clear"
end
