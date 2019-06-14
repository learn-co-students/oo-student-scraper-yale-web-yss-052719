require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)

    web_page = Nokogiri::HTML(open(index_url))
    student_arr = []

    web_page.css("div.student-card").each do |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      profile_url = student.css("a").attribute("href").value
      s_info = {:name => name,
                :location => location,
                :profile_url => profile_url}
      student_arr << s_info
      end
    return student_arr
   end


   def self.scrape_profile_page(profile_url)
       web_page = Nokogiri::HTML(open(profile_url))
       students_hash = {}

       # student[:profile_quote] = page.css(".profile-quote")
       # student[:bio] = page.css("div.description-holder p")
       container = web_page.css(".social-icon-container a").collect{|icon| icon.attribute("href").value}
       container.each do |element|
         if element.include?("twitter")
           students_hash[:twitter] = element
         elsif element.include?("github")
           students_hash[:github] = element
         elsif element.include?("linkedin")
           students_hash[:linkedin] = element
         elsif element.include?(".com")
           students_hash[:blog] = element
         end
       end
       students_hash[:profile_quote] = web_page.css(".profile-quote").text
       students_hash[:bio] = web_page.css("div.description-holder p").text
       return students_hash
   end

end
