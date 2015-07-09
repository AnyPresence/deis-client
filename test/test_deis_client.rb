require 'minitest/autorun'
require 'deis_client'

class DeisClientTest < Minitest::Test
  def test_login
    client = DeisClient.new(ENV['DEIS_CONTROLLER'] || "http://controller.example.com",
                            ENV['DEIS_USER'] || 'humpty',
                            ENV['DEIS_PASSWORD'] || 'dumpty',
                            true
                           )
    assert client.user_token == "ABC123"
  end

end
