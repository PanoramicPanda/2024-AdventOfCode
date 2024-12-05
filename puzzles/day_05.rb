require_relative '../utilities/advent_helpers'

# Day 5 - Print Queue
#
# This class provides methods to sort print jobs and calculate the total of the middle pages numbers.
# It also provides methods to resort incorrect print jobs and calculate the total of the now-sorted middle pages numbers.
class PrintQueue
  attr_reader :queue, :page_orders, :correct_orders, :incorrect_orders

  # Initializes a new instance of PrintQueue
  #
  # @return [nil]
  def initialize
    @queue = []
    @page_orders = []
    @correct_orders = []
    @incorrect_orders = []
  end

  # Adds a print job to the queue
  #
  # @param pages [String] The print job to add
  #
  # @return [nil]
  def add_to_queue(pages)
    @queue << pages.split(',').map(&:to_i)
  end

  # Adds a page order to the page_orders array
  #
  # @param pages [String] The page order to add, expressed as "1|2", where 1 is the first page and 2 is the second page.
  #
  # @return [nil]
  def add_to_page_orders(pages)
    @page_orders << pages.split("|").map(&:to_i)
  end

  # Returns a list of pages that come after a given page
  #
  # @param page_number [Integer] The page number to check
  #
  # @return [Array] An array of pages that come after the given page according to the page_orders array
  def list_of_later_pages(page_number)
    later_pages = []
    @page_orders.each do |page_order|
      if page_order[0] == page_number
        later_pages << page_order[1]
      end
    end
    later_pages
  end

  # Checks if a print job is in the correct order, according to the page order rules
  #
  # @param print_job [Array] The print job to check
  #
  # @return [Boolean] True if the print job is in the correct order, false if it is not
  def check_correct_order(print_job)
    print_job.each_with_index do |page_number, page_index|
      later_pages = list_of_later_pages(page_number)
      later_pages.each do |later_page|
        if print_job.index(later_page)
          return false if print_job.index(later_page) < page_index
        end
      end
    end
    true
  end

  # Sorts the loaded print jobs into correct and incorrect orders
  #
  # @return [nil]
  def sort_orders_by_correctness
    @queue.each do |print_job|
      if check_correct_order(print_job)
        @correct_orders << print_job
      else
        @incorrect_orders << print_job
      end
    end
  end

  # Returns the middle page of a print job
  #
  # @param print_job [Array] The print job to check
  def get_middle_page(print_job)
    print_job[print_job.length / 2]
  end

  # Returns the total of the middle page numbers of all print jobs in a given order
  #
  # @param print_job [Array] The print jobs to check
  #
  # @return [Integer] The total of the middle page numbers
  def get_middle_page_total_for_order(print_job)
    middle_pages = 0
    print_job.each do |job|
      middle_pages += get_middle_page(job)
    end
    middle_pages
  end

  # Resorts the incorrect print jobs by moving pages that come later in the page order to the correct position
  # Does this using a loop that continues until all print jobs are in the correct order
  #
  # @return [nil]
  def resort_incorrect_orders
    @incorrect_orders.each_with_index do |print_job|
      until check_correct_order(print_job)
        print_job.each_with_index do |page_number, page_index|
          later_pages = list_of_later_pages(page_number)
          later_pages.each do |later_page|
            if print_job.index(later_page) && print_job.index(later_page) < page_index
              print_job.insert(page_index, print_job.delete_at(print_job.index(later_page)))
            end
          end
        end
      end
    end
  end

  # Loads a file and adds each line to the queue or page_orders array
  #
  # @param filename [String] The name of the file to load
  #
  # @return [nil]
  def load_file(filename)
    AdventHelpers.load_file_and_do(filename) do |line|
      add_to_queue(line) if line.include?(',')
      add_to_page_orders(line) if line.include?('|')
    end
  end
end

# Example usage
if __FILE__ == $PROGRAM_NAME
  pq = PrintQueue.new
  pq.load_file('day_05.txt')
  pq.sort_orders_by_correctness
  puts "Total for correct middle pages: #{pq.get_middle_page_total_for_order(pq.correct_orders)}"
  pq.resort_incorrect_orders
  puts "Total for re-corrected middle pages: #{pq.get_middle_page_total_for_order(pq.incorrect_orders)}"
end