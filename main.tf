resource "digitalocean_ssh_key" "key" {
  name       = "SSH Key Example for "
  public_key = file("./private.key.pub")
}

resource "digitalocean_droplet" "nethermind-client" {
  count    = var.num
  image    = "ubuntu-20-04-x64"
  name     = format("%s-%s-%02d", var.prefix, "lon1", count.index + 1)
  region   = "lon1"
  size     = var.sizeList[var.size]
  ssh_keys = [digitalocean_ssh_key.key.fingerprint]
  connection {
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
    host        = self.ipv4_address
  }

  provisioner "file" {
    source      = "./docker-compose.yml"
    destination = "/root/docker-compose.yaml"
  }

  provisioner "file" {
    source      = "./NLog.config"
    destination = "/root/NLog.config"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker docker-compose",
      "git clone https://github.com/NethermindEth/metrics-infrastructure.git",
      "cp -r metrics-infrastructure/grafana metrics-infrastructure/prometheus .",
      "export HOST=$(curl ifconfig.me)",
      "export NAME=\"Nethermind node on ${var.config}\"",
      "sed -i '10s/.*/            - NETHERMIND_CONFIG=${var.config}/' docker-compose.yaml",
      "sed -i '11s/.*/            - NETHERMIND_JSONRPCCONFIG_ENABLED=${var.rpc_enabled}/' docker-compose.yaml",
      "sed -i '36s/.*/            <target xsi:type=\"Seq\" serverUrl=\"'\"http:\\/\\/$HOST:5341\"'\" apiKey=\"Test\">/' NLog.config",
      "docker-compose up -d"
    ]
  }
}