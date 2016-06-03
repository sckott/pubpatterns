require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"

class TestElife < Test::Unit::TestCase

  def setup
    @doi = "10.7554/eLife.07404"
    @elife = MultiJson.load(File.open('src/elife.json'))
  end

  def test_elife_keys
    assert_equal(
      @elife.keys().sort(),
      ["cookies","crossref_member", "journals", "open_access", "prefixes", "publisher", "publisher_parent", "regex", "urls"]
    )
    assert_nil(@elife['urls'])
    assert_not_nil(@elife['journals'])
  end

  def test_elife_xml
    conndoi = Faraday.new(:url => 'http://api.crossref.org/works/%s' % @doi) do |f|
      f.adapter Faraday.default_adapter
    end
    issn = MultiJson.load(conndoi.get.body)['message']['ISSN'][0]

    conn = Faraday.new(:url => @elife['journals'].select { |x| x['issn'] == issn }[0]['urls']['xml'] % @doi.match(@elife['regex']).to_s) do |f|
      f.adapter Faraday.default_adapter
    end

    res = conn.get
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
  end

end
