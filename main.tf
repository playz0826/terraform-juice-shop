resource "google_compute_network" "server-vpc" {  // VPC建立
  project                 = var.gcp_project
  name                    = "server-juice-shop-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "us-west1" {  // Subnet建立
  name          = "server-us-west1-subnet"
  ip_cidr_range = "192.168.10.0/24"
  region        = "us-west1"
  network       = google_compute_network.server-vpc.name
}

resource "google_compute_firewall" "ssh-https" {    // FW規則建立 (ssh 22 port, 服務 3000 port)
  name          = "server-allow-ssh-https"
  description   = "Allow anyone ssh, 3000  port to server"
  network       = google_compute_network.server-vpc.name
  direction     = "INGRESS"
  priority      = 1000
  target_tags   = ["server"]
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["22", "3000"]
  }
}

resource "google_compute_address" "juice-shop-external-ip" {  // 預定外部IP
  name = "juice-shop-ip"
  region = var.location
}

resource "google_compute_instance" "juice-shop" {   // instance建立
  name         = var.gce_name
  machine_type = "e2-medium"
  zone         = "us-west1-c"
  tags         = ["server"]
 
  boot_disk {              // 指定OS
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface { 
    subnetwork = google_compute_subnetwork.us-west1.name
    access_config {
      // 外部ip
      nat_ip = google_compute_address.juice-shop-external-ip.address
    }
  }
   metadata = {         // 安裝juice-shop
     startup-script = <<-SCRIPT
       #!/bin/bash
       curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
       sudo apt update
       sudo apt upgrade -y
       sudo apt install nodejs
       sudo apt-get install -y git
       git clone https://github.com/juice-shop/juice-shop.git --depth 1
       cd juice-shop
       npm install
       npm start &
     SCRIPT
   }
  depends_on = [google_compute_network.server-vpc] // VPC建立後才建立instance，若同時一起建立，instance會找不到該VPC而失敗
}