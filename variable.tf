variable "rg_name" {
  description = "Name of storage account, if it contains illegal characters (,-_ etc) those will be truncated."
  default = "rg1"
}
variable "log_name" {
  description = "Specifies the name of the log analytics ressources. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group."
  default = "tf102042021"
}
variable "tags" {
  description = "map of tags assign to ressource"
  type= map(string)
}