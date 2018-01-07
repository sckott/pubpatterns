require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"
require 'faraday-cookie_jar'
require "faraday_middleware"
require "oga"

class TestSage < Test::Unit::TestCase

  def setup
    @doi1 = '10.1177/2374289516643541'
    @doi2 = '10.1177/2053951716631130'
    @doi3 = '10.1177/205510291665239'
    @sage = MultiJson.load(File.open('src/sage.json'))
  end

  def test_sage_keys
    assert_equal(
      @sage.keys().sort(),
      ["components", "cookies","crossref_member", "journals", "open_access", "prefixes", "publisher", "publisher_parent", "regex", "urls"]
    )
    assert_not_nil(@sage['urls'])
    assert_nil(@sage['journals'])
  end

  def test_sage_pdf1
    url = @sage['urls']['pdf'] % @doi1.match(@sage['components']['doi']['regex'])[0]
    
    ff = Faraday.new(:url => url) do |f|
      f.use FaradayMiddleware::FollowRedirects
      f.use :cookie_jar
      f.adapter :net_http
    end

    res = ff.get
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
    assert_equal(res.headers['content-type'], "application/pdf; charset=UTF-8")
  end

end
