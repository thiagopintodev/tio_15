class WorkServer < Tio::WorkServer

  # demands do
  #   demand :users do
  #     route '/users/check',                   :check_up
  #     route '/users/@user_id/check',          :check
  #     route '/users/@user_id/welcome_email',  :welcome_email
  #   end

  #   demand :schools do
  #     route '/schools/some_method_for_all',    :some_method_for_all
  #     route '/schools/@school_id/some_method', :some_method
  #     route '/schools/@school_id/some_other',  :some_other
  #   end
  # end

  # schedule do
  #   on('boot') { migrate }
  #   at('10AM') {  }
  #   at('10:30AM') {  }
  #   every('2 hours') {  }
  # end

end
