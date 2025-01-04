terraform {
  backend "s3" {
    bucket = "your-unique-terraform-state-bucket-mk"
    key    = "terraform/statefile.tfstate"
    region = "us-east-1"  # Change to your region
  }
}
