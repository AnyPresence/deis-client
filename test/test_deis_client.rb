require 'minitest/autorun'
require 'deis_client'

class DeisClientTest < Minitest::Test
  def test_login
    DeisClient.new("http://controller.example.com", 'humpty', 'dumpty', true)
  end

end
