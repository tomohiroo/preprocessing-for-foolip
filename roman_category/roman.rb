require 'csv'
require "romaji/core_ext/string"
require "zipang"
# puts (Zipang.to_slug "０１ＡＢひらカタ漢字カービィー".tr('０-９ａ-ｚＡ-Ｚ　', '0-9a-zA-Z ').romaji).gsub(/\-/, '')
# puts (Zipang.to_slug "中国東北料理".tr('０-９ａ-ｚＡ-Ｚ　', '0-9a-zA-Z ').romaji).gsub(/\-/, '')
# puts (Zipang.to_slug "飲茶".tr('０-９ａ-ｚＡ-Ｚ　', '0-9a-zA-Z ').romaji).gsub(/\-/, '')

category_file = CSV.read("category.csv")

CSV.open("category_roman.csv", "w") do |csv|
  category_file.each do |c|
    c << Zipang.to_slug(c[1].tr('０-９ａ-ｚＡ-Ｚ　', '0-9a-zA-Z ').romaji).gsub(/\-/, '')
    csv << c
  end
end
