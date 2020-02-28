require "fileutils"
require "test/unit"
require "multi_json"
require "faraday"
require "faraday_middleware"

class TestMdpi < Test::Unit::TestCase

  def setup
    @doi1 = '10.3390/a7010032'
    @doi2 = '10.3390/ani4010082'
    @doi3 = '10.3390/econometrics3020240'
    @mdpi = MultiJson.load(File.open('src/mdpi.json'))
  end

  def test_mdpi_keys
    assert_equal(
      @mdpi.keys().sort(),
      ["components", "cookies","crossref_member", "journals", "open_access", 
        "prefixes", "publisher", "publisher_parent", "regex", "urls", "use_crossref_links"]
    )
    assert_not_nil(@mdpi['urls'])
    assert_nil(@mdpi['journals'])
  end

  def test_mdpi_xml_1
    conndoi = Faraday.new(:url => 'https://api.crossref.org/works/%s' % @doi1) do |f|
      f.adapter Faraday.default_adapter
    end
    bod = MultiJson.load(conndoi.get.body)
    issn = bod['message']['ISSN'][0]

    conn = Faraday.new(
      :url =>
        @mdpi['urls']['xml'] % [issn, bod['message']['volume'], bod['message']['issue'], @doi1.match(@mdpi['components']['doi']['regex']).to_s.sub!(/^[0]+/, "") ]) do |f|
      f.adapter Faraday.default_adapter
    end

    res = conn.get
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
  end

  def test_mdpi_pdf_1
    conndoi = Faraday.new(:url => 'https://api.crossref.org/works/%s' % @doi1) do |f|
      f.adapter Faraday.default_adapter
    end
    bod = MultiJson.load(conndoi.get.body)
    issn = bod['message']['ISSN'][0]

    conn = Faraday.new(
      :url =>
        @mdpi['urls']['pdf'] % [issn, bod['message']['volume'], bod['message']['issue'], @doi1.match(@mdpi['components']['doi']['regex']).to_s.sub!(/^[0]+/, "") ]) do |f|
      f.use FaradayMiddleware::FollowRedirects, limit: 3
      f.adapter Faraday.default_adapter
    end

    res = conn.get;
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
    assert_equal("application/pdf", res.headers['content-type'])
  end

  def test_mdpi_xml_2
    conndoi = Faraday.new(:url => 'https://api.crossref.org/works/%s' % @doi2) do |f|
      f.adapter Faraday.default_adapter
    end
    bod = MultiJson.load(conndoi.get.body)
    issn = bod['message']['ISSN'][0]

    conn = Faraday.new(
      :url =>
        @mdpi['urls']['xml'] % [issn, bod['message']['volume'], bod['message']['issue'], @doi2.match(@mdpi['components']['doi']['regex']).to_s.sub!(/^[0]+/, "") ]) do |f|
      f.use FaradayMiddleware::FollowRedirects, limit: 3
      f.adapter Faraday.default_adapter
    end

    res = conn.get
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
  end

  def test_mdpi_pdf_2
    conndoi = Faraday.new(:url => 'https://api.crossref.org/works/%s' % @doi2) do |f|
      f.adapter Faraday.default_adapter
    end
    bod = MultiJson.load(conndoi.get.body)
    issn = bod['message']['ISSN'][0]

    conn = Faraday.new(
      :url =>
        @mdpi['urls']['pdf'] % [issn, bod['message']['volume'], bod['message']['issue'], @doi2.match(@mdpi['components']['doi']['regex']).to_s.sub!(/^[0]+/, "") ]) do |f|
      f.use FaradayMiddleware::FollowRedirects, limit: 3
      f.adapter Faraday.default_adapter
    end

    res = conn.get
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
    assert_equal("application/pdf", res.headers['content-type'])
  end

  def test_mdpi_xml_3
    conndoi = Faraday.new(:url => 'https://api.crossref.org/works/%s' % @doi3) do |f|
      f.adapter Faraday.default_adapter
    end
    bod = MultiJson.load(conndoi.get.body)
    issn = bod['message']['ISSN'][0]

    conn = Faraday.new(
      :url =>
        @mdpi['urls']['xml'] % [issn, bod['message']['volume'], bod['message']['issue'], @doi3.match(@mdpi['components']['doi']['regex']).to_s.sub!(/^[0]+/, "") ]) do |f|
      f.adapter Faraday.default_adapter
    end

    res = conn.get
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
  end

  def test_mdpi_pdf_3
    conndoi = Faraday.new(:url => 'https://api.crossref.org/works/%s' % @doi3) do |f|
      f.adapter Faraday.default_adapter
    end
    bod = MultiJson.load(conndoi.get.body)
    issn = bod['message']['ISSN'][0]

    conn = Faraday.new(
      :url =>
        @mdpi['urls']['pdf'] % [issn, bod['message']['volume'], bod['message']['issue'], @doi3.match(@mdpi['components']['doi']['regex']).to_s.sub!(/^[0]+/, "") ]) do |f|
      f.use FaradayMiddleware::FollowRedirects, limit: 3
      f.adapter Faraday.default_adapter
    end

    res = conn.get
    assert_equal(Faraday::Response, res.class)
    assert_equal(String, res.body.class)
    assert_equal("application/pdf", res.headers['content-type'])
  end


end
