[monitor-relay]
${monitor-relay_hosts}

[monitor-relay:vars]
carbon_caches=${carbon_caches}
carbon_relay=${carbon_relay}

[graphite-db]
${graphite-db_hosts}

[${env}:children]
monitor-relay
