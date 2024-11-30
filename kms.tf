resource "google_kms_key_ring" "this" {
  name     = "${local.project_alias}-keyring"
  location = "europe-west4"
}

resource "google_kms_crypto_key" "this" {
  name            = "${local.project_alias}-bucket-key"
  key_ring        = google_kms_key_ring.this.id
  rotation_period = "7776000s"
}

data "google_iam_role" "kms" {
  name = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
}

## grants access for cloud run sa to use key
resource "google_project_iam_binding" "kms" {
  project = data.google_client_config.this.project
  role    = data.google_iam_role.kms.name
  members = ["serviceAccount:${google_service_account.this.email}"]

  # allowing access to the king ring should allow access to the key
  condition {
    title       = "allow_${local.project_alias}_key_ring"
    expression  = "resource.name == '${google_kms_key_ring.this.id}'"
    description = "optional"
  }
}

## grants access for buckets to use key
data "google_storage_project_service_account" "gcs_account" {}

resource "google_kms_crypto_key_iam_binding" "binding" {
  crypto_key_id = google_kms_crypto_key.this.id
  role          = data.google_iam_role.kms.name

  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}