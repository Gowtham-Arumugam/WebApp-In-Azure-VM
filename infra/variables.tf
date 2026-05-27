variable "azure_devops_pat" {
  description = "Personal Access Token for Azure DevOps"
  type        = string
}
variable "organization_url" {
  description = "Azure DevOps organization URL"
  type        = string

}
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
