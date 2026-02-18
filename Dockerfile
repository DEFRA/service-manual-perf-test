FROM defradigital/cdp-perf-test-docker:latest

# Install Custom Thread Groups plugin
RUN wget https://jmeter-plugins.org/files/packages/custom-thread-groups-2.9.zip -O /tmp/ctg.zip \
    && unzip /tmp/ctg.zip -d /opt/apache-jmeter-5.5/lib/ext \
    && rm /tmp/ctg.zip

WORKDIR /opt/perftest

COPY scenarios/ ./scenarios/
COPY entrypoint.sh .
COPY user.properties /opt/apache-jmeter-5.5/bin/user.properties
COPY jmeter.properties /opt/apache-jmeter-5.5/bin/jmeter.properties

ENV S3_ENDPOINT https://s3.eu-west-2.amazonaws.com
ENV TEST_SCENARIO Service-Manual

ENTRYPOINT [ "./entrypoint.sh" ]
