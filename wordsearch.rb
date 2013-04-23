#!/usr/bin/ruby

######################################################################
# IGN Code-Foo 2013
# Word Search Question
#
# Author:    Sam Creed
# Date:      23-April 2013
#
# This program prints out the coordinates (x,y from top-left)
# of words from a list of given words 

# constants
FILENAME = "word-search.txt"
END_TOKEN = "Words to find:" # flags end of word search

# returns the line of given length with given orientation (up, down, etc)
def grab_line(search, row, col, length, orientation)
    line = ""

    case orientation
    when :down
        # check boundary case
        if search.has_key?([row + length, col])
            (0..length).each do |i|
                line += search[[row + i, col]]
            end
        end

    when :down_right
        # check boundary case
        if search.has_key?([row + length, col + length])
            (0..length).each do |i|
                line += search[[row + i, col + i]]
            end
        end

    when :right
        # check boundary case
        if search.has_key?([row, col + length])
            (0..length).each do |i|
                line += search[[row, col + i]]
            end
        end

    when :up_right
        # check boundary case
        if search.has_key?([row - length, col + length])
            (0..length).each do |i|
                line += search[[row - i, col + i]]
            end
        end

    when :up
        # check boundary case
        if search.has_key?([row - length, col])
            (0..length).each do |i|
                line += search[[row - i, col]]
            end
        end

    when :up_left
        # check boundary case
        if search.has_key?([row - length, col - length])
            (0..length).each do |i|
                line += search[[row - i, col - i]]
            end
        end

    when :left
        # check boundary case
        if search.has_key?([row, col - length])
            (0..length).each do |i|
                line += search[[row, col - i]]
            end
        end

    when :down_left
        # check boundary case
        if search.has_key?([row + length, col - length])
            (0..length).each do |i|
                line += search[[row + i, col - i]]
            end
        end
    end

    return line
end

# returns true if the word starts at (row, col)
def starts_here(search, word, row, col)

    len = word.length - 1

    orientations = [
        :down,
        :down_right,
        :right,
        :up_right,
        :up,
        :up_left,
        :left,
        :down_left]

    orientations.each do |orientation|
        found = grab_line(search, row, col, len, orientation)

        if word == found
            return true
        end
    end

    return false
end

# prints out the locations of the given word
def find_word(search, word, maxRow, maxCol)
    (0..maxRow).each do |i|
        (0..maxCol).each do |j|
            if starts_here(search, word, i, j)
                puts "The word '#{word}' starts at (#{i},#{j})."
                return
            end
        end
    end
    puts "The word '#{word}' was not found!"
end

# ------------------ MAIN -------------------- #

search = Hash.new
list = Array.new

reading_search = true
row = 0

# to be determined
maxRow = -1
maxCol = -1

# parse word search file and read in data
infile = File.readlines(FILENAME).map do |line|
    line = line.strip

    if line == END_TOKEN
        # we're done reading the word search
        reading_search = false

    elsif reading_search
        # parse current line of the word search
        nums = line.split("\t")
        nums.each_with_index { |val, col|
            search[[row, col]] = val
            maxCol = [maxCol, col].max
        }
        # increment row for next line
        row += 1
    else
        # read new word we need to find
        line = line.gsub(" ", "")
        list.push(line.downcase)
    end
end

# we correct for last blank line and extra 1
maxRow = row - 2

# find each word
list.each do |word|
    find_word(search, word, maxRow, maxCol)
end
