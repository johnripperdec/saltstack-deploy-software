#!/bin/bash
rabbitmqctl set_policy ha-all "^" '{"ha-mode":"all"}'
rabbitmqctl stop_app
rabbitmqctl join_cluster --ram rabbit@saltmater
rabbitmqctl start_app
rabbitmqctl set_cluster_name rabbit_cluster_test
