require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"
require 'faraday-cookie_jar'

class TestCogent < Test::Unit::TestCase

  def setup
    @doi = "10.1080/23312041.2015.1085296"
    @cogent = MultiJson.load(File.open('src/cogent.json'))
  end

  def test_cogent_keys
    assert_equal(
      @cogent.keys().sort(),
      ["components", "cookies","crossref_member", "journals", "open_access", "prefixes", "publisher", "publisher_parent", "regex", "urls"]
    )
    assert_not_nil(@cogent['urls'])
    assert_nil(@cogent['journals'])
  end

  # def test_cogent_xml
  #   conn = Faraday.new(:url => @cogent['urls']['xml'] % @doi.match(@cogent['regex']).to_s) do |f|
  #     f.use :cookie_jar
  #     f.adapter Faraday.default_adapter
  #   end

  #   res = conn.get do |f|
  #     f.use :cookie_jar
  #     f.adapter Faraday.default_adapter
  #   end
  #   assert_equal(Faraday::Response, res.class)
  #   assert_equal(String, res.body.class)
  # end

end


# curl -c cogentcookies.txt 'http://cogentoa.tandfonline.com/doi/pdf/10.1080/23312041.2015.1085296'
# curl -b cogentcookies.txt 'http://cogentoa.tandfonline.com/doi/pdf/10.1080/23312041.2015.1085296'
