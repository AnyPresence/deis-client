require 'minitest/autorun'
require 'deis_client'

class DeisClientTest < Minitest::Test

  def test_login
    client = DeisClient.new(ENV['DEIS_CONTROLLER'] || "http://controller.example.com",
                            ENV['DEIS_USER'] || 'humpty',
                            ENV['DEIS_PASSWORD'] || 'dumpty',
                            ENV['MOCK_CALLS_TO_DEIS']
                           )

    if ENV['MOCK_CALLS_TO_DEIS']
      assert client.user_token == "ABC123"
      assert client.app_create("cloudy") == {}
    else
      response = client.app_create("fluffy")
      assert response["id"] == "fluffy"
      assert response["owner"] == ENV['DEIS_USER'] || 'humpty'
      assert response["uuid"]
    end
  end

end
