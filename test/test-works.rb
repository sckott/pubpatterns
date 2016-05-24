require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"

class TestWorks < Test::Unit::TestCase

  def setup
    @elife_doi = "10.7554/eLife.07404"
    @plos_doi = '10.1371/journal.pone.0033693'
    @dois = ['10.1007/12080.1874-1746','10.1007/10452.1573-5125', '10.1111/(issn)1442-9993']
  end

  def test_elife
    elife = MultiJson.load(File.open('src/elife.json'))

    conn = Faraday.new(:url => elife['urls']['xml'] % @elife_doi.match(elife['regex']).to_s) do |f|
      f.adapter Faraday.default_adapter
    end

    res = con.get
    assert_equal(1, res.length)
    assert_equal(Array, res.class)
    assert_equal(Hash, res[0].class)
  end

  def test_nber
    res = Serrano.works(ids: @dois)
    assert_equal(3, res.length)
    assert_equal(Array, res.class)
    assert_equal(Hash, res[0].class)
  end

  def test_peerj
    res = Serrano.works(query: "ecology")
    assert_equal(4, res.length)
    assert_equal(Hash, res.class)
  end

  def test_plos
    res = Serrano.works(filter: {has_funder: true, has_full_text: true})
    assert_equal(Hash, res.class)
  end
end
