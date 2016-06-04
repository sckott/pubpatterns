require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"

class TestAAAS < Test::Unit::TestCase

  def setup
    @doi = '10.3897/zookeys.594.8768'
    @aaas = MultiJson.load(File.open('src/aaas.json'))
  end

  def test_aaas_keys
    assert_equal(
      @aaas.keys().sort(),
      ["components", "cookies","crossref_member", "journals", "open_access", "prefixes", "publisher", "publisher_parent", "regex", "urls"]
    )
    assert_nil(@aaas['urls'])
    assert_not_nil(@aaas['journals'])
  end

  # def test_aaas_xml
  #   conndoi = Faraday.new(:url => 'http://api.crossref.org/works/%s' % @doi) do |f|
  #     f.adapter Faraday.default_adapter
  #   end
  #   issn = MultiJson.load(conndoi.get.body)['message']['ISSN'][0]

  #   conn = Faraday.new(
  #     :url =>
  #       @aaas['journals'].select { |x| Array(x['issn']).select{ |z| !!z.match(issn) }.any? }[0]['urls']['xml'] %
  #         @doi.match(@aaas['regex']).to_s) do |f|
  #     f.adapter Faraday.default_adapter
  #   end

  #   res = conn.get
  #   assert_equal(Faraday::Response, res.class)
  #   assert_equal(String, res.body.class)
  # end

end
