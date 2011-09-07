require 'net/http'
require 'uri'
require 'open-uri'
require 'rubygems'
require 'hpricot'
require 'url_utils'

class Spider
  include UrlUtils
  
  def initialize
    @already_visited = {}
  end

  def crawl_web(urls, depth=2, page_limit = 100)
    depth.times do
      next_urls = []
      urls.each do |url|
        url_object = open_url(url)
        next if url_object == nil
        url = update_url_if_redirected(url, url_object)
        parsed_url = parse_url(url_object)
        next if parsed_url == nil
        @already_visited[url]=true if @already_visited[url] == nil
        return if @already_visited.size == page_limit
        next_urls += (find_urls_on_page(parsed_url, url)-@already_visited.keys)
        next_urls.uniq!
      end
      urls = next_urls
    end
  end

  def crawl_domain(url, page_limit = 100)
    return if @already_visited.size == page_limit
    url_object = open_url(url)
    return if url_object == nil
    parsed_url = parse_url(url_object)
    return if parsed_url == nil
    @already_visited[url]=true if @already_visited[url] == nil
    page_urls = find_urls_on_page(parsed_url, url)
    page_urls.each do |page_url|
      if urls_on_same_domain?(url, page_url) and @already_visited[page_url] == nil
        crawl_domain(page_url)
      end
    end
  end

  def open_url(url)
    url_object = nil
    begin
      url_object = open(url)
    rescue
      puts "Unable to open url: " + url
    end
    return url_object
  end

  def update_url_if_redirected(url, url_object)
    if url != url_object.base_uri.to_s
      return url_object.base_uri.to_s
    end
    return url
  end

  def parse_url(url_object)
    doc = nil
    begin
      doc = Hpricot(url_object)
    rescue
      puts 'Could not parse url: ' + url_object.base_uri.to_s
    end
    puts 'Crawling url ' + url_object.base_uri.to_s
    return doc
  end

  def find_urls_on_page(parsed_url, current_url)
    urls_list = []
    parsed_url.search('a[@href]').map do |x|
      new_url = x['href'].split('#')[0]
      unless new_url == nil
        if relative?(new_url)
         new_url = make_absolute(current_url, new_url)
        end
        urls_list.push(new_url)
      end
    end
    return urls_list
  end

  private :open_url, :update_url_if_redirected, :parse_url, :find_urls_on_page
end


    

