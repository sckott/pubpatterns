require "test/unit"
require "multi_json"
require "faraday"
require "faraday_middleware"

class TestColdSpringHarborLaboratory < Test::Unit::TestCase

  def setup
    @id = "10.1101/243303"
    @cshl = MultiJson.load(File.open('src/cold_spring_harbor_laboratory.json'))
  end

  def test_cshl_keys
    assert_equal(
      @cshl.keys().sort(),
      ["components", "cookies","crossref_member", "journals", "open_access", "prefixes", "publisher", "publisher_parent", "regex", "urls"]
    )
    assert_not_nil(@cshl['urls'])
    assert_nil(@cshl['journals'])
  end

  def test_cshl_pdf
    x = Faraday.new(:url => 'https://api.crossref.org/works/%s' % @id) do |f|
      f.adapter Faraday.default_adapter
    end
    res = MultiJson.load(x.get.body)
    dps = res['message']['posted']['date-parts'][0]
    dps[1] = sprintf('%02i', dps[1])
    dps[2] = sprintf('%02i', dps[2])

    url = @cshl['urls']['pdf'] % [
      dps,
      @id.match(@cshl['components']['doi']['regex'])[0]
    ].flatten

    conn = Faraday.new(:url => url) do |f|
      f.use FaradayMiddleware::FollowRedirects
      f.adapter :net_http
    end

    res = conn.get;
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
    assert_equal(200, res.status)
    assert_equal(res.headers['content-type'], "application/pdf")
  end

end
