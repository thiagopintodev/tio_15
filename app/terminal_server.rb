class TerminalServer

# 	# # chain of command
# 	# commands do
# 	# 	command :ba
# 	# 	command :be, :ba
# 	# 	command :bi, before: []
# 	# 	command :bo, after: []
# 	# 	command :bu

# 	# 	command :ca
# 	# 	command :co
# 	# 	command :cu

# 	# 	command :da
# 	# 	command :de, :da
# 	# 	command :di, before: []
# 	# 	command :do, after: []
# 	# 	command :du
# 	# end

#   # panels do
#   #   panel :auth, 'Account' do
#   #     story 'Guest', 'Registers With Email'
#   #     story 'Guest', 'Registers With SMS'
#   #     story 'Guest''Authenticates With Email'
#   #     story 'Guest''Authenticates With SMS'
#   #     story 'User', 'Unregisters'
#   #     story 'User', 'Signs Out'
#   #     story :sign_out, 'User', 'Exits' # I hate my boss
#   #   end
#   # end

# 	screens do
# 		screen :auth, 'User Account' do
#       action 'Register With Email'
#       action 'Register With SMS'
#       action 'Authenticate With Email'
#       action 'Authenticate With SMS'
#       action 'Unregister'
#       action 'Sign Out'
#       action :sign_out, 'Exit' # I hate my boss

#       # components
#       # perspective
#       # story
      
#       experiment do
#       end
#     end



#   component "Sign Up Form 'Main'", "Guest"

# # do
# #   component "Sign Up Form 'Main'", "Guest" do
# #     experiments ""
# #   end
# # end



#     screen "Have the best forum" do
#       # action "Topic", :CRUD
#       action "Topic", "List"
#       action "Topic", "Create"
#       action "Topic", "Manage"
#       action "Topic", "Manage"
#       action "Topic", "Manage"
#       # components
#       # perspective
#       # story
#       # 
#       experiment do
#       end
#     end
# 	end

end
