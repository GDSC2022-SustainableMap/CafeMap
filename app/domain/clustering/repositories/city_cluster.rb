# frozen_string_literal: true

module CafeMap
  # Maps over local and remote git repo infrastructure
  class CityCluster
    def initialize(city, _config = CafeMap::App.config)
      @city = city
    end

    def cluster
      db_hash = PersistCluster.new(@city).get_db
      CityCluster.delete_cluster_db(db_hash['city_en'])
      df_info = df_transformer(db_hash['info_db'], 'info')
      df_store = df_transformer(db_hash['store_db'], 'store')
      df = df_info.inner_join(df_store, on: { id: :info_id })
      k_means_runner(db_hash['city_en'], df)
      fh = JSON.parse(File.read(("app/domain/clustering/temp/#{db_hash['city_en']}_clustering_out.json")))
      fh_result = CityCluster.json_to_hash_array(fh)
      cluster_result = CafeMap::Cluster::ClusterMapper.new(fh_result).load_several
      cluster_result.each do |each_cluster|
        CafeMap::Repository::For.entity(each_cluster).create(each_cluster)
      end
    end

    # 刪除 Cluster_db 舊有的（已經 Cluster 好的）資料
    def self.delete_cluster_db(city)
      CafeMap::Database::ClusterOrm.where(city:).delete
    end

    def self.json_to_hash_array(fh)
      return_array = []
      fh.each do |key1, _value1|
        if key1 == 'id'
          fh[key1].each do |_key2, value2|
            temp = {}
            temp[key1] = value2
            return_array.append(temp)
          end
        else
          return_array.each_with_index do |element, index|
            element[key1] = fh[key1][index.to_s]
          end
        end
      end
      return_array
    end
  end

  class PersistCluster
    # city 是中文
    def initialize(city)
      @city = city
    end

    def get_db
      infos_data = CafeMap::CafeNomad::InfoMapper.new(App.config.CAFE_TOKEN).load_several
      city_en = infos_data.select { |filter| filter.address.include? @city }.sample.city
      info_from_db = CafeMap::Database::InfoOrm.where(city: city_en).all
      store_from_db = CafeMap::Database::InfoOrm.where(city: city_en).map { |x| x.store[0] }
      { 'info_db' => info_from_db, 'store_db' => store_from_db, 'city_en' => city_en }
    end
  end
end
