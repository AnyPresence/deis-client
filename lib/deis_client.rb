require 'uri'
require 'rest-client'

class DeisClient
  attr_accessor deis_controller, user_token, testing

  def initialize(controller_uri: controller, username: user, password: pass, mock: mock)
    testing = mock
    raise new Error("No username or password detected!") if user.nil? || pass.nil?
    raise new Error("You must specify a URI for Deis controller!") unless controller =~ /\A#{URI::regexp}\z/
    deis_controller = controller
    login(user, pass)
    self
  end

  def login(username, password)
    if testing
      user_token = "123ABC"
    else
      response = RestClient.post login_url, {"username": username, "password": password}.to_json, content_type: :json, accept: :json
      body = JSON.parse response.body
      user_token = body.fetch('token')
    end
  end

  def app_create(name)
    if testing
      {}
    else
      payload = name.nil? Hash.new : {"id": name}
      response = RestClient.post apps_url, payload.to_json, {:Authorization => "token #{user_token}"}, content_type: :json, accept: :json
      JSON.parse response.body
    end
  end

  private

  def login_url
    "#{deis_controller}/v1/auth/login/"
  end

  def apps_url
    "#{deis_controller}/v1/apps/"
  end
end
