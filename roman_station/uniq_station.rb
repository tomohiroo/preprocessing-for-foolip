require 'csv'

station_csv = CSV.read("station.csv")
uniq_stations = station_csv.group_by { |st| [st[0], st[4]] }.map { |_, v| v[0] }

CSV.open("station_uniq.csv", "w") do |csv|
  uniq_stations.each { |s| csv << s }
end
