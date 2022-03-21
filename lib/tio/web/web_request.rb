module Tio
  class WebRequest
    extend WebRequestExtension

    # NOTE: this will not be global in the future
    # NOTE: This is a shortcut, to help write path helpers
    # <%= web.request.users.edit(@user_id).path %>
    def web
      $app.web
    end

    def initialize(route, addded_params=Tio::OPT)
      @route, @action, @path, @format, @http_method = route.route, route.action, route.path_format, route.format, route.http_method

      @params = route.params.merge(addded_params).stringify_keys
      @params.each { |k, v| instance_variable_set("@#{k}", v) }
    end

    attr_reader :path

    def url
      "#{WebServer.domain}#{@path}"
    end

    def path_q
      "#{path}?#{@params.to_query}"
    end

    # def authenticate
      
    # end

    # def authorize
      
    # end

    # def render
      
    # end

    # @action, @format, @http_method, @path, @params
    def run(_headers={})
      @layout, @wrapper, @template = self.class._get_views(@action, @format)

      self.class._get_actions(@action, @format).each do |action|
        instance_eval(&action)
        # TODO: what if anything stops the execution?
        # TODO: what if it's authe?
        # TODO: what if it's autho?
        # TODO: what if it's a redirect?
      end

      messy = _run
      HtmlBeautifier.beautify(messy, indent: "    ")
    end

    def content(name, format = @format)
      content = self.class._get_content(name, format)

      raise "only ERB" if content[:renderer] != :erb

      _erb content[:view]
    end

    def _run
      _run_render @layout[:renderer], @layout[:view] do
        _run_render @wrapper[:renderer], @wrapper[:view] do
          _run_render @template[:renderer], @template[:view]
        end
      end
    end

    def _run_render(renderer, view, &block)
      raise "only ERB" if renderer != :erb

      _erb view, &block
    end

    def _erb(view)
      ERB.new(view).result(binding)
    end

    def _haml(view)
      # Haml.new(view).result(binding)
    end

    # Layouts

    # 'Making layouts optional'
    # There must be a default layout at the top-level

    # layout :html, :erb, <<-CODE
    layout <<-CODE
      <!DOCTYPE html>
      <html>
          <head>
              <title>My App</title>
              <%#= stylesheet_link_tag    "application", media: "all" %>
              <%#= javascript_include_tag "application" %>
              <%#= csrf_meta_tags %>
          </head>
          <body>

          <div id="container">
            <%= yield %>
          </div>


<style>
html, body {
  background-color: #4B7399;
  font-family: Verdana, Helvetica, Arial;
  font-size: 14px;
}

a {
  color: #0000FF;
  img { border: none; }
}

.clear {
  clear: both;
  height: 0;
  overflow: hidden;
}

#container {
  width: 80%;
  margin: 0 auto;
  background-color: #FFF;
  padding: 20px 40px;
  border: solid 1px black;
  margin-top: 20px;
}

#flash_notice, #flash_alert {
  padding: 5px 8px;
  margin: 10px 0;
}

#flash_notice {
  background-color: #CFC;
  border: solid 1px #6C6;
}

#flash_alert {
  background-color: #FCC;
  border: solid 1px #C66;
}

.error_messages, #error_explanation {
  width: 400px;
  border: 2px solid #CF0000;
  padding: 0px;
  padding-bottom: 12px;
  margin-bottom: 20px;
  background-color: #f0f0f0;
  font-size: 12px;

  h2 {
    text-align: left;
    font-weight: bold;
    padding: 5px 10px;
    font-size: 12px;
    margin: 0;
    background-color: #c00;
    color: #fff;
  }

  p { margin: 8px 10px; }
  ul { margin-bottom: 0; }
}

.field_with_errors {
  display: inline;
}

form .field, form .actions {
  margin: 12px 0;
}
</style>

          </body>
      </html>
    CODE

    # Wrappers

    # 'Making wrappers optional'
    # There must be a default wrapper at the top-level

    # wrapper :html, :erb, <<-CODE
    wrapper <<-CODE
      <!-- yield -->
      <%= yield %>
      <!-- /yield -->
    CODE

    # 'Making templates mandatory'
    # There must be a default template at the top-level

    template :template, <<-CODE
      View not found for action <%= @action %> on <%= self.class.name %>
    CODE

  end
end