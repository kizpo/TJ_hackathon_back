require 'json'

json_file_path = Rails.root.join('public', 'movies_emotions.json')
movie_data = JSON.parse(File.read(json_file_path))

movie_data.each do |title, emotions|
  Movie.create!(
    title: title.to_s,
    excitement: (emotions["ワクワク感"]).round,
    joy: (emotions["喜び"]).round,
    fear: (emotions["恐怖"]).round,
    sadness: (emotions["悲しみ"]).round,
    surprise: (emotions["驚き"]).round
  )
  puts "Created: #{title}"
end