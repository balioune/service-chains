#!/bin/bash

function clean {
    cd /vagrant; docker-compose down
    printf "Stopping karaf ...  "
    spin=('/' '-' '\' '|' '-')
    i=0
    while $HOME/sfc/sfc-karaf/target/assembly/bin/client -u karaf 'system:shutdown -f' &> /dev/null
    do
        printf "\b${spin[$i]}"
        i=$(( (( $i + 1 )) % 5 ))
        # karaf is still running, wait for effective shutdown
        sleep 5
    done
    printf "\bdone\n"
}

function start_sfc {

    echo "Download ODL"
    cd ~/
    wget https://nexus.opendaylight.org/content/repositories/opendaylight.release/org/opendaylight/integration/distribution-karaf/0.5.4-Boron-SR4/distribution-karaf-0.5.4-Boron-SR4.tar.gz
    tar -xzf distribution-karaf-0.5.4-Boron-SR4.tar.gz
    cd distribution-karaf-0.5.4-Boron-SR4
    sed -i "/^featuresBoot[ ]*=/ s/$/,odl-sfc-model,odl-sfc-provider,odl-sfc-ui,odl-sfc-openflow-renderer,odl-sfc-scf-openflow,odl-sfc-sb-rest,odl-sfc-ovs,odl-sfc-netconf/" etc/org.apache.karaf.features.cfg;
    echo "log4j.logger.org.opendaylight.sfc = DEBUG,stdout" >> etc/org.ops4j.pax.logging.cfg;
    rm -rf journal snapshots data; bin/start
    
}

function build_docker {
    cd /vagrant; docker-compose up -d
}

function start_demo {

    /sfc/sfc-demo/sfc103/setup_sfc.py
    #wait for openflow effective
    sleep 60

    docker exec -it classifier1 ovs-ofctl dump-flows -OOpenflow13 br-sfc
    docker exec -it classifier2 ovs-ofctl dump-flows -OOpenflow13 br-sfc
    docker exec -it sff1 ovs-ofctl dump-flows -OOpenflow13 br-sfc
    docker exec -it sff2 ovs-ofctl dump-flows -OOpenflow13 br-sfc

    docker exec -it classifier1 ip netns exec app wget http://192.168.2.2


    #dynamic insert & remove sf
    /sfc/sfc-demo/sfc103/update_sfc.py

    #wait for openflow effective
    sleep 60

    docker exec -it classifier1 ovs-ofctl dump-flows -OOpenflow13 br-sfc
    docker exec -it classifier2 ovs-ofctl dump-flows -OOpenflow13 br-sfc
    docker exec -it sff1 ovs-ofctl dump-flows -OOpenflow13 br-sfc
    docker exec -it sff2 ovs-ofctl dump-flows -OOpenflow13 br-sfc

    docker exec -it classifier1 ip netns exec app wget http://192.168.2.2
}


echo "SFC DEMO: Clean"
clean

echo "SFC DEMO: Start SFC"
start_sfc

echo "SFC DEMO: Build Docker"
build_docker

echo "SFC DEMO: Give some time to have all things ready"
sleep 120

echo "SFC DEMO: Start Demo"
start_demo
