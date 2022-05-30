variable "key_lists" {
    type = list(string)
    default = ["key1","key2","key3"]

}

variable "secret_maps" {
    type = map(string)
    default = {
        "name1"= "value1"
        "aaa" = "111"
        "bbb" = "222"
    }
}                                                                                                                                           