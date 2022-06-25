
locals {
  common_tags = {
    Owner = "Sandeep Sharma"
    Description = "POC"
  }
}

resource "google_storage_bucket" "Input_Bucket" {
  name          = var.first_bucket
  storage_class = var.storage_class
  location      = "US-CENTRAL1"
  labels = {
    "env"    = "env"
    "author" = "sandy"
  }
  uniform_bucket_level_access = true
}

output "first_bucket" {
  value = google_storage_bucket.Input_Bucket.url
}

resource "google_storage_bucket" "Output_Bucket" {
  name          = var.second_bucket
  storage_class = "STANDARD"
  location      = "US-CENTRAL1"
  labels = {
    "env"    = "env"
    "author" = "sandy"
  }
  uniform_bucket_level_access = true
}

output "second_bucket" {
  value = google_storage_bucket.Output_Bucket.url
}

resource "google_storage_bucket_object" "picture" {
  name   = "vodafone_logo"
  bucket = google_storage_bucket.Input_Bucket.name
  source = "myimage.jpg"
}

resource "google_storage_bucket" "code_bucket" {
  name          = "poc-code-sandy-bucket"
  storage_class = "STANDARD"
  location      = "US-CENTRAL1"
  labels = {
    "env"    = "env"
    "author" = "sandy"
  }
}

output "code_bucket" {
  value = google_storage_bucket.code_bucket.url
}

## Code of Event 
resource "google_storage_bucket_object" "srccodeevent" {
  name   = "readObjectPy.zip"
  bucket = google_storage_bucket.code_bucket.name
  source = "readObjectPy.zip"
}

resource "google_cloudfunctions_function" "code_cf_from_tf" {
  name        = "cf-from-tf"
  runtime     = "python39"
  description = "This is my first function from terraform script."

  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.code_bucket.name
  source_archive_object = google_storage_bucket_object.srccodeevent.name
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.Input_Bucket.name
  }

  timeout     = 360
  entry_point = "hello_gcs"
  labels = {
    "env"    = "env"
    "author" = "sandy"
  }

}

## Code for HTTP Service
resource "google_storage_bucket_object" "srccodehttp" {
  name   = "index.zip"
  bucket = google_storage_bucket.code_bucket.name
  source = "index.zip"
}

resource "google_cloudfunctions_function" "fun_from_tf" {
  name        = "fun-from-tf"
  runtime     = "nodejs14"
  description = "This is my first function from terraform script."

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.code_bucket.name
  source_archive_object = google_storage_bucket_object.srccodehttp.name

  trigger_http = true
  entry_point  = "helloWorldtf"
  labels = {
    "env"    = "env"
    "author" = "sandy"
  }


}

resource "google_cloudfunctions_function_iam_member" "allowaccess" {
  region         = google_cloudfunctions_function.fun_from_tf.region
  cloud_function = google_cloudfunctions_function.fun_from_tf.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"

}


