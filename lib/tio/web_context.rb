module Tio
  class WebContext
    # extend WebContext::Extension
    # include WebContext::Inclusion
    
    def initialize(app)
      @app = app
    end

    attr_reader :app

    def static_root
      @app.root.join('app/web/public')
    end

    # shortcuts

    delegate  :request,
              to: :web_server

    delegate  :web_server, :web_server_class,
              to: :@app
  end
end