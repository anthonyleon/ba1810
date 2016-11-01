class ErrorsController < ApplicationController
  def not_found
  	render(status: 404, layout: "/commons/_error_navbar.html.haml")
  end

  def internal_server_error
  	render(status: 500, layout: "/commons/_error_navbar.html.haml")
  end
end
