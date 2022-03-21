module Tio
  class WorkContext
    # extend WorkContext::Extension
    # include WorkContext::Inclusion
    
    def initialize(app)
      @app = app
    end

    attr_reader :app

    # shortcuts

    # delegate  :demand,
    #           to: :work_server

    # delegate  :work_server, :work_server_class,
    #           to: :@app
  end
end