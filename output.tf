output "gce_name" {
  value = google_compute_instance.juice-shop.name
}

output "gce_private_ip" {
  value = google_compute_instance.juice-shop.network_interface.0.network_ip
}

output "gce_public_ip" {
  value = google_compute_instance.juice-shop.network_interface[0].access_config[0].nat_ip
}