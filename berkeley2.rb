require 'rubygems'
require 'mechanize'
require 'logger'

url = 'http://osoc.berkeley.edu/OSOC/osoc?p_term=SP&p_list_all=Y'

agent = Mechanize.new
agent.log = Logger.new 'berkeley.log'

agent.get(url) do |page|

  # document.querySelectorAll('table tr td:first-child label.buttonlink')


  # Schedule.berkeley actually doesn't use real links
  # They do that to make sure we can't do scraping...
  labels = page.search('table tr td:first-child label.buttonlink')
  postlist = []
  regex_onclick = /\$\('#p_dept'\).val\('.*?'\)|\$\('#p_course'\).val\('.*?'\)|\$\('#p_title'\).val\('.*?'\)/
  #regex_department = /p_dept/

  labels.each do |label|

    #puts label.get_attribute('onclick').class

    onclick = label.get_attribute('onclick')
    if match = regex_onclick.match(onclick)

      department, course, title = match.captures
      puts "#{department} - #{course} - #{title}"

    end

    #puts label
  end

  form = page.forms[3]


end
