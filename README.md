# deis-client
A simple Ruby wrapper to manage Deis PaaS applications via its REST API.

# Usage
```
app_name = 'awesome-app'

# Log in with a username and a password
@client = DeisClient.new('https://deis.example.com', 'admin', 'secret')

# Create an application with the given name, or let Deis make one up by passing nil
@client.app_create(app_name)

# Set some configurations on it
hash = {'FOO' => 'BAR', 'AWESOME' => 'SAUCE'}
@client.config_set(app_name, hash)

# Read and print its logs
puts @client.logs_get(app_name)

# Destroy it
@client.app_destroy(app_name)
```
