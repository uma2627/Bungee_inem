require 'csv'    

table = CSV.table("input/main.csv")

table.delete_if do |row|
  not row[:country].include? "USA"
end

File.open("output/filteredCountry.csv", 'w') do |f|
  f.write(table.to_csv)
end



result = {}
file = File.read('output/filteredCountry.csv')
csv = CSV.parse(file, headers: true)
csv.each do |row|
  if result[row["sku"]]
    result[row["sku"]].push row["price"]
  else
    result[row["sku"]] = [row["price"]]
  end
end

CSV.open("output/lowestPrice.csv", "w") do |csv|
  csv << ["SKU", "FIRST_MINIMUM_PRICE", "SECOND_MINIMUM_PRICE"]
  result.each do | sku, others |
    temp_array = []
    if not others.length() == 1
      for i in others
        temp = i.gsub("$", "")
        temp = temp.gsub(",", "")
        temp = temp.gsub("?", "")
        temp_array.push(temp.to_f)
      end
      csv << [sku, temp_array[0], temp_array[1]]
    end
  end
end
