services {
  check {
    tcp = "127.0.0.1:25"
    timeout = "1s"
    interval = "60s"
  }
  connect {
    sidecar_service {}
  }
  name = "carbonio-mta"
  port = 25
}