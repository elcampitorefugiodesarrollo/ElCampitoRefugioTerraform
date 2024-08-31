variable "name" {
  type = string
}

variable "image_tag" {
  type        = string
  description = "Imagen a desplegar"
}

variable "port" {
  type        = number
  description = "Puerto a exponer de la imagen"
}

variable "subnet_ids" {
  type = list(string)
}
variable "vpc_id" {
  type = string
}

variable "allowed_cidrs" {
  type = list(string)
}

variable "allowed_sgs" {
  type = list(string)
}