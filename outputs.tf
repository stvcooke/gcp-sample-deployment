output "service_account_email" {
    value = google_service_account.this.email
}

output "url" {
    value = google_cloud_run_service.this.status.0.url
}

output "key" {
    value = google_kms_crypto_key.this.id
}

output "ring" {
    value = google_kms_key_ring.this.id
}