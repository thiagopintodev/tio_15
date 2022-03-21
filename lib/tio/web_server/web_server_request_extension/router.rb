# TODO: add more arity options
# https://apidock.com/ruby/Method/arity
class Tio::WebServerRequestExtension::Router
  def initialize
    @tree = Node.new
    @nav = Nav.new(self)
    @count = 0
  end

  attr_reader :tree, :nav, :count

  # https://ruby-doc.org/core-3.1.1/Regexp.html
  # \w: [0-9a-zA-Z_]
  # \/: /
  # \@: @
  KEY_REGEX = /[^\w\/\@]/

  class Error < StandardError; end
  class RouteTypo < Error; end

  def add(route, klass, get_action, post_action)
    Tio.debug "adding '#{route}', #{klass}, :#{get_action}, :#{post_action}".light_red
    _raise_invalid_route_slash(route) if route[0] != '/'
    _raise_invalid_route_regexp(route) if _is_route_invalid(route)
    
    actions = [get_action, post_action]

    # ENSURE crumbs HAS FIRST ITEM ''

    crumbs = route.split('/')
    crumbs = [''] if crumbs.empty?

    # FILTER params FROM crumbs WHERE crumb IS A PARAM-CRUMB

    params = crumbs.select { |crumb| crumb[0] == '@' }.map { |crumb| crumb[1..-1] }

    Tio.debug "  adding crumbs: #{crumbs} (params #{params})".light_yellow

    _add_to_tree(route, klass, actions, crumbs, params)
    _add_to_nav(route, klass, actions, params)

    @count += 1
  end

  private

  def _add_to_tree(route, klass, actions, crumbs, params)
    last = node = @tree

    # FOR EACH crumb
    #   COPY node TO last
    #   DIG crumb UNDER node
    #   & COPY TO node
    #   MARK last WITH crumb, node IF crumb IS A PARAM-CRUMB

    crumbs.each do |crumb|
      last = node

      node = node.nodes[crumb] ||= Node.new

      last.set_param(crumb[1..-1], node) if crumb[0]=='@'
    end

    # FILL THE LAST FOUND node

    node.fill(route, klass, actions, params)
  end

  def _add_to_nav(route, klass, actions, params)
    # this is returned by `web.request`
    nav = @nav

    # defines `web.request.users`
    if !nav.respond_to? klass.token
      nav_request = NavRequest.new(klass.token)
      nav.define_singleton_method(klass.token) { nav_request }
    end

    nav_request = nav.send(klass.token)

    raise unless nav_request.is_a? NavRequest
    # defines `web.request.users.creatting`
    # defines `web.request.users.create`

    format = 'html'

    _add_to_nav_define(nav_request, actions[0], klass, Tio::GET,  params, route, format)
    _add_to_nav_define(nav_request, actions[1], klass, Tio::POST, params, route, format) if actions[0] != actions[1]
  end

  def _add_to_nav_define(nav_request, action, klass, http_method, params_keys, route, format)
    bl =  proc do |*args|
            added_params = args.last.is_a?(Hash) ? args.pop : Tio::OPT

            args.size == params_keys.size || raise(ArgumentError, "#{action}| Expected #{params_keys.size} arguments, but #{args.size} received for #{route}")

            params = {}
            args.size.times do |i|
              params[params_keys[i]] = args[i]
            end

            path = route.split('/')
                        .map { |crumb| crumb[0] == '@' ? params[crumb[1..-1]] : crumb }
                        .join('/')

            path = "/#{path}" if path[0] != '/'

            Route.new(http_method, path, route, klass, action, format, params).to_request(added_params)
          end

    nav_request.define_singleton_method(action, &bl)
  end

  public

  def find(http_method, path)
    Tio::GET_POST.argument_error http_method
    String.argument_error path

    Tio.debug "fiding '#{path}'".red
    # I need this to prepend the first /
    
    path = "/#{path}" if path[0] != '/'
    path =  path.split('?').first.to_s
                .split('#').first.to_s
    crumbs = path.split('/')
    crumbs = [''] if crumbs.empty?

    cursor = @tree

    params = {}

    # format = path.split('.').last
    format = 'html'

    Tio.debug "  available crumbs: #{crumbs}".yellow
    crumbs.each do |crumb|
      Tio.debug "    finding crumb '#{crumb}' in? #{cursor.nodes.keys}".green

      if cursor.nodes.has_key?(crumb)
        cursor = cursor.nodes[crumb] 
        next
      end

      if cursor.param_crumb
        params[cursor.param_crumb] = crumb
        cursor = cursor.param_node
        next
      end

      return _find_route_404(http_method, path, format)
    end

    # raise "Can't find a URL match to `#{path}.`" if cursor.nil?
    # raise "Can't find a URL match to `#{path}..`" if cursor.klass.nil?

    # action = http_method == Tio::GET ? cursor.get : cursor.post

    action = cursor.actions[http_method == Tio::GET ? 0 : 1]

    Route.new(http_method, path, cursor.key, cursor.klass, action, format, params)
  end

  private

  def _find_route_404(http_method, path, format)
    Route.new(http_method, path, 'error_404', RootRequest, 'error_404', format, {})
  end

  def _is_route_invalid(key)
    key.gsub(KEY_REGEX, Tio::BLANK).size < key.size
  end

  def _raise_invalid_route_slash(key)
    raise "Route `#{key}` doesn't start with `/`"
  end

  def _raise_invalid_route_regexp(key)
    raise "Route `#{key}` doesn't match Regexp `#{KEY_REGEX.inspect}`"
  end

  Route = Struct.new(:http_method, :path, :route, :klass, :action, :format, :params) do
    def path_format
      return path if path == '/'
      "#{path}.#{format}"
    end
    
    def to_request(added_params=Tio::OPT)
      klass.new(self, added_params)
    end
  end

  class Node
    attr_accessor :key, :klass, :actions, :params, :param_crumb, :param_node

    def nodes
      @nodes ||= {}
    end

    def fill(key, klass, actions, params)
      @key, @klass, @actions, @params = key, klass, actions, params
    end

    def set_param(crumb, node)
      @param_crumb, @param_node = crumb, node
    end
  end

  class Nav
    def initialize(router)
      @router = router
    end

    def get(path, added_params=Tio::OPT)
      @router.find(Tio::GET, path).to_request(added_params)
    end

    def post(path, added_params=Tio::OPT)
      @router.find(Tio::POST, path).to_request(added_params)
    end

    def method_missing(n, *args)
      not_found = "web.request.#{n}"
      alternatives = singleton_methods.map { |s| ["web.request.#{s}", self.send(s).singleton_methods.size] }

      Outable.rows  ["Route not found:", not_found, "#{alternatives.size} requests"],
                    *alternatives.map { |a_name, a_count| ['', "#{a_name}", "#{a_count} actions"] }

      raise RouteTypo, not_found
    end
  end

  class NavRequest
    def initialize(token)
      @token = token
    end

    def method_missing(n, *args)
      not_found = "web.request.#{@token}.#{n}"
      alternatives = singleton_methods.map { |s| ["web.request.#{@token}.#{s}", self.send(s).singleton_methods.size] }

      Outable.rows  ["Route not found:", not_found, "#{alternatives.size} requests"],
                    *alternatives.map { |a_name, a_count| ['', "#{a_name}", "#{a_count} actions"] }

      raise RouteTypo, "not_found(`#{args}`)"
    end
  end

end
