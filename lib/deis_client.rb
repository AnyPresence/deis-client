require 'uri'
require 'rest-client'

class DeisClient
  attr_reader :user_token

  def initialize(controller_uri, username, password, mock=false)
    @mock = mock
    raise new Error("No username or password detected!") if username.nil? || password.nil?
    raise new Error("You must specify a URI for Deis controller!") unless controller_uri =~ /\A#{URI::regexp}\z/
    @deis_controller = controller_uri
    login(username, password)
    self
  end

  def login(username, password)
    if @mock
      @user_token = "ABC123"
    else
      response = RestClient.post login_url, {"username": username, "password": password}.to_json, content_type: :json, accept: :json
      body = JSON.parse response.body
      @user_token = body.fetch('token')
    end
  end

  def app_create(name)
    if @mock
      {}
    else
      payload = name.nil? ? Hash.new : {"id": name}
      response = RestClient.post apps_url, payload.to_json, auth, content_type: :json, accept: :json
      JSON.parse response.body
    end
  end

  private

  def auth
    {"Authorization" => "token #{@user_token}"}
  end

  def login_url
    "#{@deis_controller}/v1/auth/login/"
  end

  def apps_url
    "#{@deis_controller}/v1/apps/"
  end
end
