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
  loser_seed: 18,
  loser_entry: 19,
  best_of: 28,
  round: 29,
}

WINER_ID_COLUMN = 7
WINNER_AGE_COLUMN = 14
WINER_RANK_COLUMN = 15
WINER_ACES_COLUMN = 31
WINER_DF_COLUMN = 32
LOSER_ID_COLUMN = 17
LOSER_AGE_COLUMN = 24
LOSER_RANK_COLUMN = 25
LOSER_ACES_COLUMN = 40
LOSER_DF_COLUMN = 41

class PlayerData

  attr_accessor :id, :total_aces, :total_df, :matches

  def initialize(id)
    @id = id
    @total_aces = 0
    @total_df = 0
    @matches = {}
  end

  def add_winner_data(row)
    @total_aces += row[WINER_ACES_COLUMN].to_i
    @total_df += row[WINER_DF_COLUMN].to_i
    unless matches[row[LOSER_ID_COLUMN]].nil?
      matches[row[LOSER_ID_COLUMN]] += 1
    else
      matches[row[LOSER_ID_COLUMN]] = 1
    end
  end

  def add_loser_data(row)
    @total_aces += row[LOSER_ACES_COLUMN].to_i
    @total_df += row[LOSER_DF_COLUMN].to_i
    unless matches[row[WINER_ID_COLUMN]].nil?
      matches[row[WINER_ID_COLUMN]] -= 1
    else
      matches[row[WINER_ID_COLUMN]] = -1
    end
  end

end

def main
  headers = CSV.read("./atp_matches_2000.csv")[0]
  headers = headers.reject{ |column| UNWANTED_COLUMNS_INDEXES_BY_NAME.keys.include?(column.to_sym) }
  headers.insert(1, 'year')
  headers << 'winner_total_aces'
  headers << 'winner_total_df'
  headers << 'loser_total_aces'
  headers << 'loser_total_df'
  headers << 'winner_is_head'
  headers << 'loser_is_head'
  headers << 'ranking_diff'
  headers << 'age_diff'

  CSV.open('./parsed.csv', 'wb', headers: headers, write_headers: true) do |csv|

    player_data_list = {}

    (2000..2017).each do |year|
      rows = CSV.read("./atp_matches_#{year}.csv")
      rows.shift
      rows = rows.map do |row|
          row = add_complementary_data(player_data_list, row)
          row = remove_unwanted_columns(row)
          row = add_year_column(row)
          row
      end
      rows.each{|row| csv << row}
    end
  end
end

def add_complementary_data(player_data_list, row)
  winner_id = row[WINER_ID_COLUMN]
  loser_id = row[LOSER_ID_COLUMN]

  player_data_list[winner_id] ||= PlayerData.new(winner_id)
  player_data_list[loser_id] ||= PlayerData.new(loser_id)

  winner_is_head = (player_data_list[winner_id].matches[loser_id] || 0) > 0
  loser_is_head = (player_data_list[loser_id].matches[winner_id] || 0) > 0
  ranking_diff = (row[WINER_RANK_COLUMN].to_i - row[LOSER_RANK_COLUMN].to_i).abs()
  age_diff = (row[WINNER_AGE_COLUMN].to_i - row[LOSER_AGE_COLUMN].to_i).abs()

  player_data_list[winner_id].add_winner_data(row)
  player_data_list[loser_id].add_loser_data(row)

  row << player_data_list[winner_id].total_aces
  row << player_data_list[winner_id].total_df

  row << player_data_list[loser_id].total_aces
  row << player_data_list[loser_id].total_df

  row << winner_is_head
  row << loser_is_head
  row << ranking_diff
  row << age_diff
  row
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
