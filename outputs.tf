output "droplet_ip" {
  description = "Droplet Public IP address list"
  value       = digitalocean_droplet.nethermind-client.*.ipv4_address
}

output "grafana_url" {
  description = "Grafana Public URL(s)"
  value = {
    for i, ip in digitalocean_droplet.nethermind-client.*.ipv4_address :
    i => "http://${ip}:3000"
  }
}

output "pushgateway_url" {
  description = "Pushgateway Public URL(s)"
  value = {
    for i, ip in digitalocean_droplet.nethermind-client.*.ipv4_address :
    i => "http://${ip}:9091"
  }
}

output "seq_url" {
  description = "Seq Public URL(s)"
  value = {
    for i, ip in digitalocean_droplet.nethermind-client.*.ipv4_address :
    i => "http://${ip}:5341"
  }
}
