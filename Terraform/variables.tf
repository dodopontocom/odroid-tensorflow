variable "virtual_machine_template" {
  type                      = "map"
  description               = "Configuration details for virtual machine template"

  default = {
    # name of the template to deploy from. empty by default
    name                    = ""
    # default connection_type to SSH
    connection_type         = "ssh"
    # username to connect to deployed virtual machines. defaults to "root"
    connection_user         = "root"
    # default password to initially connect to deployed virtual machines. empty by default
    connection_password     = ""
  }
}
