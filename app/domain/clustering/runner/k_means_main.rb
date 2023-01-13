# frozen_string_literal: true

require 'rover-df'

good_city_ch = %w[台北 新北 基隆 宜蘭 新竹 桃園
                  苗栗 彰化 南投 雲林 台中 嘉義 台南 高雄
                  屏東 雲林 花蓮 台東 金門 馬祖]

good_city_en = ['Hualien', 'Taipei', 'New Taipei', 'Keelung', 'Yilan', 'Hsinchu', 'Taoyuan', 'Taichung',
                'Miaoli', 'Changhua', 'Nantou', 'Yunlin', 'Chiayi', 'Tainan', 'Kaohsiung', 'Pingtung',
                'Penghu', 'Yunlin', 'Hualien', 'Taitung', 'Kinmen', 'Matsu']

def df_transformer(object, _type = 'info')
  # object is the entity use the db from InfoOrm and StoreOrm
  df = Rover::DataFrame.new({})
  colnames_array = object[0].keys
  colnames_array.each do |col|
    value_array = object.map { |data| data.method(col).call }
    df[col] = value_array
  end
  df
end

def k_means_runner(city, df_info)
  df_js = df_info.except!(:created_at, :updated_at).to_a.to_s
  File.write("app/domain/clustering/temp/#{city}_clustering_input.txt", df_js)
  sleep 3
  # Pass the string to python directly
  `python app/domain/clustering/algo/k_means.py #{city}`
end
