# CafeMap

Overview
--
CafeMap is a web service that allows you search the coffee shop near you or the coffee shop located at targeted region.
We use 3 API to provide you a information integration platform for cafe shop.

1. Short-term usability goals
Integreted cafe nomad and the data of place api


2. API  information
* Name : Cafe nomad
* Url : https://cafenomad.tw/api/v1.2/cafes
* Description : 
Open-source Cafe platform.


* Name : place api
* Url : https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{input}&key=#{token}&language=zh-TW

* Description : 
We use the place API, which is supported by Google, to search regional cafe shop information on google map. However, due to this api is charable, we saved it in out database as cache and use vcr package to lower the request sending demand for our platform.


* Name : google map
* Url : https://developers.google.com/maps?hl=zh-tw
* Description : 

Get the users location. We will use the longitude and latitude of user to caculate the distance of the cofffee shops to recommended.


# CafeMap Web API

Web API that allows user search the local cafe store with abundant informations.

## Routes

### Root check

`GET /`

Status:

- 200: API server running (happy)

### POST
Looking for regional cafeshop.

Local:
`POST http://0.0.0.0:9090/api/v1/cafemap/random_store?city=新竹`

Heroku:
`https://cafemap-api.herokuapp.com/api/v1/cafemap/random_store?city=新竹`

Noting that the city names is limited in Traditional chinese for opensource version. Ex, 南投、新竹

Status
- 200: cafestores returned (happy)
- 404: city name or folder not found (sad)
- 500: problem may resulted from server side, kindly clear the cookie or use newest version browser (bad)

### GET
#### Regional DB check
Searching all the stored cafemap infomation in database based on english city name in taiwan. such as, hsinchu

Local:
`http://0.0.0.0:9090/api/v1/cafemap?city=hsinchu`

Heroku:
`https://cafemap-api.herokuapp.com/api/v1/cafemap?city=hsinchu`


Status

- 404: store or city-specified or folder not found on database  (sad)
- 500: server error: problems storing store  (bad)

#### Provide cluster result for cafeshop in the specific Taiwan based on different grading.

We implement k-means in python.

Local:
`http://0.0.0.0:9090/api/v1/cafemap/clusters?city=新竹`

Heroku:
`https://cafemap-api.herokuapp.com/api/v1/cafemap/clusters?city=新竹`

If there are no updates to the database, the cluster result will be cached in the frontend for at least 10 minutes. 

To make the process more reactive, we have added a progress bar to show the user the progress of the time-consuming task. To improve concurrency, the backend worker will run the clustering task using AWS Simple Queue Service (SQS). This allows the user to do other things while waiting for the task to complete.

# The secrets.yml demo as below:

---

Development:
  DB_FILENAME: db/local/dev.db
  PLACE_TOKEN: <TOKEN>
  CAFE_TOKEN: <TOKEN>
  REPOSTORE_PATH: repostore
  # Application
  API_HOST: http://localhost:9000
  force_ssl: false
  SESSION_SECRET: <SECRET>
  AWS_ACCESS_KEY_ID: <SECRET>
  AWS_SECRET_ACCESS_KEY: <SECRET>
  AWS_REGION: ap-northeast-1
  CLUSTER_QUEUE: CafeMap_Cluster_dev
  CLUSTER_QUEUE_URL: https://sqs.{Region}.amazonaws.com/{number}/CafeMap_Cluster_dev

Test:
  DB_FILENAME: db/local/test.db
  PLACE_TOKEN: <TOKEN>
  CAFE_TOKEN: <TOKEN>
  REPOSTORE_PATH: repostore
  # Application
  API_HOST: http://localhost:9000
  force_ssl: false
  SESSION_SECRET: <SECRET>
  AWS_ACCESS_KEY_ID: <SECRET>
  AWS_SECRET_ACCESS_KEY: <SECRET>
  AWS_REGION: {Region}
  CLUSTER_QUEUE: CafeMap_Cluster_test
  CLUSTER_QUEUE_URL: https://sqs.{Region}.amazonaws.com/{number}/CafeMap_Cluster_test

Production on Heroku:
  PLACE_TOKEN: <TOKEN>
  CAFE_TOKEN: <TOKEN>
  REPOSTORE_PATH: repostore
  # Application
  API_HOST: http://url.to.app
  force_ssl: false
  SESSION_SECRET: <SECRET>
  AWS_ACCESS_KEY_ID: <SECRET>
  AWS_SECRET_ACCESS_KEY: <SECRET>
  AWS_REGION: {Region}
  CLUSTER_QUEUE: CafeMap_Cluster_production
  CLUSTER_QUEUE_URL: https://sqs.{Region}.amazonaws.com/{number}/CafeMap_Cluster_production
