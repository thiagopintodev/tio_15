module Tio
  class WorkDemand
    # extend WorkRequestExtension

    def self.action(name, &block)
      puts "work server demands define action '#{name}' with a block".light_red
    end

    # NOTE: this will not be global in the future
    # NOTE: This is a shortcut, to help write path helpers
    # <%= work.demand.users.welcome_email(@user[:id]).path %>
    def work
      $app.work
    end

  end
end