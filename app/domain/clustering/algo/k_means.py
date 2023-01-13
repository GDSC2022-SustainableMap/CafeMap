import re
import json

from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
import pandas as pd

import helpers
import sys

def preprocess_input_data(citi: str, key_map: dict) -> pd.DataFrame:
    # Read the contents of the file into a string
    with open(f'app/domain/clustering/temp/{citi}_clustering_input.txt', 'r') as f:
        json_string = f.read()

    # Replace keys in the JSON string using the key map
    for old_key, new_key in key_map.items():
        json_string = re.sub(old_key, new_key, json_string)

    # Parse the modified string into a Python object using json.loads()
    obj = json.loads(json_string)
    df = pd.DataFrame(obj)

    return df

def kmeans_cluster(df, n_clusters=4):
    df_numeric = df.select_dtypes(include=['float64', 'int64'])
    
    scaler = StandardScaler()
    df_scaled = scaler.fit_transform(df_numeric)
    
    kmeans = KMeans(n_clusters=n_clusters)
    kmeans.fit(df_scaled)
    
    df['cluster'] = kmeans.labels_
    return df



if __name__ == '__main__':
    # This method can only pass string
    citi = sys.argv[1]
    key_map = helpers.KEY_MAP
    df = preprocess_input_data(citi, key_map)
    output_df = kmeans_cluster(df, n_clusters=5)
    output_df.to_json(f"app/domain/clustering/temp/{citi}_clustering_out.json")
