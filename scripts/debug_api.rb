#!/usr/bin/env ruby
require 'jwt'
require 'net/http'
require 'json'
require 'openssl'

key_id     = ENV['APPSTORE_KEY_ID']
issuer_id  = ENV['APPSTORE_ISSUER_ID']
key_content = ENV['APPSTORE_API_KEY_CONTENT'] || ''
bundle_id  = ENV['BUNDLE_ID'] || 'com.ggsheng.UstiaGo'

if key_id.nil? || key_id.empty? || issuer_id.nil? || issuer_id.empty?
  puts "! Fatal: APPSTORE_KEY_ID or APPSTORE_ISSUER_ID not set"
  exit 1
end

puts "=== Key Info ==="
puts "Length: #{key_content.length}"
puts ""

begin
  ec_key = OpenSSL::PKey::EC.new(key_content)
  puts "Key algorithm: #{ec_key.group.curve_name}"
rescue => e
  puts "! Fatal: Cannot parse EC private key: #{e.message}"
  exit 1
end

payload = {
  iss: issuer_id,
  exp: Time.now.to_i + 600,
  aud: 'appstoreconnect-v1'
}

begin
  token = JWT.encode(payload, ec_key, 'ES256')
  puts "JWT generated successfully (#{token.length} chars)"
  puts "Prefix: #{token[0..60]}..."
rescue => e
  puts "! Fatal: JWT encoding failed: #{e.message}"
  exit 1
end

uri = URI("https://api.appstoreconnect.apple.com/v1/apps?filter[bundleId]=#{bundle_id}")
headers = {
  'Authorization' => "Bearer #{token}",
  'Content-Type'  => 'application/json'
}

puts ""
puts "=== API Call ==="
puts "GET #{uri}"

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.read_timeout = 30

begin
  request = Net::HTTP::Get.new(uri, headers)
  response = http.request(request)
  puts "HTTP #{response.code}"

  if response.code.to_i == 200
    data = JSON.parse(response.body)
    apps = data['data'] || []
    if apps.any?
      app = apps.first
      puts "App found: #{app['id']} — #{app.dig('attributes', 'name')}"
    else
      puts "! No app found for bundle ID '#{bundle_id}'"
    end
  else
    puts "! API error:"
    puts JSON.pretty_generate(JSON.parse(response.body)) rescue response.body[0..500]
  end
rescue => e
  puts "! Network error: #{e.class}: #{e.message}"
end
