require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"

class TestPeerj < Test::Unit::TestCase

  def setup
    @peerj_doi = '10.7717/peerj.991'
  end

  def test_peerj
    peerj = MultiJson.load(File.open('src/peerj.json'))

    conndoi = Faraday.new(:url => 'http://api.crossref.org/works/%s' % @peerj_doi) do |f|
      f.adapter Faraday.default_adapter
    end
    issn = MultiJson.load(conndoi.get.body)['message']['ISSN'][0]

    conn = Faraday.new(
      :url =>
        peerj['journals'].select { |x| x['issn'] == issn }[0]['urls']['xml'] %
          @peerj_doi.match(peerj['regex']).to_s) do |f|
      f.adapter Faraday.default_adapter
    end

    res = conn.get
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
  end

end
