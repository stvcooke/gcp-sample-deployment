resource "google_storage_bucket" "this" {
  name          = "${local.project_alias}-bucket"
  location      = "europe-west4"
  force_destroy = true

  public_access_prevention = "enforced"

  encryption {
    default_kms_key_name = google_kms_crypto_key.this.id
  }

  # grant permission for bucket to use key (in kms.tf)
  depends_on = [google_kms_crypto_key_iam_binding.binding]
}