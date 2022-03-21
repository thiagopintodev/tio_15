module Tio
  module WorkServerDemandExtension
    # def self.extended(mod)
    #   puts "#{self} extended in #{mod}"
    # end

    def demands(&block)
      # reading-mode
      return @demands if @demands.is_a? Settings

      # writing-mode
      return @demands = block if block_given?
      
      # reading-mode
      if @demands.is_a? Proc
        x = Settings.new
        x.instance_eval &@demands
        return @demands = x
      end

      raise "#{self.class}.demands unset!"
    end
  end
end