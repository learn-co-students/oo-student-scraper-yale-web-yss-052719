require 'open-uri'
require 'pry'
require 'nokogiri'

require_relative 'student'

# name:
# location:
# profile_url:


# twitter-url:
# linkedin_url:
# github_url:
# blog_url:
# profile_quote: .css(".profile_quote").text
# bio:



class Scraper

  def self.scrape_index_page(index_url)
    student_cards = Nokogiri::HTML(open(index_url)).css(".roster-cards-container .student-card")
    student_cards.map do |s|
      student_hash = {}
      student_hash[:name] = s.css(".student-name").text
      student_hash[:location] = s.css(".student-location").text
      student_hash[:profile_url] = s.css("a").attribute("href").value
      student_hash
    end
  end

  def self.scrape_profile_page(profile_url)
    profile_info = Nokogiri::HTML(open(profile_url))
    student = {}
    # pattern = /[^(https?:)][^(\/)]\w*/
    social_media = ["twitter", "linkedin", "github"]
    links = profile_info.css(".social-icon-container a").map { |link| link.attribute("href").value }
    non_media = []
    links.each do |url|
      m = social_media.find {|e| url.include?(e) }
      m ? student[m.to_sym] = url : non_media << url
      if m
        puts student[m.to_sym]
      end
    end
    non_media.empty? ? nil : student[:blog] = non_media.first
    student[:profile_quote] = profile_info.css(".profile-quote").text
    student[:bio] = profile_info.css(".bio-block .content-holder .description-holder p").text
    student
  end

end
