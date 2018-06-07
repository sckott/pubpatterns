require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"
require "faraday_middleware"

class TestMicrobiology < Test::Unit::TestCase

  def setup
    # all OA articles, although most papers in this publisher are not OA
    @doi1 = '10.1099/ijsem.0.002809' # title: Int. journal ... this is an in press doi
    @doi11 = '10.1099/ijsem.0.002699' # title: Int. journal ...
    @doi2 = '10.1099/mic.0.000664' # title: Microbiology
    @doi3 = '10.1099/jgv.0.001056' # title: Journal of General Virology
    @doi3 = '10.1099/mgen.0.000182' # title: Microbial Genomics
    @doi3 = '10.1099/jmmcr.0.005152' # title: JMM Case Reports
    @doi3 = '10.1099/jmm.0.000647' # title: Journal of Medical Microbiology
    @microbiology = MultiJson.load(File.open('src/microbiology.json'))
  end

  def test_microbiology_keys
    assert_equal(
      @microbiology.keys().sort(),
      ["components", "cookies","crossref_member", "journals", "notes", "open_access", 
        "prefixes", "publisher", "publisher_parent", "regex", "urls", "use_crossref_links"]
    )
    assert_nil(@microbiology['urls'])
    assert_not_nil(@microbiology['journals'])
  end

  def test_microbiology_xml
    # no xml for this publisher
    assert_nil(@microbiology['journals'].collect{ |x| x['urls']['xml'] }.uniq[0])
  end

  # title: Int. journal
  def test_microbiology_pdf_int_journal
    conndoi = Faraday.new(:url => 'http://api.crossref.org/works/%s' % @doi11) do |f|
      f.adapter Faraday.default_adapter
    end
    x = MultiJson.load(conndoi.get.body);
    issn = x['message']['ISSN'][0];

    parts = [x['message']['volume'], x['message']['issue'], x['message']['page'].split('-')[0]]
    z = @doi11.match(@microbiology['journals'][0]['components']['pdf']['regex']).to_s
    parts.append(z)

    conn = Faraday.new(
      :url =>
        @microbiology['journals'].select { |x| Array(x['issn']).select{ |z| !!z.match(issn) }.any? }[0]['urls']['pdf'] % parts) do |f|
      f.use FaradayMiddleware::FollowRedirects
      f.adapter Faraday.default_adapter
    end

    res = conn.get;
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
    assert_equal("application/pdf", res.headers['content-type'])
  end

  # def test_microbiology_pdf_2
  #   conndoi = Faraday.new(:url => 'http://api.crossref.org/works/%s' % @doi2) do |f|
  #     f.adapter Faraday.default_adapter
  #   end
  #   issn = MultiJson.load(conndoi.get.body)['message']['ISSN'][0]

  #   conn = Faraday.new(
  #     :url =>
  #       @microbiology['journals'].select { |x| Array(x['issn']).select{ |z| !!z.match(issn) }.any? }[0]['urls']['pdf'] %
  #         @doi2.match(@microbiology['journals'][0]['components']['doi']['regex']).to_s) do |f|
  #     f.adapter Faraday.default_adapter
  #   end

  #   res = conn.get
  #   assert_equal(Faraday::Response, res.class)
  #   assert_equal(String, res.body.class)
  #   assert_equal("application/pdf;charset=UTF-8", res.headers['content-type'])
  # end

  # def test_microbiology_pdf_3
  #   conndoi = Faraday.new(:url => 'http://api.crossref.org/works/%s' % @doi2) do |f|
  #     f.adapter Faraday.default_adapter
  #   end
  #   issn = MultiJson.load(conndoi.get.body)['message']['ISSN'][0]

  #   conn = Faraday.new(
  #     :url =>
  #       @microbiology['journals'].select { |x| Array(x['issn']).select{ |z| !!z.match(issn) }.any? }[0]['urls']['pdf'] %
  #         @doi2.match(@microbiology['journals'][0]['components']['doi']['regex']).to_s) do |f|
  #     f.adapter Faraday.default_adapter
  #   end

  #   res = conn.get
  #   assert_equal(Faraday::Response, res.class)
  #   assert_equal(String, res.body.class)
  #   assert_equal("application/pdf;charset=UTF-8", res.headers['content-type'])
  # end

end
