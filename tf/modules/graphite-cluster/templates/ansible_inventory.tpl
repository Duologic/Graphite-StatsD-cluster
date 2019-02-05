[monitor-relay]
${monitor-relay_hosts}

[monitor-relay:vars]
carbon_caches=${carbon_caches}
carbon_relay=${carbon_relay}

[graphite-storage]
${graphite-db_hosts}

[graphite-frontend]
${graphite-frontend_hosts}

[graphite-frontend:vars]
cluster_servers=${cluster_servers}
carbon_server=${carbon_server}
postgresql_host=${postgresql_host}
postgresql_port=${postgresql_port}
postgresql_admin_user=${postgresql_admin_user}

[graphite:children]
graphite-storage
graphite-frontend

[${env}:children]
monitor-relay
graphite-storage
graphite-frontend
