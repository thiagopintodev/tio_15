module Tio::WebServerRequestExtension
  class Settings
    def initialize
      @router = Router.new
    end

    attr_reader :router

    def request(klass_token, *recipes, &block)
      @request_class = _request_constantize(klass_token)

      recipes.each do |recipe|
        send("route_recipe_#{recipe}")
      end

      instance_eval(&block) if block_given?

      @request_class = nil
    end

    def _request_constantize(klass_token)
      "#{klass_token.to_s.camelize}Request".constantize
    end

    def route(route, get_action, post_action = get_action)
      String.argument_error route
      Symbol.argument_error get_action
      Symbol.argument_error post_action

      @router.add(route, @request_class, get_action, post_action)
    end

    # these should be included from a module
    def route_recipe_rest_13(name)
      plural = name.pluralize
      singular = name.singularize
      
      route "/#{plural}",                        :list
      route "/#{plural}/search",                 :search
      route "/#{plural}/create",                 :creating, :create
      route "/#{plural}/update",                 :updating, :update
      route "/#{plural}/clear",                  :clearing, :clear
      route "/#{plural}/@#{singular}_id",        :read
      route "/#{plural}/@#{singular}_id/edit",   :editing,  :edit
      route "/#{plural}/@#{singular}_id/remove", :removing, :remove
    end
  end
end
