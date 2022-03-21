module Tio
  class App
    
    # WEB
    
    def self.set_web_server(web_server_class)
      @@web_server_class = web_server_class
    end

    def web_server_class
      @@web_server_class || raise("App.web_server_class unset!")
    end

    def web_server
      @web_server ||= web_server_class.new(self)
    end

    def web
      @web ||= WebContext.new(self)
    end

    # WORK

    def self.set_work_server(work_server_class)
      @@work_server_class = work_server_class
    end

    def work_server_class
      @@work_server_class || raise("App.work_server_class unset!")
    end

    def work_server
      @work_server ||= work_server_class.new(self)
    end

    def work
      @work ||= WorkContext.new(self)
    end

  end
end