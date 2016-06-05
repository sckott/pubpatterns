require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"

class TestThieme < Test::Unit::TestCase

  def setup
    @doi1 = '10.1055/s-0042-103414'
    @doi2 = ''
    @doi3 = ''
    @doi4 = ''
    @doi5 = ''
    @thieme = MultiJson.load(File.open('src/thieme.json'))
  end

  def test_thieme_keys
    assert_equal(
      @thieme.keys().sort(),
      ["components", "cookies","crossref_member", "journals", "open_access", "prefixes", "publisher", "publisher_parent", "regex", "urls"]
    )
    assert_nil(@thieme['urls'])
    assert_not_nil(@thieme['journals'])
  end

  def test_thieme_xml
    # no xml for this publisher
    assert_nil(@thieme['journals'].collect{ |x| x['urls']['xml'] }.uniq[0])
  end

  # def test_thieme_pdf
  #   conndoi = Faraday.new(:url => 'http://api.crossref.org/works/%s' % @doi1) do |f|
  #     f.adapter Faraday.default_adapter
  #   end
  #   issn = MultiJson.load(conndoi.get.body)['message']['ISSN'][0]

  #   conn = Faraday.new(
  #     :url =>
  #       @thieme['journals'].select { |x| Array(x['issn']).select{ |z| !!z.match(issn) }.any? }[0]['urls']['xml'] %
  #         @doi.match(@thieme['journals'][0]['components']['doi']['regex']).to_s) do |f|
  #     f.adapter Faraday.default_adapter
  #   end

  #   res = conn.get
  #   assert_equal(Faraday::Response, res.class)
  #   assert_equal(String, res.body.class)
  # end

end
