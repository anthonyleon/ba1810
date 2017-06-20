base_url = "http://#{request.host_with_port}/"

xml.instruct! :xml, :version=>"1.0"
xml.tag! 'sitemapindex', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9', 'xmlns:image' => 'http://www.google.com/schemas/sitemap-image/1.1', 'xmlns:video' => 'http://www.google.com/schemas/sitemap-video/1.1' do

  xml.sitemap do
    xml.loc base_url+'part/sitemap1.xml.gz'
  end

  xml.sitemap do
    xml.loc base_url+'part/sitemap2.xml.gz'
  end

  xml.sitemap do
    xml.loc base_url+'part/sitemap3.xml.gz'
  end

  xml.sitemap do
    xml.loc base_url+'part/sitemap4.xml.gz'
  end

end