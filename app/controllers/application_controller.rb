class ApplicationController < ActionController::Base
  include ManageException
  include ManageObjects

  skip_before_action :verify_authenticity_token
end
