module Tio
  class WorkServer
    extend WorkServerDemandExtension
    # include WorkServerDemandInclusion
    
    def initialize(app)
      @app = app
    end

    attr_reader :app

    # shortcuts

    delegate  :web, :work, :terminal,
              to: :@app
  end
end
