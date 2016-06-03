require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"

class TestFrontiers < Test::Unit::TestCase

  def setup
    @doi = "10.3389/fmed.2015.00081"
    @frontiers = MultiJson.load(File.open('src/frontiers.json'))
  end

  def test_frontiers_keys
    assert_equal(
      @frontiers.keys().sort(),
      ["cookies","crossref_member", "journals", "open_access", "prefixes", "publisher", "publisher_parent", "regex", "urls"]
    )
    assert_nil(@frontiers['journals'])
  end

  def test_frontiers_xml
    conn = Faraday.new(:url => @frontiers['urls']['xml'] % @doi.match(@frontiers['regex']).to_s) do |f|
      f.adapter Faraday.default_adapter
    end

    res = conn.get
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
  end

end
