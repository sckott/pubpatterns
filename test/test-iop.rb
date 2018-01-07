require "test/unit"
require "multi_json"
require "faraday"
require "pdf-reader"
require_relative "helpers"

class TestIop < Test::Unit::TestCase

  def setup
    @doi1 = '10.1088/2043-6262/4/3/035017'
    @doi2 = '10.1088/2050-6120/4/2/022004'
    @doi3 = '10.1088/0957-4484/27/23/235404'
    @iop = MultiJson.load(File.open('src/iop.json'))
  end

  def test_iop_keys
    assert_equal(
      @iop.keys().sort(),
      ["components", "cookies","crossref_member", "journals", "open_access", "prefixes", "publisher", "publisher_parent", "regex", "urls"]
    )
    assert_not_nil(@iop['urls'])
    assert_nil(@iop['journals'])
  end

  # def test_iop_pdf_1
  #   url = @iop['urls']['pdf'] % @doi1.match(@iop['components']['doi']['regex'])[0]

  #   conn = Faraday.new(:url => url) do |f|
  #     f.adapter Faraday.default_adapter
  #   end

  #   res = conn.get

  #   assert_equal(Faraday::Response, res.class)
  #   assert_equal(String, res.body.class)
  #   assert_equal("application/pdf", res.headers['content-type'])

  #   path = make_path("pdf")
  #   f = File.new(path, "wb")
  #   f.write(res.body)
  #   f.close()
  #   rr = PDF::Reader.new(path)

  #   assert_equal(PDF::Reader, rr.class)
  #   assert_equal(6, rr.page_count)
  #   xx = rr.page 1
  #   assert_equal(String, xx.text.class)
  # end

  # def test_iop_pdf_2
  #   url = @iop['urls']['pdf'] % @doi2.match(@iop['components']['doi']['regex'])[0]

  #   conn = Faraday.new(:url => url) do |f|
  #     f.adapter Faraday.default_adapter
  #   end

  #   res = conn.get

  #   assert_equal(Faraday::Response, res.class)
  #   assert_equal(String, res.body.class)
  #   assert_equal("application/pdf", res.headers['content-type'])

  #   path = make_path("pdf")
  #   f = File.new(path, "wb")
  #   f.write(res.body)
  #   f.close()
  #   rr = PDF::Reader.new(path)

  #   assert_equal(PDF::Reader, rr.class)
  #   assert_equal(13, rr.page_count)
  #   xx = rr.page 1
  #   assert_equal(String, xx.text.class)
  # end

  # def test_iop_pdf_3
  #   url = @iop['urls']['pdf'] % @doi3.match(@iop['components']['doi']['regex'])[0]

  #   conn = Faraday.new(:url => url) do |f|
  #     f.adapter Faraday.default_adapter
  #   end

  #   res = conn.get

  #   assert_equal(Faraday::Response, res.class)
  #   assert_equal(String, res.body.class)
  #   assert_equal("application/pdf", res.headers['content-type'])

  #   path = make_path("pdf")
  #   f = File.new(path, "wb")
  #   f.write(res.body)
  #   f.close()
  #   rr = PDF::Reader.new(path)

  #   assert_equal(PDF::Reader, rr.class)
  #   assert_equal(13, rr.page_count)
  #   xx = rr.page 1
  #   assert_equal(String, xx.text.class)
  # end


end
