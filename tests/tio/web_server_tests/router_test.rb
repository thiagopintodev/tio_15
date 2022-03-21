require_relative '../../../tests'


# ██████   ██████  ██    ██ ████████ ███████ ██████  
# ██   ██ ██    ██ ██    ██    ██    ██      ██   ██ 
# ██████  ██    ██ ██    ██    ██    █████   ██████  
# ██   ██ ██    ██ ██    ██    ██    ██      ██   ██ 
# ██   ██  ██████   ██████     ██    ███████ ██   ██ 

# GIVEN a new instance
# THEN it has zero actions

puts "\n" * 10

subject = Tio::WebServerRequestExtension::Router




def test_eq(actual, expected)
  raise unless actual == expected
rescue
  puts "actual:   #{actual}".red.on_light_white
  puts "expected: #{expected}".green.on_light_white
  raise
end

def test_find(router, http_method, path, route, klass, action, format, params)
  k = Tio::WebServerRequestExtension::Router::Route
  expected = k.new(http_method, path, route, klass, action, format, params)
  
  actual   = router.find(http_method, path)

  raise unless actual == expected
rescue
  puts "actual:   #{actual}".red.on_light_white
  puts "expected: #{expected}".green.on_light_white
  raise
end

def test_nav(router, m_req, m_act, m_args, route, http_method, path, klass, action, format, params)
  k = Tio::WebServerRequestExtension::Router::Route
  expected = k.new(http_method, path, route, klass, action, format, params).to_request
  
  nav_req = router.nav.send(m_req)
  actual  = nav_req.send(m_act, *m_args)

  expected = expected.instance_variables.map { |iv| [iv, expected.instance_variable_get(iv)] }.to_h
  actual   = actual.instance_variables.map { |iv| [iv, actual.instance_variable_get(iv)] }.to_h
  
  raise unless actual == expected
rescue
  puts "actual:   #{actual}".red.on_light_white
  puts "expected: #{expected}".green.on_light_white
  raise
end




#  █████  ██████  ██████  
# ██   ██ ██   ██ ██   ██ 
# ███████ ██   ██ ██   ██ 
# ██   ██ ██   ██ ██   ██ 
# ██   ██ ██████  ██████  

# router.add(route, klass, get_action, post_action)

router = subject.new

# GIVEN a new router
# THEN  it counts 0 routes

test_eq(router.count, 0)

# WHEN I add a first route
# THEN it counts 1 route

router.add('/', RootRequest, :root, :root)
test_eq(router.count, 1)

# WHEN I add a second route
# THEN it counts 2 routes

router.add('/users', UsersRequest, :list, :list)
test_eq(router.count, 2)

# WHEN I add the same route a second time
# THEN there's totally a bug here >:)

router.add('/users', UsersRequest, :list, :list)
test_eq(router.count, 3)







# ███████ ██ ███    ██ ██████  
# ██      ██ ████   ██ ██   ██ 
# █████   ██ ██ ██  ██ ██   ██ 
# ██      ██ ██  ██ ██ ██   ██ 
# ██      ██ ██   ████ ██████  

# router.find(http_method, path)

router = subject.new

# GIVEN a new router
# THEN root finds error 404

test_find router,
          'GET',  '/',
          'error_404',
          RootRequest, 'error_404', 'html', {}

test_find router,
          'POST', '/',
          'error_404',
          RootRequest, 'error_404', 'html', {}

# GIVEN a router has 4 routes

router.add('/',               RootRequest,  :root,     :root)
router.add('/users',          UsersRequest, :list,     :list)
router.add('/users/create',   UsersRequest, :creating, :create)
router.add('/users/@user_id', UsersRequest, :read,     :read)

# FOR EACH ROUTE
#   WHEN I find those routes
#   THEN it has one action

test_find router,
          'GET', '/',
          '/',
          RootRequest, :root, 'html', {}
test_find router,
          'POST', '/',
          '/',
          RootRequest, :root, 'html', {}

test_find router,
          'GET', '/users',
          '/users',
          UsersRequest, :list, 'html', {}
test_find router,
          'POST', '/users',
          '/users',
          UsersRequest, :list, 'html', {}

test_find router,
          'GET', '/users/create',
          '/users/create',
          UsersRequest, :creating, 'html', {}
test_find router,
          'POST', '/users/create',
          '/users/create',
          UsersRequest, :create,   'html', {}

test_find router,
          'GET', '/users/create',
          '/users/create',
          UsersRequest, :creating, 'html', {}
test_find router,
          'POST', '/users/create',
          '/users/create',
          UsersRequest, :create,   'html', {}

test_find router,
          'GET', '/users/123',
          '/users/@user_id',
          UsersRequest, :read, 'html', {'user_id' => '123'}
test_find router,
          'POST', '/users/123',
          '/users/@user_id',
          UsersRequest, :read, 'html', {'user_id' => '123'}









# ███    ██  █████  ██    ██ 
# ████   ██ ██   ██ ██    ██ 
# ██ ██  ██ ███████ ██    ██ 
# ██  ██ ██ ██   ██  ██  ██  
# ██   ████ ██   ██   ████   

# router.nav

router = subject.new

# GIVEN a new router
# THEN root finds error 404

# test_nav  router,
#           :root, :root, [],
#           'error_404',
#           'GET', '/', RootRequest, 'error_404', 'html', {}

# GIVEN a router has 4 routes

router.add('/',               RootRequest,  :root,     :root)
router.add('/users',          UsersRequest, :list,     :list)
router.add('/users/create',   UsersRequest, :creating, :create)
router.add('/users/@user_id', UsersRequest, :read,     :read)

# FOR EACH ROUTE
#   WHEN I navigate those routes
#   THEN it has one action

test_nav  router,
          :root, :root, [],
          '/',
          'GET', '/', RootRequest, :root, 'html', {}

test_nav  router,
          :users, :list, [],
          '/users',
          'GET', '/users', UsersRequest, :list, 'html', {}

test_nav  router,
          :users, :creating, [],
          '/users/create',
          'GET', '/users/create', UsersRequest, :creating, 'html', {}

test_nav  router,
          :users, :create, [],
          '/users/create',
          'POST', '/users/create', UsersRequest, :create,   'html', {}

test_nav  router,
          :users, :read, ['123'],
          '/users/@user_id',
          'GET', '/users/123', UsersRequest, :read, 'html', {'user_id' => '123'}



# WHEN I navigate a route with added params
# THEN result includes them

test_nav  router,
          :users, :read, ['123', {dog: 1, cat: 2}],
          '/users/@user_id',
          'GET', '/users/123', UsersRequest, :read, 'html', {'user_id' => '123', "dog"=>1, "cat"=>2}



binding.irb

# router.nav.get('/users')
# router.nav.get('/users', dog: 2, cat: 5)
# router.nav.get('/users', dog: 2, cat: 5).path
# router.nav.get('/users', dog: 2, cat: 5).path_q

# router.nav.users.read(1)
# router.nav.users.read(1, cat: 2)
# router.nav.users.read(1, cat: 2).path
# router.nav.users.read(1, cat: 2).path_q



