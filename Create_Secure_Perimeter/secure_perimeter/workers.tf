################################################################
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################
variable "workers" {
  type = "list",
  default = [
    [],
    [ {name = "worker-1"} ],
    [ {name = "worker-1"}, {name = "worker-2"} ],
    [ {name = "worker-1"}, {name = "worker-2"}, {name = "worker-3"} ],
    [ {name = "worker-1"}, {name = "worker-2"}, {name = "worker-3"}, {name = "worker-4"} ],
    [ {name = "worker-1"}, {name = "worker-2"}, {name = "worker-3"}, {name = "worker-4"}, {name = "worker-5"} ],
    [ {name = "worker-1"}, {name = "worker-2"}, {name = "worker-3"}, {name = "worker-4"}, {name = "worker-5"}, {name = "worker-6"} ],
    [ {name = "worker-1"}, {name = "worker-2"}, {name = "worker-3"}, {name = "worker-4"}, {name = "worker-5"}, {name = "worker-6"}, {name = "worker-7"} ],
    [ {name = "worker-1"}, {name = "worker-2"}, {name = "worker-3"}, {name = "worker-4"}, {name = "worker-5"}, {name = "worker-6"}, {name = "worker-7"}, {name = "worker-8"} ],
    [ {name = "worker-1"}, {name = "worker-2"}, {name = "worker-3"}, {name = "worker-4"}, {name = "worker-5"}, {name = "worker-6"}, {name = "worker-7"}, {name = "worker-8"}, {name = "worker-9"} ],
    [ {name = "worker-1"}, {name = "worker-2"}, {name = "worker-3"}, {name = "worker-4"}, {name = "worker-5"}, {name = "worker-6"}, {name = "worker-7"}, {name = "worker-8"}, {name = "worker-9"}, {name = "worker-10"} ]
  ]
}
variable "num_workers" { default = 1 }
