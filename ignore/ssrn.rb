require "test/unit"
require "multi_json"
require "faraday"
require "faraday_middleware"
require "faraday-cookie_jar"

class TestSSRN < Test::Unit::TestCase

  def setup
    @doi = "10.2139/ssrn.460001"
    @ssrn = MultiJson.load(File.open('src/ssrn.json'))
  end

  def test_ssrn_keys
    assert_equal(
      @ssrn.keys().sort(),
      ["components", "cookies","crossref_member", "journals",
        "open_access", "prefixes", "publisher",
        "publisher_member", "publisher_parent", "regex", "urls"]
    )
    assert_not_nil(@ssrn['urls'])
    assert_nil(@ssrn['journals'])
  end

  def test_ssrn_pdf
    # scrape to get PDF URL first
    conn = Faraday.new(:url => "https://doi.org/" + @doi) do |f|
      f.use :cookie_jar
      f.use Faraday::Response::Logger,          Logger.new('faraday.log')
      f.adapter Faraday.default_adapter
      f.use FaradayMiddleware::FollowRedirects, limit: 3
    end

    res = conn.get
    res.body

    # then get pdf
    conn = Faraday.new(:url => @ssrn['urls']['pdf'] % @doi.match(@ssrn['components']['doi']['regex']).to_s) do |f|
      f.use :cookie_jar
      f.adapter Faraday.default_adapter
    end

    res = conn.get do |f|
      f.use :cookie_jar
      f.adapter Faraday.default_adapter
    end
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
  end

end

# curl -c ssrncookies.txt 'http://ssrnoa.tandfonline.com/doi/pdf/10.1080/23312041.2015.1085296'
# curl -b ssrncookies.txt 'http://ssrnoa.tandfonline.com/doi/pdf/10.1080/23312041.2015.1085296'
