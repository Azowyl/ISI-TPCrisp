require 'csv'
require_relative '../ruby-continent/lib/continent'

TOTAL_ACES = {
    TOO_FEW: [0, 250],
    FEW: [250, 500],
    MEDIUM: [500, 1300],
    TOO_MUCH: [1300, 2000],
    KARLOVICH: [2000, 999999999]
}

TOTAL_DF = {
    FEW: [0, 200],
    NORMAL: [200, 400],
    TOO_MUCH: [400, 700],
    AMATEUR: [700, 99999]
}

RANKING_DIFF = {
    TOO_FEW: [0, 20],
    FEW: [20, 40],
    NORMAL: [40, 80],
    TOO_MUCH: [80, 999999999]
}

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
    rows = CSV.read("./parsed_recortado.csv")

    rows[0] << 'winner'

    rows[1..-1].each_with_index do |row, index|
        if index < rows.count / 2
            row << 'A'
        else
            winner_data = []
            loser_data = []
            winner_data << row[0]
            winner_data << row[1]
            loser_data << row[2]
            loser_data << row[3]
            winner_data << row[4]
            winner_data << row[5]
            loser_data << row[6]
            loser_data << row[7]
            winner_data << row[8]
            loser_data << row[9]
            
            row[0] = winner_data[0]
            row[1] = winner_data[1]
            row[2] = loser_data[0]
            row[3] = loser_data[1]
            row[4] = winner_data[2]
            row[5] = winner_data[3]
            row[6] = loser_data[2]
            row[7] = loser_data[3]
            row[8] = winner_data[4]
            row[9] = loser_data[4]
            
            row << 'B'
        end

        row = classify_player_height(row)
        row = classify_player_origin(row)
        row = classify_total_aces(row)
        row = classify_total_df(row)
        row = classify_ranking_diff(row)
        #row = classify_player_age(row)
        #row = classify_player_rank(row)
    end

    CSV.open('./data.csv', 'wb') { |csv| rows.each{|row| csv << row}}
end

def classify_total_aces(row)
    TOTAL_ACES.each_key do |category|
        min, max = TOTAL_ACES[category]
        row[4] = category if row[4].class != Symbol && row[4].to_i >= min && row[4].to_i < max
        row[6] = category if row[6].class != Symbol && row[6].to_i >= min && row[6].to_i < max
    end
    row
end

def classify_total_df(row)
    TOTAL_DF.each_key do |category|
        min, max = TOTAL_DF[category]
        row[5] = category if row[5].class != Symbol && row[5].to_i >= min && row[5].to_i < max
        row[7] = category if row[7].class != Symbol && row[7].to_i >= min && row[7].to_i < max
    end
    row
end

def classify_ranking_diff(row)
    RANKING_DIFF.each_key do |category|
        min, max = RANKING_DIFF[category]
        row[10] = category if row[10].class != Symbol && row[10].to_i >= min && row[10].to_i < max
    end
    row
end

def classify_player_height(row)
    PLAYER_HEIGHTS.each_key do |category|
        min, max = PLAYER_HEIGHTS[category]
        row[0] = category if row[0].class != Symbol && row[0].to_i >= min && row[0].to_i < max
        row[2] = category if row[2].class != Symbol && row[2].to_i >= min && row[2].to_i < max
    end

    row
end

def classify_player_origin(row)
    # por valid counter
    valid_country = ['ESP', 'FRA', 'GER', 'USA', 'RUS', 'CHN', 'ARG', 'BRA', 'SVK', 'GBR', 'ITA', 'SUI', 'CRO', 'SRB', 'CZE']
     if (row[1].nil? || !(valid_country.include? row[1]))
         row[1] = 'other'
     end
     if (row[3].nil? || !(valid_country.include? row[3]))
         row[3] = 'other'
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
