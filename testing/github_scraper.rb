# => github_scraper.rb

#coding: utf-8
require 'wombat'

Wombat.crawl do
  base_url "http://www.github.com"
  path "/"

  headline "xpath=//h1"

  what_is "css=.column.secondary p", :html

  explore "xpath=//ul/li[2]/a" do |e|
    e.gsub(/Explore/, "LOVE")
  end

  benefits do
    first_benefit "css=.column.leftmost h3"
    second_benefit "css=.column.leftmid h3"
    third_benefit "css=.column.rightmid h3"
    fourth_benefit "css=.column.rightmost h3"
  end
end
