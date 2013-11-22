require 'net/http'
require 'json'

def for_page(page_num)
  URI('http://s128.photobucket.com/component/Common-PageCollection-Album-AlbumPageCollection'+
          '?filters[album]=/albums/p168/pixelperfectevent/Cass_Ben&filters[album_content]=2'+
          "&sort=3&limit=24&page=#{page_num}&&linkerMode=false&json=1"+
          '&hash=2593b2b2d9f53eee3a2c3bebf874bfb8&_=1384041813223')
end

(1..18).each do |page_number|
  puts "On page : #{page_number}"
  JSON.parse(Net::HTTP.get(for_page(page_number)))['body']['objects'].each do |obj|
    url =  obj['fullsizeUrl']
    puts "\t Fetching: #{url}"
    `wget #{url}`
  end
end

