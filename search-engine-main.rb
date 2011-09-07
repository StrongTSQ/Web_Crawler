require 'spider'
require 'command_line_argument_parser'
require 'url_store'

argument_parser = CommandLineArgumentParser.new
argument_parser.parse_arguments
spider = Spider.new
url_store = UrlStore.new(argument_parser.url_file)
spider.crawl_web(url_store.get_urls, argument_parser.crawl_depth, argument_parser.page_limit) if argument_parser.crawl_type == CommandLineArgumentParser::WEB_CRAWLER
spider.crawl_domain(url_store.get_url, argument_parser.page_limit) if argument_parser.crawl_type == CommandLineArgumentParser::DOMAIN_CRAWLER