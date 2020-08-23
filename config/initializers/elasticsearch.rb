require "elasticsearch"

SearchClient = Elasticsearch::Client.new url: "https://#{ENV['ELASTICSEARCH_USER']}:#{ENV['ELASTICSEARCH_PASSWORD']}@#{ENV['ELASTICSEARCH_URL']}:443"
  
