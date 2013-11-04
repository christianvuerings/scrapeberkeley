require 'rubygems'
require 'mechanize'

a = Mechanize.new
a.get('http://rubyforge.org/') do |page|
  # Click the login link
  login_page = a.click(page.link_with(:text => /Log In/))

  # Submit the login form
  my_page = login_page.form_with(:action => '/account/login.php') do |f|
    f.form_loginname  = ARGV[0]
    f.form_pw         = ARGV[1]
  end.click_button

  my_page.links.each do |link|
    text = link.text.strip
    next unless text.length > 0
    puts text
  end
end


# require 'rubygems'
# require 'mechanize'

# a = Mechanize.new { |agent|
#   agent.user_agent_alias = 'Mac Safari'
# }

# a.get('http://google.com/') do |page|
#   search_result = page.form_with(:name => 'f') do |search|
#     search.q = 'Hello world'
#   end.submit

#   search_result.links.each do |link|
#     puts link.text
#   end
# end

# require 'mechanize'
# require 'logger'

# agent = Mechanize.new
# agent.log = Logger.new "mech.log"
# agent.user_agent_alias = 'Mac Safari'

# agent.get "http://www.google.com/"

# puts agent.page.forms[0].fields

# page = agent.get "http://www.google.com/"
# puts page
# search_form = page.form_with :name => "f"
# puts search_form
# search_form.field_with(:name => "q").value = "Hello"

# search_results = agent.submit search_form
# puts search_results.body
