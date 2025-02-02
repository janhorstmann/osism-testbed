#!/usr/bin/env bash
set -x
set -e

source /opt/configuration/scripts/include.sh

osism apply -a upgrade keystone
osism apply -a upgrade placement
osism apply -a upgrade nova
osism apply -a upgrade horizon
osism apply -a upgrade glance
osism apply -a upgrade neutron
osism apply -a upgrade cinder
osism apply -a upgrade barbican
osism apply -a upgrade designate

# In OSISM >= 7.0.0 the persistence feature in Octavia was enabled by default.
# This requires an additional database, which is only created when Octavia play
# is run in bootstrap mode first.
if [[ $MANAGER_VERSION =~ ^7\.[0-9]\.[0-9][a-z]?$ || $MANAGER_VERSION == "latest" ]]; then
    # NOTE: can be replaced by osism apply -a bootstrap octavia after the release of OSISM 7.0.0b
    osism apply octavia -e kolla_action=bootstrap
fi

osism apply -a upgrade octavia

if [[ $MANAGER_VERSION =~ ^7\.[0-9]\.[0-9][a-z]?$ || $MANAGER_VERSION == "latest" ]]; then
    osism apply -a upgrade magnum
fi
