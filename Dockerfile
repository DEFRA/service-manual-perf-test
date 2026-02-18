# Base image (use the same image you already use)
FROM defradigital/cdp-perf-test-docker:latest

# Set the JMeter home used by the base image (adjust if your image uses a different path)
ENV JMETER_HOME=/opt/apache-jmeter-5.6.3

# Install small tools, install Plugins Manager, run the CLI installer, then install the Custom Thread Groups plugin
RUN apt-get update && apt-get install -y --no-install-recommends wget unzip \
  && PLUGINS_MANAGER_JAR=/tmp/jmeter-plugins-manager.jar \
  && wget https://jmeter-plugins.org/get/ -O ${PLUGINS_MANAGER_JAR} \
  \
  # copy the plugins manager jar into JMeter lib/ext
  && mkdir -p ${JMETER_HOME}/lib/ext \
  && cp ${PLUGINS_MANAGER_JAR} ${JMETER_HOME}/lib/ext/ \
  \
  # run the PluginManagerCMD installer class to create the CLI helper scripts
  && java -cp ${JMETER_HOME}/lib/ext/jmeter-plugins-manager.jar org.jmeterplugins.repository.PluginManagerCMDInstaller \
  \
  # Use the generated CLI to install the Custom Thread Groups plugin (jpgc-casutg)
  && ${JMETER_HOME}/bin/PluginsManagerCMD.sh install jpgc-casutg \
  \
  # cleanup
  && rm -f ${PLUGINS_MANAGER_JAR} \
  && apt-get remove -y wget unzip && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/perftest

COPY scenarios/ ./scenarios/
COPY entrypoint.sh .
COPY user.properties ${JMETER_HOME}/bin/user.properties
COPY jmeter.properties ${JMETER_HOME}/bin/jmeter.properties

ENV S3_ENDPOINT=https://s3.eu-west-2.amazonaws.com
ENV TEST_SCENARIO=Service-Manual

ENTRYPOINT [ "./entrypoint.sh" ]

