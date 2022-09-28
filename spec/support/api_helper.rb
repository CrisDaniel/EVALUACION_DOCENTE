module ApiHelper
  def auth_bearer(user, header)
    auth_headers = Devise::JWT::TestHelpers.auth_headers(header, user)
    auth_headers["Authorization"]
  end
end