require "test/unit"
require "multi_json"
require "faraday"
require "pdf-reader"
require_relative "helpers"

class TestHindwawi < Test::Unit::TestCase

  def setup
    @doi1 = '10.1155/2017/4724852'
    @doi2 = '10.1155/2017/1847538'
    @doi3 = '10.1155/2017/3104180'
    @hindawi = MultiJson.load(File.open('src/iop.json'))
  end

  def test_hindawi_keys
    assert_equal(
      @hindawi.keys().sort(),
      ["components", "cookies","crossref_member", "journals", "open_access", "prefixes", "publisher", "publisher_parent", "regex", "urls"]
    )
    assert_not_nil(@hindawi['urls'])
    assert_nil(@hindawi['journals'])
  end

  def test_hindawi_pdf
    conndoi = Faraday.new(:url => 'http://api.crossref.org/works/%s' % @doi1) do |f|
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
    assert_equal("application/octet-stream", res.headers['content-type'])

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
    url = @hindawi['urls']['xml'] % @doi2.match(@hindawi['components']['doi']['regex'])[0]

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
    assert_equal(13, rr.page_count)
    xx = rr.page 1
    assert_equal(String, xx.text.class)
  end

end
