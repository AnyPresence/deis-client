require 'minitest/autorun'
require 'deis_client'

class DeisClientTest < Minitest::Test
  def self.test_order
    :alpha
  end

  def setup
    @username = ENV['DEIS_ADMIN_USER'] || 'humpty'
    @password = ENV['DEIS_ADMIN_PASSWORD'] || 'dumpty'
    @mock = true
    @instance_name = 'luxury-jumpsuit'
    @client = DeisClient.new(ENV['DEIS_CONTROLLER'] || "http://controller.example.com",
                            @username,
                            @password,
                            @mock
                           )
    @key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDZ47ISBG2bIQYV62g5qC58tRvHKh+OMITuxT/YyZzIZYmpDncmDLvaBVX7e3/V5d4CdJui/0pHGW/lnUtUUnTwexO1RABPENiCmUQAD7+QZbKyrYE43GHcXcZjEnAJIDt0FmRjGPFr99x/1kuKCAsouly6uTeRgt3DIjJWCkfvo5PBsdezgChcMCj3EDBqlR83qNFnL+at2I73Fv7GdNV/n7ORSru9POUGAqjdAv2jw02eZYKrxCZPRGimYRe+o0G7aMc6GDjWmonSL08yLryKIjrBD7C+YAzO8Z9UTF2EjgHQ2pKGQuPB5YS8X5APGQAy7HVWlMgBK6jcDuKz9ITLcKkkLUpX4ILch3ppR9OahxYCyJsTegHE3Vwtd0lP53eP/XsPOtMmd+gMch+N/HcK8N9U3c/3+LQpof1KG/SzFvOcplj7G29FDuMI9ziFkOxj7HBjJb4q3LYvOHAfFJIdmLcEH5ckyodxVRCKkravMJRT9X9S8G2MkX+J9/qH/3HNedgvWuqvtCdaozWnjTTU2yoLKUdoMKt1FHRLNLJKFdi27+sapTfP0Cs4IR8LY9sZw1LRk7YzCz21nb5jQs6X/npt2Szv7z0WZ/QUl81jQN6iVY4A5XZDy5cx9mXkxuBYSMl1PMLOR2k30bk6hnTmurhHFAgcDdmOQ3qhq9eUmQ== user@example.com"
  end


  def test_app_create
      response = @client.app_create(nil)
      unless @mock
        app = response["id"]
        assert response["id"]
        assert response["owner"] == @username
        assert response["uuid"]
        response = @client.logs_get(app)
        assert response.size > 0
        response = @client.app_destroy(app)
      end
  end

=begin
  def test_key_add
      assert_raises(DeisError) {
        @client.key_add(nil, nil)
      }
      response = @client.key_add(@username, @key)
      unless @mock
        assert response["id"]
        assert response["owner"] == @username
        assert response["public"] == @key
      end
  end
=end

  def test_config
    assert_raises(DeisError) {
      @client.config_set(nil, nil)
    }
    response = @client.app_create(nil)
    app_name = response["id"]
    unless @mock
      assert @client.config_set(app_name, {}).empty?
      configs = {"HELLO" => "world", "PLATFORM" => "deis"}
      response = @client.config_set(app_name, configs)
      assert response["values"].has_key?("HELLO")
      assert response["values"].has_key?("PLATFORM")
      assert response["values"].has_value?("world")
      assert response["values"].has_value?("deis")

      stored_config = @client.config_get(app_name)
      assert stored_config.has_key?("HELLO")
      assert stored_config.has_key?("PLATFORM")
      assert stored_config.has_value?("world")
      assert stored_config.has_value?("deis")

      response = @client.config_set(app_name, "BUILDPACK_URL" => "https://github.com/AnyPresence/heroku-buildpack-node")
      assert response["values"].has_key?("BUILDPACK_URL")

      response = @client.app_destroy(app_name)
    end
  end

  def test_command_run
    assert_raises(DeisError) {
      @client.config_set(nil, nil)
    }
    unless @mock
      response = @client.command_run(@instance_name, "echo stuff")
      assert response.first == 0
      assert response.last.strip.end_with? "stuff"
    end
  end

  def test_app_scale
    assert_raises(DeisError) {
      @client.app_scale(nil, "nil", "nil")
    }
    assert_raises(DeisError) {
      @client.app_scale("my-app", "proc", 1)
    }
    assert_raises(DeisError) {
      @client.app_scale("my-app", "web", -1)
    }
    unless @instance_name.nil?
      @client.app_scale(@instance_name, "web", 2)
    end
  end

  def test_app_restart
    assert_raises(DeisError) {
      @client.app_restart(nil)
    }
    unless @instance_name.nil?
      @client.app_restart(@instance_name)
    end
  end
end
