variable "gcp_project" {         // 定義GCP_PROJECT的變數
  description = "GCP Project ID" // 簡易描述該變數的說明
  type        = string           // 變數的類型
  default     = "cole-terraform" // 變數值
}

variable "gce_name" {
  description = "gce name"
  type        = string
  default     = "terraform-juice-shop"
}

variable "location" {
  type    = string
  default = "us-west1"
}
