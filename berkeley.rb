require 'json'
require 'logger'
require 'mechanize'
require 'rubygems'
require 'sinatra/base'
require 'sinatra/json'

def term t
  lookup = {
    "fall" => 'FL',
    "spring" => 'SP',
    "summer" => 'SU'
  }
  lookup.default = 'FL'
  lookup[t]
end

def fetch_courses params

  t = term params['term']
  url = "http://osoc.berkeley.edu/OSOC/osoc?p_term=#{t}&p_list_all=Y"
  puts url

  agent = Mechanize.new
  agent.log = Logger.new 'berkeley.log'

  postlist = []

  agent.get(url) do |page|

    # Schedule.berkeley actually doesn't use real links
    # They do that to make sure we can't do scraping...
    labels = page.search('table tr td:first-child label.buttonlink')

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

    #puts "#{postlist.to_json}"

    #form = page.forms[3]
  end

  postlist

end

# http://stackoverflow.com/questions/16777850/mechanize-sinatra-conflict
class ScrapeBerkeley < Sinatra::Base
  helpers Sinatra::JSON

  # Display the Berkeley schedule for a specific semester
  get '/api/schedule' do
    params = request.env['rack.request.query_hash']
    puts params
    json :list => fetch_courses(params)
  end
end

