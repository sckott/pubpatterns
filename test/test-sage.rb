require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"
require "faraday_middleware"

class TestSage < Test::Unit::TestCase

  # def setup
  #   @doi1 = '10.1177/2374289516643541'
  #   @doi2 = '10.1177/2053951716631130'
  #   @doi3 = '10.1177/205510291665239'
  #   @sage = MultiJson.load(File.open('src/sage.json'))
  # end

  # def extract_xpath(x)
  #   html = Oga.parse_html(x)

  # end

  # def test_sage_keys
  #   assert_equal(
  #     @sage.keys().sort(),
  #     ["components", "cookies","crossref_member", "journals", "open_access", "prefixes", "publisher", "publisher_parent", "regex", "urls"]
  #   )
  #   assert_not_nil(@sage['urls'])
  #   assert_nil(@sage['journals'])
  # end

  # def test_sage_pdf1
  #   url = Faraday.new(:url => 'https://doi.org/%s' % @doi1) do |f|
  #     f.use FaradayMiddleware::FollowRedirects
  #     f.adapter :net_http
  #   end
  #   x = url.get.body
  #   html = Oga.parse_html(x)
  #   pdfurl = html.xpath("//meta[@name='citation_pdf_url']")

  #   conn = Faraday.new(
  #     :url =>
  #       @sage['journals'].select { |x| Array(x['issn']).select{ |z| !!z.match(issn) }.any? }[0]['urls']['pdf'] %
  #         @doi1.match(@sage['regex']).to_s) do |f|
  #     f.adapter Faraday.default_adapter
  #   end

  #   res = conn.get
  #   assert_equal(Faraday::Response, res.class)
  #   assert_equal(String, res.body.class)
  # end

end
