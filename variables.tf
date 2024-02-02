variable "project" {
  description = "Project"
  default     = "de-zoomcamp-413000"
}

variable "region" {
  description = "Region"
  default     = "us-central1"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default     = "US"
}

variable "bq_dataset_name" {
  description = "de-zoomcamp-413000-terra-bucket"
  #Update the below to what you want your dataset to be called
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "de-zoomcamp-413000-terra-bucket"
  default     = "de-zoomcamp-413000-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}