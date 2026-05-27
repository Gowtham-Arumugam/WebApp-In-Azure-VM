variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}
variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}
variable "vm_size" {
  description = "Size of the VM"
  type        = string
  default     = "Standard_A1_v2"
}
variable "cloudflare_api_token" {
  description = "API token for Cloudflare"
  type        = string
  sensitive   = true
}
variable "zone_ID" {
  description = "Cloudflare DNS zone ID"
  type        = string

}
