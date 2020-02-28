require "test/unit"
require "multi_json"
require "faraday"
require "pdf-reader"
require "oga"
require_relative "helpers"

class TestHindwawi < Test::Unit::TestCase

  def setup
    @doi = '10.1155/2017/4724852'
    @hindawi = MultiJson.load(File.open('src/hindawi.json'))
  end

  def test_hindawi_keys
    assert_equal(
      @hindawi.keys().sort(),
      ["components", "cookies","crossref_member", "journals", "notes", 
        "open_access", "prefixes", "publisher", "publisher_parent", 
        "regex", "urls", "use_crossref_links"]
    )
    assert_not_nil(@hindawi['urls'])
    assert_nil(@hindawi['journals'])
  end

  def test_hindawi_pdf
    conndoi = Faraday.new(:url => 'http://api.crossref.org/works/%s' % @doi) do |f|
      f.adapter Faraday.default_adapter
    end
    res = MultiJson.load(conndoi.get.body)['message']
    url = res['link'].select { |x| x['content-type'].match('pdf') }[0]['URL']

    conn = Faraday.new(:url => url) do |f|
      f.adapter Faraday.default_adapter
    end

    res = conn.get

    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
    assert_equal("application/pdf", res.headers['content-type'])

    path = make_path("pdf")
    f = File.new(path, "wb")
    f.write(res.body)
    f.close()
    rr = PDF::Reader.new(path)

    assert_equal(PDF::Reader, rr.class)
    assert_equal(17, rr.page_count)
    xx = rr.page 1
    assert_equal(String, xx.text.class)
    assert_match('Trust Mechanisms to Secure Routing in Wireless', xx.text)
  end

  def test_hindawi_xml
    conndoi = Faraday.new(:url => 'http://api.crossref.org/works/%s' % @doi) do |f|
      f.adapter Faraday.default_adapter
    end
    res = MultiJson.load(conndoi.get.body)['message']
    url = res['link'].select { |x| x['content-type'].match('xml') }[0]['URL']

    conn = Faraday.new(:url => url) do |f|
      f.adapter Faraday.default_adapter
    end

    res = conn.get

    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
    assert_equal("application/xml", res.headers['content-type'])

    xml = Oga.parse_html(res.body)

    assert_equal(Oga::XML::Document, xml.class)
    assert_equal(@doi, xml.xpath("//article-id[@pub-id-type='doi']").text)
    assert_equal("Journal of Sensors", xml.xpath("//journal-title-group/journal-title").text)
  end

end
