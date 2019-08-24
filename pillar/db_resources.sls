databases: 
  root:
    password: "123"
  openstack:
    password: "openstack"
  nova: 
    db_name: "nova"
    username: "nova"
    password: "nova"
    service: "nova_api"
    db_sync: "nova-manage db sync"
  keystone: 
    db_name: "keystone"
    username: "keystone"
    password: "keystone"
    service: "keystone"
    db_sync: "keystone-manage db_sync"
    admin_pass: "admin"
  cinder: 
    db_name: "cinder"
    username: "cinder"
    password: "cinder"
    service: "cinder"
    db_sync: "cinder-manage db sync"
  glance: 
    db_name: "glance"
    username: "glance"
    password: "glance"
    service: "glance"
    db_sync: "glance-manage db_sync"
  neutron: 
    db_name: "neutron"
    username: "neutron"
    password: "neutron"
    neutron_host: 192.168.147.182
  compute:
    compute_host: 192.168.147.181
    
