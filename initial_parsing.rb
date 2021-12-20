require 'csv'


# 1- Junta todos los registros
# 2- Separa tournay_id en tournay_id y anio
# 3- borra las unwanted columns

UNWANTED_COLUMNS_INDEXES_BY_NAME = {
  tourney_name: 1,
  surface: 2,
  draw_size: 3,
  tourney_level: 4,
  tourney_date: 5,
  match_num: 6,
  winner_seed: 8,
  winner_entry: 9,
  loser_seed: 19,
  loser_entry: 20,
  best_of: 29,
  round: 30,
}

def main
  headers = CSV.read("./atp_matches_2000.csv")[0]
  headers = headers.reject{ |column| UNWANTED_COLUMNS_INDEXES_BY_NAME.keys.include?(column.to_sym) }
  headers.insert(1, 'year')

  CSV.open('./parsed.csv', 'wb', headers: headers, write_headers: true) do |csv|

    (2000..2017).each do |year|
      rows = CSV.read("./atp_matches_#{year}.csv")
      rows.shift
      rows = rows.map do |row|
          row = remove_unwanted_columns(row)
          row = add_year_column(row)
          row
      end
      rows.each{|row| csv << row}
    end
  end
end

def add_year_column(row)
  match = row[0].match(/(\d\d\d\d)-(.*)/)
  row[0] = match[2]
  row.insert(1, match[1])
end

def remove_unwanted_columns(row)
  new_row = []
  row.each_with_index do |value, index|
    new_row << value unless UNWANTED_COLUMNS_INDEXES_BY_NAME.values.include?(index)
  end
  new_row
end

main
