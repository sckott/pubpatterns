require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"

class TestWorks < Test::Unit::TestCase

  def setup
    @elife_doi = "10.7554/eLife.07404"
    @plos_doi = '10.1371/journal.pone.0033693'
    @nber_doi = '10.3386/w21615'
    @peerj_doi = '10.7717/peerj.991'
    @dois = ['10.1007/12080.1874-1746','10.1007/10452.1573-5125', '10.1111/(issn)1442-9993']
  end

  def test_elife
    elife = MultiJson.load(File.open('src/elife.json'))

    conn = Faraday.new(:url => elife['urls']['xml'] % @elife_doi.match(elife['regex']).to_s) do |f|
      f.adapter Faraday.default_adapter
    end

    res = conn.get
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
  end

  # def test_nber
  #   nber = MultiJson.load(File.open('src/nber.json'))

  #   conn = Faraday.new(:url => nber['urls']['xml'] % @nber_doi.match(nber['regex']).to_s) do |f|
  #     f.adapter Faraday.default_adapter
  #   end

  #   res = conn.get
  #   assert_equal(Faraday::Response, res.class)
  #   assert_equal(String, res.body.class)
  # end

  def test_peerj
    peerj = MultiJson.load(File.open('src/peerj2.json'))

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

  # def test_plos
  #   res = Serrano.works(filter: {has_funder: true, has_full_text: true})
  #   assert_equal(Hash, res.class)
  # end
end
