require_relative '../utilities/advent_helpers'
# Day 9: Disk Fragmenter
# This class takes a string reprentation of a disk and works to defragment it in different ways and find the checksums
class DiskFragmenter

  # Initialize the disk as empty
  #
  # @return [class] The DiskFragmenter object
  def initialize
    @disk = []
  end

  # Take the input and parse it onto the disk
  # We break the input into blocks of two characters, the first character is the number of blocks to add, the second is the number of empty blocks to add
  # We then add the blocks to the disk, using the index of the block as the id number to represent the block
  # We then add the empty blocks to the disk
  #
  # @param input [String] The input to parse
  #
  # @return [nil]
  def load_disk(input)
    @disk = []
    input.split("\n").each do |line|
      line.chars.each_slice(2).with_index do |block, index|
        block_info = [block[0].to_i, block[1].to_i, index]
        block_info[0].times { @disk << [block_info[2]]}
        block_info[1].times { @disk << ['.']}
      end
    end
  end

  # Return a flattened string representation of the disk
  #
  # @return [String] The string representation of the disk
  def string_representation
    @disk.flatten.map { |block| block == '.' ? '.' : block.to_s }.join
  end

  # Defragment the disk in one of two ways
  # If contiguous is true, we defragment the disk by moving all the blocks from the end of the disk to the beginning
  # But only if there are enough empty blocks to the left of the current block in the original array to fit the block
  # If contiguous is false, for each block in the disk in reverse order, swap the block with the first empty block of the regular order
  # This will move all the empty blocks to the end of the disk.
  # Only continues to process if there are empty blocks to the left of the current block in the original array
  #
  # @param contiguous [Boolean] Whether to defragment the disk in a contiguous way. Default is false.
  #
  # @return [nil]
  def defragment(contiguous: false)
    if contiguous
      reverse_index = @disk.length - 1

      while reverse_index >= 0
        current_block = @disk[reverse_index]

        if current_block != ['.']
          group_end = reverse_index
          group_start = reverse_index

          while group_start > 0 && @disk[group_start - 1] == current_block
            group_start -= 1
          end

          group_length = group_end - group_start + 1

          empty_block_start = nil
          (0...group_start).each do |index|
            if @disk[index...(index + group_length)].all? { |b| b == ['.'] }
              empty_block_start = index
              break
            end
          end

          if empty_block_start
            group_length.times do |i|
              @disk[empty_block_start + i] = current_block
              @disk[group_start + i] = ['.']
            end
          end

          reverse_index = group_start - 1
        else
          reverse_index -= 1
        end
      end
    else
      empty_block_index = @disk.index(['.'])

      return unless empty_block_index

      (@disk.length - 1).downto(0) do |index|
        block = @disk[index]
        next if block == ['.']

        if index > empty_block_index
          @disk[empty_block_index] = block
          @disk[index] = ['.']

          empty_block_index += 1 while @disk[empty_block_index] != ['.'] && empty_block_index < @disk.length
        end
      end
    end

  end

  # For each block in the disk that's not empty, multiply its contents by its index and add it to the checksum
  #
  # @return [Integer] The checksum of the disk
  def checksum
    @disk.each_with_index.reduce(0) do |sum, (block, index)|
      sum + (block == ['.'] ? 0 : block[0] * index)
    end
  end

  # Loads the input and runs the block for each line in the input
  #
  # @param input [String] The input to load
  #
  # @return [nil]
  def load_input(input)
    AdventHelpers.load_input_and_do(input) do |line|
      load_disk(line.strip)
    end
  end

end

# Example usage
if __FILE__ == $0
  df = DiskFragmenter.new
  df.load_input('day_09.txt')
  df.defragment
  puts "The checksum is #{df.checksum}"
  df.load_input('day_09.txt')
  df.defragment(contiguous: true)
  puts "The contiguous checksum is #{df.checksum}"
end