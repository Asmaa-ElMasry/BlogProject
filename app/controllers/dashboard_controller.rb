class DashboardController < ApplicationController
	def index
		@name=User.find(current_user.id)
		
	end

end
