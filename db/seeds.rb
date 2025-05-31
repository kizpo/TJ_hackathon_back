required 'json'

Movie.destroy_all

json_file_path = Rails.root.join('public', 'movies_info.json')
movie_data = JSON.parse(File.read(json_file_path))

movie_data.each do |title, emotions|

  raw_country = emotions["製作国"]
  region = raw_country === "日本" ? "邦画" : "洋画"
  
  Movie.create!(
    title: title.to_s,
    excitement: (emotions["ワクワク感"]).round,
    joy: (emotions["喜び"]).round,
    fear: (emotions["恐怖"]).round,
    sadness: (emotions["悲しみ"]).round,
    surprise: (emotions["驚き"]).round,
    region: region,
    format_type: emotions["種類"]
  )
  puts "Created: #{title}"
end