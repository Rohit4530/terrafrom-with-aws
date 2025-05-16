variable "num_list" {
  type        = list(number)
  description = "Sample list of number"
  default     = [1, 2, 3, 4, 5, 6, 7, 8, 9]
}
variable "object_list" {
  type = list(object({
    firstname=string,
    lastname=string
  }))
}