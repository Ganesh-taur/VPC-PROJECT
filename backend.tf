terraform {
  backend "s3" {
    bucket = "your-unique-terraform-state-bucket"
    key    = "terraform/statefile.tfstate"
    region = "us-west-1"  # Change to your region
  }
}
