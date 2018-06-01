require "test/unit"
require "multi_json"
require "faraday"
require "faraday_middleware"

class TestArxiv < Test::Unit::TestCase

  def setup
    @id = "1504.06224"
    @arxiv = MultiJson.load(File.open('src/arxiv.json'))
  end

  def test_arxiv_keys
    assert_equal(
      @arxiv.keys().sort(),
      ["components", "cookies", "crossref_member", "journals", "open_access", "prefixes", 
        "publisher", "publisher_parent", "regex", "urls", "use_crossref_links"]
    )
    assert_not_nil(@arxiv['urls'])
    assert_nil(@arxiv['journals'])
  end

  def test_arxiv_pdf
    url = @arxiv['urls']['pdf'] % @id.match(@arxiv['components']['doi']['regex'])[0]
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
