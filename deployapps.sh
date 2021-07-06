mvn clean package -DskipTests

RESOURCE_GROUP=springcloudlab
SPRING_CLOUD_SERVICE=asclabfmiguel2
az configure --defaults \
    group=${RESOURCE_GROUP} \
    spring-cloud=${SPRING_CLOUD_SERVICE}

echo hystrix
az spring-cloud app deploy -n hystrix-turbine --jar-path ./hystrix-turbine/target/hystrix-turbine.jar --no-wait
echo gateway
az spring-cloud app deploy -n gateway --jar-path ./gateway/target/gateway-0.0.1-SNAPSHOT.jar --no-wait
echo simple-microservice
az spring-cloud app deploy -n simple-microservice --jar-path ./simple-microservice/target/simple-microservice-0.0.1-SNAPSHOT.jar --no-wait
echo spring-cloud-microservice
az spring-cloud app deploy -n spring-cloud-microservice --jar-path ./spring-cloud-microservice/target/spring-cloud-microservice-0.0.1-SNAPSHOT.jar --no-wait
echo weather-service
az spring-cloud app deploy -n weather-service --jar-path ./weather-service/target/weather-service-0.0.1-SNAPSHOT.jar --no-wait
echo city-service
az spring-cloud app deploy -n city-service --jar-path ./city-service/target/city-service-0.0.1-SNAPSHOT.jar --no-wait
echo all-cities-weather-service
az spring-cloud app deploy -n all-cities-weather-service --jar-path ./all-cities-weather-service/target/all-cities-weather-service-0.0.1-SNAPSHOT.jar --no-wait