require 'csv'
require_relative './ruby-continent/lib/continent'

PLAYER_HEIGHTS = {
    Short: [0, 180],
    Medium_1: [180, 185],
    Medium_2: [185, 190],
    Tall: [190, 9999],
}

PLAYER_AGE = {
    Young: [0, 23],
    YoungAdult: [23, 25],
    Adult: [25, 28],
    Veteran: [28, 99]
}

PLAYER_RANK = {
    Top: [1, 10],
    Med: [10, 50],
    Med2: [50, 100],
    Med3: [100, 200],
    Avg: [200, 999999],
}


def main
    rows = CSV.read("./data_copy.csv")

    rows[0] << 'winner'

    rows[1..-1].each_with_index do |row, index|
        if index < rows.count / 2
            row << 'A'
        else
            winner_data = row[0..3]
            looser_data = row[4..7]

            row[0..3] = looser_data
            row[4..7] = winner_data
            row << 'B'
        end

        row = classify_player_height(row)
        row = classify_player_origin(row)
        row = classify_player_age(row)
        row = classify_player_rank(row)
    end

    CSV.open('./data.csv', 'wb') { |csv| rows.each{|row| csv << row}}
end

def classify_player_height(row)
    PLAYER_HEIGHTS.each_key do |category|
        min, max = PLAYER_HEIGHTS[category]
        row[0] = category if row[0].class != Symbol && row[0].to_i >= min && row[0].to_i < max
        row[4] = category if row[4].class != Symbol && row[4].to_i >= min && row[4].to_i < max
    end

    row
end

def classify_player_origin(row)
    row[1] = Continent.by_alpha_3_code(row[1]).nil? ? 'other' : Continent.by_alpha_3_code(row[1])[:continent_codes][0]
    row[5] = Continent.by_alpha_3_code(row[5]).nil? ? 'other' : Continent.by_alpha_3_code(row[5])[:continent_codes][0]

    row
end

def classify_player_age(row)
    PLAYER_AGE.each_key do |category|
        min, max = PLAYER_AGE[category]
        row[2] = category if row[2].class != Symbol && row[2].to_i >= min && row[2].to_i < max
        row[6] = category if row[6].class != Symbol && row[6].to_i >= min && row[6].to_i < max
    end

    row
end

def classify_player_rank(row)
    PLAYER_RANK.each_key do |category|
        min, max = PLAYER_RANK[category]
        row[3] = category if row[3].class != Symbol && row[3].to_i >= min && row[3].to_i < max
        row[7] = category if row[7].class != Symbol && row[7].to_i >= min && row[7].to_i < max
    end

    row
end

main
