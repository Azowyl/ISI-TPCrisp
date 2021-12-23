require 'csv'
require_relative '../ruby-continent/lib/continent'

TOTAL_ACES = {
    1 => [0, 250],
    2 => [250, 500],
    3 => [500, 1300],
    4 => [1300, 2000],
    5 => [2000, 999999999]
}

TOTAL_DF = {
    1 => [0, 200],
    2 => [200, 400],
    3 => [400, 700],
    4 => [700, 99999]
}

RANKING_DIFF = {
    1 => [0, 20],
    2 => [20, 40],
    3 => [40, 80],
    4 => [80, 999999999]
}

AGE_DIFF = {
    1 => [0, 2],
    2 => [2, 4],
    3 => [4, 8],
    4 => [8, 40]
}

PLAYER_HEIGHTS = {
    1 =>[0, 180],
    2 => [180, 185],
    3 => [185, 190],
    4 => [190, 9999],
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
    rows = CSV.read("./parsed_recortado_con_age.csv")

    rows[0] << 'winner'

    rows[1..-1].each_with_index do |row, index|
        if index < rows.count / 2
            row << 'A'
        else
            winner_data = []
            loser_data = []
            winner_data << row[0]
            winner_data << row[1]
            winner_data << row[2]

            loser_data << row[3]
            loser_data << row[4]
            loser_data << row[5]

            winner_data << row[6]
            winner_data << row[7]

            loser_data << row[8]
            loser_data << row[9]

            winner_data << row[10]
            loser_data << row[11]
            
            row[0] = winner_data[0]
            row[1] = winner_data[1]
            row[2] = winner_data[2]

            row[3] = loser_data[0]
            row[4] = loser_data[1]
            row[5] = loser_data[2]

            row[6] = winner_data[3]
            row[7] = winner_data[4]

            row[8] = loser_data[3]
            row[9] = loser_data[4]

            row[10] = winner_data[5]
            row[11] = loser_data[5]
            
            row << 'B'
        end

        row = classify_player_height(row)
        row = classify_player_origin(row)
        row = classify_total_aces(row)
        row = classify_total_df(row)
        row = classify_ranking_diff(row)
        row = classify_age_diff(row)
        #row = classify_player_age(row)
        #row = classify_player_rank(row)
    end

    CSV.open('./data.csv', 'wb') { |csv| rows.each{|row| csv << row}}
end

def classify_total_aces(row)
    TOTAL_ACES.each_key do |category|
        min, max = TOTAL_ACES[category]
        row[6] = category if row[6].class != Symbol && row[6].to_i >= min && row[6].to_i < max
        row[8] = category if row[8].class != Symbol && row[8].to_i >= min && row[8].to_i < max
    end
    row
end

def classify_total_df(row)
    TOTAL_DF.each_key do |category|
        min, max = TOTAL_DF[category]
        row[7] = category if row[7].class != Symbol && row[7].to_i >= min && row[7].to_i < max
        row[9] = category if row[9].class != Symbol && row[9].to_i >= min && row[9].to_i < max
    end
    row
end

def classify_ranking_diff(row)
    RANKING_DIFF.each_key do |category|
        min, max = RANKING_DIFF[category]
        row[12] = category if row[12].class != Symbol && row[12].to_i >= min && row[12].to_i < max
    end
    row
end

def classify_age_diff(row)
    AGE_DIFF.each_key do |category|
        min, max = AGE_DIFF[category]
        row[13] = category if row[13].class != Symbol && row[13].to_i >= min && row[13].to_i < max
    end
    row
end

def classify_player_height(row)
    PLAYER_HEIGHTS.each_key do |category|
        min, max = PLAYER_HEIGHTS[category]
        row[1] = category if row[1].class != Symbol && row[1].to_i >= min && row[1].to_i < max
        row[4] = category if row[4].class != Symbol && row[4].to_i >= min && row[4].to_i < max
    end

    row
end

def classify_player_origin(row)
    # por valid counter
    valid_country = ['ESP', 'FRA', 'GER', 'USA', 'RUS', 'CHN', 'ARG', 'BRA', 'SVK', 'GBR', 'ITA', 'SUI', 'CRO', 'SRB', 'CZE']
     if (row[2].nil? || !(valid_country.include? row[2]))
         row[2] = 'other'
     end
     if (row[5].nil? || !(valid_country.include? row[5]))
         row[5] = 'other'
     end

    # por continente
    #row[1] = Continent.by_alpha_3_code(row[1]).nil? ? 'other' : Continent.by_alpha_3_code(row[1])[:continent_codes][0]
    #row[3] = Continent.by_alpha_3_code(row[3]).nil? ? 'other' : Continent.by_alpha_3_code(row[3])[:continent_codes][0]

    # por EU  / otro
    #row[1] = Continent.by_alpha_3_code(row[1]).nil? || Continent.by_alpha_3_code(row[1])[:continent_codes][0] != 'EU' ? 'other' : Continent.by_alpha_3_code(row[1])[:continent_codes][0]
    #row[3] = Continent.by_alpha_3_code(row[3]).nil? || Continent.by_alpha_3_code(row[3])[:continent_codes][0] != 'EU' ? 'other' : Continent.by_alpha_3_code(row[3])[:continent_codes][0]

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
