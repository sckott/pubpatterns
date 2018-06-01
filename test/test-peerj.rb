require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"

class TestPeerj < Test::Unit::TestCase

  def setup
    @doi = '10.7717/peerj.991'
    @peerj = MultiJson.load(File.open('src/peerj.json'))
  end

  def test_peerj_keys
    assert_equal(
      @peerj.keys().sort(),
      ["components", "cookies","crossref_member", "journals", "open_access", 
        "prefixes", "publisher", "publisher_parent", "regex", "urls", "use_crossref_links"]
    )
    assert_nil(@peerj['urls'])
    assert_not_nil(@peerj['journals'])
  end

  def test_peerj_xml
    conndoi = Faraday.new(:url => 'http://api.crossref.org/works/%s' % @doi) do |f|
      f.adapter Faraday.default_adapter
    end
    issn = MultiJson.load(conndoi.get.body)['message']['ISSN'][0]

    conn = Faraday.new(
      :url =>
        @peerj['journals'].select { |x| x['issn'] == issn }[0]['urls']['xml'] %
          @doi.match(@peerj['journals'][0]['components']['doi']['regex']).to_s) do |f|
      f.adapter Faraday.default_adapter
    end

    res = conn.get
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
  end

end
