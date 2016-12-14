# vagrant 1.8.1 et virtualbox 5.0.24

# Creer des boxes vagrant

vagrant box add xenial ./xenial.box
vagrant box add trusty ./trusty.box

### Installer le controlleur OpenDaylight

sudo apt-get -y install openjdk-8-jdk
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export _JAVA_OPTIONS=-Djava.net.preferIPv4Stack=true 

- wget https://nexus.opendaylight.org/content/groups/public/org/opendaylight/integration/distribution-karaf/0.5.1-Boron-SR1/distribution-karaf-0.5.1-Boron-SR1.tar.gz
- tar -xzf distribution-karaf-0.5.1-Boron-SR1.tar.gz
- cd distribution-karaf-0.5.1-Boron-SR1
- Lancer le controller OpenDaylight : ./bin/karaf
- feature:install odl-sfc-provider odl-sfc-core,odl-sfc-ui odl-sfc-openflow-renderer odl-sfc-scf-openflow,odl-sfc-sb-rest odl-sfc-ovs odl-sfc-netconf

### Installer les noeuds (SF, SFF, Classifieur ...)

- cloner le projet https://github.com/balioune/service-chains dans votre repertoire courant "cd ~/"

       git clone https://github.com/balioune/service-chains 
	   
- se connecter par ssh sur chaque noeud en root

## classifier1
      cd /sfc/setup_classifier.sh
      ./setup_classifier.sh

## classifier2
      cd /sfc/setup_classifier.sh
      ./setup_classifier.sh

## sf1
      cd /sfc/setup_sf.sh
      ./setup_sf.sh

## sff1
      cd /sfc/setup_sff.sh
      ./setup_sff.sh

## Analyser le contenu du fichier simple_sfc.py
- modifier l'adresse du contrôleur avant de lancer le script

      python simple_sfc.py
