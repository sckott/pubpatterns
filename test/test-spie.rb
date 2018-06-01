require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"
require 'faraday-cookie_jar'
require "faraday_middleware"

class TestSpie < Test::Unit::TestCase

  def setup
    @doi1 = '10.1117/12.186705' #closed - should fail
    @doi2 = '10.1117/1.JRS.11.032402' #open - should succeed
    @spie = MultiJson.load(File.open('src/spie.json'))
  end

  def test_spie_keys
    assert_equal(
      @spie.keys().sort(),
      ["components", "cookies","crossref_member", "journals", "open_access", 
        "prefixes", "publisher", "publisher_parent", "regex", "urls", "use_crossref_links"]
    )
    assert_not_nil(@spie['urls'])
    assert_nil(@spie['journals'])
  end

  def test_spie_pdf_closed
    url = @spie['urls']['pdf'] % @doi1.match(@spie['components']['doi']['regex'])[0]
    
    ff = Faraday.new(:url => url) do |f|
      f.use FaradayMiddleware::FollowRedirects
      f.use :cookie_jar
      f.adapter :net_http
    end

    res = ff.get;
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
    assert_equal(res.headers['content-type'], "text/html; charset=utf-8")
    assert_equal(200, res.status) # didn't actually succeed though
  end

  def test_spie_pdf_open
    url = @spie['urls']['pdf'] % @doi2.match(@spie['components']['doi']['regex'])[0]
    
    ff = Faraday.new(:url => url) do |f|
      f.use FaradayMiddleware::FollowRedirects
      f.use :cookie_jar
      f.adapter :net_http
    end

    res = ff.get;
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
    assert_equal(200, res.status)
    assert_equal(res.headers['content-type'], "application/pdf")
  end

end
