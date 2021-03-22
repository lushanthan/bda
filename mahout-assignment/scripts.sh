#219357H S. Lushanthan Scripts used for the Mahout Tutorial - 22/Mar/2021

#Get Data set
wget http://files.grouplens.org/datasets/movielens/ml-1m.zip
unzip ml-1m.zip

#Verify data
ls ml-1m
head -10 ml-1m/movies.dat
head -10 ml-1m/ratings.dat
head -10 ml-1m/users.dat

#conversion
cat ml-1m/ratings.dat | sed 's/::/,/g' | cut -f1-3 -d, > ratings.csv
head -10 ratings.csv

#Put the ratings to HDFS
hadoop fs -put ratings.csv /ratings.csv
hdfs dfs -ls /
hdfs dfs -cat /ratings.csv | head

#Run the recommender
mahout recommenditembased --input /ratings.csv --output recommendations --numRecommendations 10 --outputPathForSimilarityMatrix similarity-matrix --similarityClassname SIMILARITY_COSINE sim 

#Check Results
hdfs dfs -ls
hdfs dfs -ls recommendations
hdfs dfs -cat recommendations/part-r-00000 | head

hdfs dfs -ls similarity-matrix
hdfs dfs -cat similarity-matrix/part-r-00000 | head

#Building Web Services - Installs
sudo yum install python-pip
sudo pip install twisted
sudo pip install klein
sudo pip install redis

#Start Redis server
wget http://download.redis.io/releases/redis-2.8.7.tar.gz
tar xzf redis-2.8.7.tar.gz
cd redis-2.8.7
make
./src/redis-server &

#start the web service
twistd -noy hello.py &

#Test the web service
curl localhost:8081/37
curl localhost:8081/3
curl localhost:8081/6


