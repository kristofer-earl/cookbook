name        "ebs"
description "Mounts attached EBS volumes"
maintainer  "AWS OpsWorks"
maintainer_email "devops@spiralwks.com"
license     "Apache 2.0"
version     "1.0.0"

recipe "ebs::volumes", "Mounts attached EBS volumes"
recipe "ebs::raids", "Mounts attached EBS RAIDs"
