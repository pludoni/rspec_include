VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
  config.ignore_localhost = true
  config.ignore_request do |request|
    uri = URI.parse(request.uri)
    uri.port == 9200 || # Elasticsearch requests
      uri.host[/^172\.17|localhost|^10\./] || request.uri.to_s['geckodriver']
  end
end
