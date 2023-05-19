# Variables
#clau SSH
variable "ssh_key_msaez"    { default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpJGWF4vUpSyZgsT6/uylFwecdaL4six8YOgy2PmPnJCmwwbI6jUuPy8LsWfc7paRsc976/8IxUGOxlxQ7EucMrz5NrfPhjUv6DDztEKNTFg2moSCdReNuBNqjmdSd1Z68uVmMFqSMfbLfds7c+Kib3UF/VreKDS5nKs6gjLlQhjwbWtBW8WAAX2c0kqr6UbiGhYPDF2eiGLjPa6donhYxdaFZwN0cIVMWY48WX51Ptd9qJTKvtE10ZOgkmKy3LZK56+V0IJ81UC/DWEmrS0nHU2lolY8vsYrDSftf+krpvhKbx76FulPV8ZGRyxbOaNU/OhifyjZ6WTpAOmdOyy9AgjTNvx8/UIdOQkKeaHMuxwRWT7FIECziM+TqCLChjrv+RpZvIPuLKLLoX/AS1FsZbd6zNN9sHfNTQMTRqfEjE+5OIlteK8VuMMM5t1QyZeusb8/Ouz0YDA5vMuxTUFxucwP7jm+FFcU4jZjgPsxz2WUPedqJgeUluuXmh/xpFFE= austria@austria-Lenovo-V14-ADA" }

# Prefix que rebran com a nom els recursos
variable "name"       { default = "msaez-" }

# Tipos de EC2
variable "ec2_type"       { default = "t3a.medium" }
