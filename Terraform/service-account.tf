resource "google_service_account" "odroid-tensorflow-sa" {
  account_id   = "odroid-tesorflow-sa"
  display_name = "Odroid Tensor Flow"
}

resource "google_service_account_key" "odroid-tensorflow-key" {
  service_account_id = "${google_service_account.odroid-tensorflow-sa.name}"
}