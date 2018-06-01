require "test/unit"
require "multi_json"
require "faraday"

class TestPlos < Test::Unit::TestCase

  def setup
    @doi = "10.1371/journal.pgen.1006546"
    @plos = MultiJson.load(File.open('src/plos.json'))
  end

  def test_plos_keys
    assert_equal(
      @plos.keys().sort(),
      ["components", "cookies","crossref_member", "journals", "open_access", 
        "prefixes", "publisher", "publisher_parent", "regex", "urls", "use_crossref_links"]
    )
    assert_nil(@plos['urls'])
    assert_not_nil(@plos['journals'])
  end

  def test_plos_xml
    conndoi = Faraday.new(:url => 'http://api.crossref.org/works/%s' % @doi) do |f|
      f.adapter Faraday.default_adapter
    end
    issn = MultiJson.load(conndoi.get.body)['message']['ISSN'][0]

    conn = Faraday.new(
      :url => @plos['journals'].select { |x| x['issn'].include? issn }[0]['urls']['xml'] %
        @doi.match(@plos['journals'][0]['components']['doi']['regex']).to_s) do |f|
      f.adapter Faraday.default_adapter
    end

    res = conn.get
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
    assert_equal("application/xml", res.headers['content-type'])
  end

  def test_plos_pdf
    conndoi = Faraday.new(:url => 'http://api.crossref.org/works/%s' % @doi) do |f|
      f.adapter Faraday.default_adapter
    end
    issn = MultiJson.load(conndoi.get.body)['message']['ISSN'][0]

    conn = Faraday.new(
      :url => @plos['journals'].select { |x| x['issn'].include? issn }[0]['urls']['pdf'] %
        @doi.match(@plos['journals'][0]['components']['doi']['regex']).to_s) do |f|
      f.adapter Faraday.default_adapter
    end

    res = conn.get
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
    assert_equal("application/pdf", res.headers['content-type'])
  end

end
