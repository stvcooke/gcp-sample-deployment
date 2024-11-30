output "service_account_email" {
  value = google_service_account.this.email
}

output "url" {
  value = google_cloud_run_service.this.status.0.url
}