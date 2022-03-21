module Tio
  module WebServerRequestInclusion
    # def self.included(mod)
    #   puts "#{self} included in #{mod}"
    # end

    def request(http_method=nil, path=nil, added_params = Tio::OPT)
      router = self.class.requests.router

      if [http_method, path].all? &:nil?
        router.nav 
      else
        route = router.find(http_method, path)
        route.to_request(added_params)
      end
    end
  end
end
