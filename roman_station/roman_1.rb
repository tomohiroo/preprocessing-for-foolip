require 'csv'
require "romaji/core_ext/string"
require "zipang"
require 'mechanize'

station_csv = CSV.read("station20180330free_1.csv")
pref = CSV.read("pref.csv")
def to_romaji(kanji)
  AGENT.get(BASE_URL + kanji).search('#content p')[1].inner_text
end
def to_hiragana(kanji)
  AGENT.get(BASE_URL + kanji).search('#content p').first.inner_text
end

AGENT = Mechanize.new
BASE_URL = 'https://yomikatawa.com/kanji/'

id = 1
CSV.open("station_1.csv", "w") do |csv|
  station_csv.each do |s|
    next unless s[12].nil?
    row = []
    name = s[2].tr('０-９ａ-ｚＡ-Ｚ　', '0-9a-zA-Z ')
    row << name
    if !(name =~ /[一-龠々]/) || name =~ /[a-z]/ || name =~ /[A-Z]/ || name =~ /[0-9]/
      roman = Zipang.to_slug(name.romaji).gsub(/\-/, '')
      puts "#{id}: #{name} => #{roman}"
    else
      roman = Zipang.to_slug(to_hiragana(name).romaji).gsub(/\-/, '')
    end
    row << roman
    row << s[9]
    row << s[10]
    row << pref[s[6].to_i][0]
    csv << row
    id = id + 1
  end
end
