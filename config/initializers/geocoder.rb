Geocoder::Configuration.lookup = :google
# to use an API key:
#http://code.google.com/apis/maps/signup.html
#Geocoder::Configuration.api_key
# geocoding service request timeout, in seconds (default 3):
Geocoder::Configuration.timeout = 5
# use HTTPS for geocoding service connections:
Geocoder::Configuration.use_https = false
# language to use (for search queries and reverse geocoding):
Geocoder::Configuration.language = :en
Geocoder::Configuration.always_raise = [SocketError, TimeoutError]
Geocoder::Configuration.cache = $redis
