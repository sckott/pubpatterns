require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"

class TestElife < Test::Unit::TestCase

  def setup
    @elife_doi = "10.7554/eLife.07404"
  end

  def test_elife
    elife = MultiJson.load(File.open('src/elife.json'))

    conndoi = Faraday.new(:url => 'http://api.crossref.org/works/%s' % @elife_doi) do |f|
      f.adapter Faraday.default_adapter
    end
    issn = MultiJson.load(conndoi.get.body)['message']['ISSN'][0]

    conn = Faraday.new(:url => elife['journals'].select { |x| x['issn'] == issn }[0]['urls']['xml'] % @elife_doi.match(elife['regex']).to_s) do |f|
      f.adapter Faraday.default_adapter
    end

    res = conn.get
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
  end

end
