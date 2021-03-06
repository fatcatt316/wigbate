# Helpful
# http://bobintornado.github.io/rails/2015/12/29/Multiple-Images-Uploading-With-CarrierWave-and-PostgreSQL-Array.html
CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                          # required
  config.fog_credentials = {
    provider:              'AWS',                          # required
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],       # required
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],   # required
    region:                'us-west-2',                    # optional, defaults to 'us-east-1'
    # host:                  's3.example.com',             # optional, defaults to nil
    # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = 'wigbate'                                   # required
  config.fog_public     = false                                                 # optional, defaults to true
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
end