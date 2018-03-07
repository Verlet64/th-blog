terragrunt = {
    remote_state {
        backend = "s3"
        config {
            bucket = "tawhidhannan-infra"
            key = "${path_relative_to_include()}/terraform.tfstate"
            region = "eu-west-2"
            encrypt = true
            lock_table = "tawhidhannan-infra-locktable"
        }
    }
}