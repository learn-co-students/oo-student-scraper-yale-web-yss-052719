require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = Nokogiri::HTML(File.read(index_url))

    scraped_students = []
    
    html.css("div.student-card").each do |student|
      scraped_students << {
        profile_url: student.css("a").attribute("href").value,
        name: student.css("a div.card-text-container h4.student-name").text,
        location: student.css("a div.card-text-container p.student-location").text
      }
    end

    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    html = Nokogiri::HTML(File.read(profile_url))

    scraped_student = {
      profile_quote: html.css("div.vitals-text-container div.profile-quote").text,
      bio: html.css("div.description-holder p").text
    }

    html.css("div.social-icon-container a").each do |platform|
      if platform.attribute("href").value.include?("twitter")
        scraped_student[:twitter] = platform.attribute("href").value
      elsif platform.attribute("href").value.include?("linkedin")
        scraped_student[:linkedin] = platform.attribute("href").value
      elsif platform.attribute("href").value.include?("github")
        scraped_student[:github] = platform.attribute("href").value
      else
        scraped_student[:blog] = platform.attribute("href").value
      end
    end

    scraped_student
  end
end