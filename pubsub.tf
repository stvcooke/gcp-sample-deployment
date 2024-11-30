resource "google_pubsub_topic" "this" {
  name         = "${local.project_alias}-topic"
  kms_key_name = google_kms_crypto_key.this.id

  message_storage_policy {
    allowed_persistence_regions = [
      "europe-west4",
    ]
  }

  # grant permission for pubsub to use key (in kms.tf)
  depends_on = [google_kms_crypto_key_iam_binding.pubsubs]
}



# Depending on the application needs, a custom role may be required
# for permissions such as `pubsub.subscriptions.create`
data "google_iam_role" "pubsub" {
  name = "roles/pubsub.publisher"
}

## grants access for cloud run sa to use pubsub
resource "google_project_iam_binding" "pubsub" {
  project = data.google_client_config.this.project
  role    = data.google_iam_role.pubsub.name
  members = ["serviceAccount:${google_service_account.this.email}"]

  # allowing access to the pubsub service
  ## TODO: change resource.name to pubsub service
  condition {
    title       = "allow_${local.project_alias}_pubsub"
    expression  = "resource.name == '${google_pubsub_topic.this.id}'"
    description = "restrict resource usage for least privilege"
  }
}