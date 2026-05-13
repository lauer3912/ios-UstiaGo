#!/usr/bin/env ruby
# Test API key and upload to TestFlight

require 'net/http'
require 'json'
require 'base64'
require 'time'
require 'openssl'

KEY_ID = ENV['APPSTORE_KEY_ID']
ISSUER_ID = ENV['APPSTORE_ISSUER_ID']
KEY_CONTENT = ENV['APPSTORE_API_PRIVATE_KEY']

puts "Key ID: #{KEY_ID}"
puts "Issuer ID: #{ISSUER_ID}"
puts "Key content length: #{KEY_CONTENT&.length || 'nil'}"

# Generate JWT
def generate_jwt(key_id, issuer_id, key_content)
  # Clean up key content - remove any leading/trailing whitespace
  key_clean = key_content.strip

  header = Base64.urlsafe_encode64('{"alg":"ES256","kid":"' + key_id + '"}').sub(/=*\z/, '')
  now = Time.now.to_i
  payload = Base64.urlsafe_encode64(JSON.generate({
    "iss" => issuer_id,
    "iat" => now,
    "exp" => now + 1200,
    "aud" => "appstoreconnect-v1"
  })).sub(/=*\z/, '')

  signing_input = "#{header}.#{payload}"

  key = OpenSSL::PKey::EC.new(key_clean)
  digest = OpenSSL::Digest::SHA256.new
  signature = key.dsa_sign_asn1(digest.digest(signing_input))
  sig_b64 = Base64.urlsafe_encode64(signature).sub(/=*\z/, '')

  "#{signing_input}.#{sig_b64}"
end

def api_get(path, jwt)
  uri = URI("https://api.appstoreconnect.apple.com#{path}")
  req = Net::HTTP::Get.new(uri)
  req['Authorization'] = "Bearer #{jwt}"
  res = Net::HTTP.start(uri.hostname, use_ssl: true) { |h| h.request(req) }
  res
end

jwt = generate_jwt(KEY_ID, ISSUER_ID, KEY_CONTENT)
puts "JWT generated: #{jwt[0..50]}..."

# Test API connection - get apps
response = api_get("/v1/apps?filter[bundleId]=com.ggsheng.UstiaGo", jwt)
puts "API Response: #{response.code}"
data = JSON.parse(response.body)

apps = data['data']
if apps.empty?
  puts "App com.ggsheng.UstiaGo not found"
else
  app = apps.first
  puts "App found: #{app['id']} - #{app['attributes']['name']}"

  # Get latest build
  builds_resp = api_get("/v1/apps/#{app['id']}/builds?limit=1", jwt)
  builds = JSON.parse(builds_resp.body)['data']
  if builds.empty?
    puts "No builds yet - need to upload"
  else
    build = builds.first
    puts "Latest build: #{build['attributes']['version']} (#{build['attributes']['buildNumber']})"
  end
end

puts "API connection test PASSED"