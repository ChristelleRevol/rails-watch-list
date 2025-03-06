# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'uri'
require 'net/http'
require 'json'

puts 'cleaning db'
Movie.destroy_all

puts 'creating movies'

Movie.create(title: "Wonder Woman 1984", overview: "Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s", poster_url: "https://image.tmdb.org/t/p/original/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg", rating: 6.9)
Movie.create(title: "The Shawshank Redemption", overview: "Framed in the 1940s for double murder, upstanding banker Andy Dufresne begins a new life at the Shawshank prison", poster_url: "https://image.tmdb.org/t/p/original/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg", rating: 8.7)
Movie.create(title: "Titanic", overview: "101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic.", poster_url: "https://image.tmdb.org/t/p/original/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg", rating: 7.9)
Movie.create(title: "Ocean's Eight", overview: "Debbie Ocean, a criminal mastermind, gathers a crew of female thieves to pull off the heist of the century.", poster_url: "https://image.tmdb.org/t/p/original/MvYpKlpFukTivnlBhizGbkAe3v.jpg", rating: 7.0)

url = URI("https://tmdb.lewagon.com/movie/top_rated")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["accept"] = 'application/json'

response = http.request(request)
parsed = JSON.parse(response.body)

movies_array = parsed['results']

Movie.create(title: movies_array[5]['original_title'], overview: movies_array[5]['overview'], poster_url: "https://image.tmdb.org/t/p/original#{movies_array[5]['poster_path']}", rating: movies_array[5]['vote_average'])
Movie.create(title: movies_array[12]['original_title'], overview: movies_array[12]['overview'], poster_url: "https://image.tmdb.org/t/p/original#{movies_array[12]['poster_path']}", rating: movies_array[12]['vote_average'])
Movie.create(title: movies_array.last['original_title'], overview: movies_array.last['overview'], poster_url: "https://image.tmdb.org/t/p/original#{movies_array.last['poster_path']}", rating: movies_array.last['vote_average'])

puts 'done'
puts "#{Movie.count} movies created"
