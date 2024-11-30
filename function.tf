resource "google_cloud_run_service" "this" {
  name     = "${local.project_alias}-echoserver"
  location = "europe-west4"

  template {
    spec {
      service_account_name = google_service_account.this.email
      containers {
        image = "ealen/echo-server" # pin to version for production workloads
        ports {
          container_port = 80
        }
        startup_probe {
          initial_delay_seconds = 1
          timeout_seconds       = 1
          period_seconds        = 3
          failure_threshold     = 1
          tcp_socket {
            port = 80
          }
        }

        liveness_probe {
          http_get {
            port = 80
            path = "/"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  lifecycle {
    ignore_changes = [
      metadata.0.annotations,
      template.0.spec.0.containers.0.image
      # ignore container image in lifecycle, so it can be handled by app ci/cd
    ]
  }
}

## create service account that cloudrun will use.
## My preference is to give access to those items to this service account at those resource declarations.
resource "google_service_account" "this" {
  account_id   = local.project_alias
  display_name = "CloudRun echoserver"
  project      = data.google_client_config.this.project
}

## allow anyone to invoke endpoint
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.this.location
  project  = data.google_client_config.this.project
  service  = google_cloud_run_service.this.name

  policy_data = data.google_iam_policy.noauth.policy_data
}