FROM usgswma/wma-spring-boot-base:8-jre-slim

ENV artifact_version=0.0.7-SNAPSHOT
ENV serverPort=7502
ENV javaToRServiceEndpoint=https://reporting-services.nwis.usgs.gov:7500/aqcu-java-to-r/
ENV aqcuReportsWebserviceUrl=http://reporting.nwis.usgs.gov/aqcu/timeseries-ws/
ENV aquariusServiceEndpoint=http://ts.nwis.usgs.gov
ENV aquariusServiceUser=apinwisra
ENV hystrixThreadTimeout=600000
ENV hystrixMaxQueueSize=200
ENV hystrixThreadPoolSize=10
ENV simsBaseUrl=http://sims.water.usgs.gov/SIMS/StationInfo.aspx
ENV waterdataBaseUrl=http://waterdata.usgs.gov/nwis/inventory/
ENV nwisRaServiceEndpoint=https://reporting.nwis.usgs.gov/service
ENV oauthResourceId=resource-id
ENV oauthResourceTokenKeyUri=https://example.gov/oauth/token_key
ENV HEALTHY_RESPONSE_CONTAINS='{"status":{"code":"UP","description":""}'

RUN ./pull-from-artifactory.sh aqcu-maven-centralized gov.usgs.aqcu aqcu-dv-hydro-report ${artifact_version} app.jar

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -k "https://127.0.0.1:${serverPort}${serverContextPath}${HEALTH_CHECK_ENDPOINT}" | grep -q ${HEALTHY_RESPONSE_CONTAINS} || exit 1
