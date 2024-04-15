services {
  check {
    tcp = "127.0.0.1:25"
    timeout = "1s"
    interval = "60s"
  }
  connect {
    sidecar_service {
      proxy {
        upstreams = [
          {
            destination_name   = "carbonio-clamav"
            local_bind_port    = 20000
            local_bind_address = "127.78.0.17"
          }
        ]
      }
    }
  }
  name = "carbonio-mta"
  port = 25
  tags = ["carbonio-mta-inout"]
}
