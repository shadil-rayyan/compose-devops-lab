#!/bin/bash
echo "Setting up local domains..."
sudo -- sh -c "echo '127.0.0.1 jenkins.test grafana.test prometheus.test backstage.test' >> /etc/hosts"
echo "Done!"