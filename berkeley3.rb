require 'json'
require 'logger'
require 'mechanize'
require 'rubygems'
require 'sinatra'

def fetch_courses

  url = 'http://osoc.berkeley.edu/OSOC/osoc?p_term=SP&p_list_all=Y'

  agent = Mechanize.new
  agent.log = Logger.new 'berkeley.log'

  agent.get(url) do |page|

    # Schedule.berkeley actually doesn't use real links
    # They do that to make sure we can't do scraping...
    labels = page.search('table tr td:first-child label.buttonlink')
    postlist = []
    regex_department = /\$\('#p_dept'\).val\('(.*?)'\)/
    regex_course = /\$\('#p_course'\).val\('(.*?)'\)/
    regex_title = /\$\('#p_title'\).val\('(.*?)'\)/

    labels.each do |label|

      department = ''
      course = ''
      title = ''

      onclick = label.get_attribute('onclick')

      if match_department = regex_department.match(onclick)
        department = match_department.captures[0]
      end

      if match_course = regex_course.match(onclick)
        course = match_course.captures[0]
      end

      if match_title = regex_title.match(onclick)
        title = match_title.captures[0]
      end

      postlist.push({
        department: department,
        course: course,
        title: title,
        })
    end

    postlist

    #puts "#{postlist.to_json}"

    #form = page.forms[3]
  end

end

get '/' do
  fetch_courses.to_json
end
