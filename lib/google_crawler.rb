## Requires Ruby 1.8.7 


if RUBY_VERSION != '1.8.7'
  puts 'This class needs ruby 1.8.7' 
  exit(state=false) 
end

require 'net/http'
require 'uri'
require 'rubygems'
require 'cgi'

require File.join( File.dirname(File.expand_path(__FILE__)), 'exec_application' )

class GoogleCrawler
  attr_accessor :data

  def initialize(search_string)

    escaped_string = CGI.escape(search_string)

    @header = {
        'Host'              => 'www.google.com',
        'User-Agent'        => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/534.54.16 (KHTML, like Gecko) Version/5.1.4 Safari/534.54.16', 
        'Accept'            => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Cache-Control'     => 'max-age=0',
        'Accept-Language'   => 'en-us',
        #'Accept-Encoding'   => 'gzip, deflate',
        'Connection'        => 'keep-alive'
      }

    get_google_response_headers = get_response('http://www.google.com', @headers ).to_hash
    cookie                      = get_google_response_headers['set-cookie'].to_s
    google_pref_id, google_nid  = cookie.split("; ")[0], cookie.split('; ')[3][/NID.*$/]

    @search_headers = @header
    
    @search_headers.update( {
                              'cookie'  => "#{google_nid}; #{google_pref_id}",
                              'Referer' => 'http://www.google.com'
                            }
                          )

    @data   = get_response("http://www.google.com/search?sclient=psy-ab&hl=en&site=&source=hp&q=#{escaped_string}&btnK=Google+Search+HTTP/1.1", @search_headers )
  end

  def get_response(url, headers)
    url           = URI.parse(url)
    get_request   = Net::HTTP::Get.new(url.request_uri, headers)

    Net::HTTP.start(url.host, url.port) { |http| http.request(get_request) }
  end

  def post_response(url, headers, form_fields)
    url           = URI.parse(url)
    post_request  = Net::HTTP::Post.new(url.path, headers)

    post_request.set_form_data( form_fields )
  end

end
