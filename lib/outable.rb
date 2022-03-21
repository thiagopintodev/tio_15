# https://rubygems.org/gems/outable

require 'colorize'

module Outable
  module_function

  def cols(*cols)
    max = cols.map { |col| col.size }.max
    cols.each { |col| max.times.each { |i| col[i] ||= '' } }

    out cols.transpose, cols
  end

  def rows(*rows)
    max = rows.map { |row| row.size }.max
    rows.each { |row| max.times.each { |i| row[i] ||= '' } }
    
    out rows, rows.transpose
  end

  def out(rows, cols)
    lengths = cols.map { |r| r.map(&:size) }.map(&:max)
    puts

    # [:red, :yellow, :green, :cyan, :blue, :magenta].each do |c|
    [:green].each do |c|
      rows.each_with_index do |row, ir|
        row.each_with_index do |cell, ic|
          s = cell.to_s.ljust(lengths[ic]).colorize(c)

          s = s.bold if ir.zero?
          print " #{s} "
        end
        print ''
        puts
      end
    end

    puts
  end
end