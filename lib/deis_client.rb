require 'uri'
require 'rest-client'

class DeisError < StandardError
end

class DeisClient
  attr_reader :user_token

  def initialize(controller_uri, username, password, mock=false)
    @mock = mock
    raise DeisError.new("No username or password detected!") if username.nil? || password.nil?
    raise DeisError.new("You must specify a URI for Deis controller!") unless controller_uri =~ /\A#{URI::regexp}\z/
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
      response = RestClient.post apps_url, payload.to_json, :Authorization => "token #{@user_token}", content_type: :json, accept: :json
      JSON.parse response.body
    end
  end

  def key_add(user_name, ssh_public_key)
    raise DeisError.new("Username is required") if user_name.nil?
    raise DeisError.new("SSH key is required") if ssh_public_key.nil?
    if @mock
      {}
    else
      payload = {"id": user_name, "public": ssh_public_key}
      response = RestClient.post keys_url, payload.to_json, :Authorization => "token #{@user_token}", content_type: :json, accept: :json
      JSON.parse response.body
    end
  end

  def config_set(app_name, config_hash={})
    raise DeisError.new("App name is required") if app_name.nil?
    if @mock || config_hash.empty?
      {}
    else
      payload = {"values": config_hash}
      response = RestClient.post config_url(app_name), payload.to_json, :Authorization => "token #{@user_token}", content_type: :json, accept: :json
      JSON.parse response.body
    end
  end

  private

  def login_url
    "#{@deis_controller}/v1/auth/login/"
  end

  def apps_url
    "#{@deis_controller}/v1/apps/"
  end

  def config_url(app_name)
    "#{apps_url}#{app_name}/config"
  end

  def keys_url
    "#{@deis_controller}/v1/keys/"
  end
end
