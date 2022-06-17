
resource google_storage_bucket "Input_Bucket"{
  name = "poc-input-bucket-sandy"
  storage_class = "STANDARD"
  location = "US-CENTRAL1"
  labels = {
    "env" = "tf_env"
    "author" = "sandy"
  }
  uniform_bucket_level_access = true
}

resource google_storage_bucket "Output_Bucket"{
  name = "poc-output-bucket-sandy"
  storage_class = "STANDARD"
  location = "US-CENTRAL1"
  labels = {
    "env" = "tf_env"
    "author" = "sandy"
  }
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "picture" {
  name = "vodafone_logo"
  bucket = google_storage_bucket.Input_Bucket.name
  source = "vodafone.jpg"
}

resource "google_storage_bucket" "code_bucket" {
  name = "poc-code-sandy-bucket"
  storage_class = "STANDARD"
  location = "US-CENTRAL1"
  labels = {
    "env" = "tf_env"
    "author" = "sandy"
  }
}

resource "google_storage_bucket_object" "srccodebucket" {
  name = "index.zip"
  bucket = google_storage_bucket.code_bucket.name
  source = "index.zip"
}

resource "google_cloudfunctions_function" "code_cf_from_tf" {
  name = "cf-from-tf"
  runtime = "nodejs16"
  description = "This is my first function from terraform script."

  available_memory_mb = 128
  source_archive_bucket = google_storage_bucket.code_bucket.name
  source_archive_object = google_storage_bucket_object.srccodebucket.name
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource = google_storage_bucket.Input_Bucket.name
  }

  
  timeout               = 60
  entry_point = "helloWorldtf"
  labels = {
    "env" = "tf_env"
    "author" = "sandy"
  }

}



