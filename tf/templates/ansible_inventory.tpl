[monitor-relay]
${monitor_relay_hosts}

[monitor-relay:vars]
carbon_caches=${carbon_caches}
carbon_relay=${carbon_relay}

[${env}:children]
monitor-relay
