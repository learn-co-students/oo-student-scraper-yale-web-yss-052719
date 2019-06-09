require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index = Nokogiri::HTML(File.read(index_url))
    students = []
    index.css(".student-card").each do |student|
      students << {name: student.css(".student-name").text, 
      location: student.css(".student-location").text, 
      profile_url: student.css("a").attribute("href").value}
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(File.read(profile_url))
    student = {}
    index = 0
    profile.css(".social-icon-container a").each do |link_element|
      link = link_element.attribute("href").value
      if link.start_with?("https://twitter.com")
        student[:twitter] = link
      elsif link.start_with?("https://www.linkedin.com")
        student[:linkedin] = link
      elsif link.start_with?("https://github.com")
        student[:github] = link
      else 
        student[:blog] = link
      end
    end
    # if profile.css(".social-icon").first.attribute("src").value == "../assets/img/twitter-icon.png"
    #   student[:twitter] = profile.css(".social-icon-container a").first.attribute("href").value
    #   index = 1
    # end
    # student[:linkedin] = profile.css(".social-icon-container a")[index].attribute("href").value
    # student[:github] = profile.css(".social-icon-container a")[index + 1].attribute("href").value
    student[:profile_quote] = profile.css(".profile-quote").text
    student[:bio] = profile.css(".description-holder p").text
    student
  end

end

# Scraper.scrape_profile_page('./fixtures/student-site/students/ryan-johnson.html')
