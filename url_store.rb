class UrlStore
  def initialize(url_file)
    @urls = read_urls_from_file(url_file)
  end

  def get_urls
    return @urls
  end

  def get_url
    return @urls[0]
  end

  def read_urls_from_file(url_file)
    urls = []
    File.open(url_file, 'r') do |file|
      file.readlines.each do |line|
        urls.push(line.chomp)
      end
    end
    return urls
  end

  private :read_urls_from_file
end
