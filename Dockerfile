FROM defradigital/cdp-perf-test-docker:latest

# Install Custom Thread Groups plugin into the actual JMeter lib/ext
RUN apt-get update && apt-get install -y wget unzip \
 && wget https://jmeter-plugins.org/files/packages/custom-thread-groups-2.9.zip -O /tmp/ctg.zip \
 && unzip -o /tmp/ctg.zip -d /tmp/ctg_unpacked \
 && mkdir -p /opt/apache-jmeter-5.6.3/lib/ext \
 && cp /tmp/ctg_unpacked/*.jar /opt/apache-jmeter-5.6.3/lib/ext/ \
 && rm -rf /tmp/ctg.zip /tmp/ctg_unpacked \
 && apt-get remove -y wget unzip && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/perftest

COPY scenarios/ ./scenarios/
COPY entrypoint.sh .
COPY user.properties /opt/apache-jmeter-5.6.3/bin/user.properties
COPY jmeter.properties /opt/apache-jmeter-5.6.3/bin/jmeter.properties

ENV S3_ENDPOINT https://s3.eu-west-2.amazonaws.com
ENV TEST_SCENARIO Service-Manual

ENTRYPOINT [ "./entrypoint.sh" ]
