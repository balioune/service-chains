#!/bin/bash


function install_packages {
    #install java8
    echo openjdk-8-jdk installer 
    sudo apt-get update -y
    sudo apt-get install openjdk-8-jdk -y

    cat << EOF > /etc/environment
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export _JAVA_OPTIONS=-Djava.net.preferIPv4Stack=true 
EOF
    source /etc/environment
}

function download_odl {
cd ~/
wget https://nexus.opendaylight.org/content/groups/public/org/opendaylight/integration/distribution-karaf/0.5.0-Boron/distribution-karaf-0.5.0-Boron.tar.gz
tar -xzf distribution-karaf-0.5.0-Boron.tar.gz

}

function start_sfc {
    cd ~/distribution-karaf-0.5.0-Boron
    sed -i "/^featuresBoot[ ]*=/ s/$/,odl-sfc-provider,odl-sfc-core,odl-sfc-ui,odl-sfc-openflow-renderer,odl-sfc-scf-openflow,odl-sfc-sb-rest,odl-sfc-ovs,odl-sfc-netconf/" etc/org.apache.karaf.features.cfg;
    echo "log4j.logger.org.opendaylight.sfc = DEBUG,stdout" >> etc/org.ops4j.pax.logging.cfg;
    rm -rf journal snapshots; bin/karaf clean
}

echo "SFC DEMO: Packages installation" > $HOME/sfc.prog
install_packages

echo "SFC DEMO: SFC installation" > $HOME/sfc.prog
download_odl

echo "SFC DEMO: Launch SFC" > $HOME/sfc.prog
start_sfc
