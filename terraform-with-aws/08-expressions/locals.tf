locals {
  person_firstname= [for f,l in var.object_list : {
    firstname=f,
    lastname=l
  }]

}


output "list_of_object" {
  value = local.person_firstname
}