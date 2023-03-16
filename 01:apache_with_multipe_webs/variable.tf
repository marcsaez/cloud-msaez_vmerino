#SSH
variable "ssh_key_msaez"    { default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpJGWF4vUpSyZgsT6/uylFwecdaL4six8YOgy2PmPnJCmwwbI6jUuPy8LsWfc7paRsc976/8IxUGOxlxQ7EucMrz5NrfPhjUv6DDztEKNTFg2moSCdReNuBNqjmdSd1Z68uVmMFqSMfbLfds7c+Kib3UF/VreKDS5nKs6gjLlQhjwbWtBW8WAAX2c0kqr6UbiGhYPDF2eiGLjPa6donhYxdaFZwN0cIVMWY48WX51Ptd9qJTKvtE10ZOgkmKy3LZK56+V0IJ81UC/DWEmrS0nHU2lolY8vsYrDSftf+krpvhKbx76FulPV8ZGRyxbOaNU/OhifyjZ6WTpAOmdOyy9AgjTNvx8/UIdOQkKeaHMuxwRWT7FIECziM+TqCLChjrv+RpZvIPuLKLLoX/AS1FsZbd6zNN9sHfNTQMTRqfEjE+5OIlteK8VuMMM5t1QyZeusb8/Ouz0YDA5vMuxTUFxucwP7jm+FFcU4jZjgPsxz2WUPedqJgeUluuXmh/xpFFE= austria@austria-Lenovo-V14-ADA" }
variable "ssh_key_vmerino"    { default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDp+xZm+SM+YcaXLq/G0RBE3sn9ThR+QmtAbzRwW7lUWSAI5D1uuFUUuWyz1U1iX/rcZFu3HplrmOe7oFE1kPUp8n/+mF32/eSd2vDouNh+KVslaYCz6u1Yf8JmAmMfVxyrhBIDvkzpw/v9lYNvqwSQ2eBGPt/1jEC++OuNyAmPi+QdKKrmKeNQJgtZxcDhC7oCmYdi0vLwUtSiSBC+tYP9kBshHd7atTpnRqpArlWxA4nqZsstAMLCRG3saoxDquMzhc0nteqvHoNJSKFBBRKowv9T32a0w05o6GYUk+zFGAaYhSGMiaigEkRCmm0QCQ+3eVFCdZnMhkwUV+o7Jj/z3umW89w02HxAcJ72Tz1nynb2tzAQt7+4oExNikoga9oqI49dJlARM7uuJkLx16Rp1rD//FdIfP/Gw0pKTi3tKr4pyh7oHKD1ShoS8Yzg6EFLH2IpA4Bz9xfquWnWU7wI7oZtonwp8Zh27Co6eRGXb7f5ygTmKo4AL5M7RAxi5e8= austria@pc020"}
# OTHERS
variable "name"       { default = "msaez-vmerino-" }

# EC2
variable "ec2_type"       { default = "t2.micro" }
