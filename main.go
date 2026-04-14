package main

import (
	"fmt"
	"net"
	"net/http"
	"os"
)

var version = "1.0"

func handler(w http.ResponseWriter, r *http.Request) {
	hostname, _ := os.Hostname()

	addrs, _ := net.InterfaceAddrs()
	ip := "nie znaleziono"
	for _, addr := range addrs {
		if ipnet, ok := addr.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
			if ipnet.IP.To4() != nil {
				ip = ipnet.IP.String()
				break
			}
		}
	}

	fmt.Fprintf(w, "<html><body>")
	fmt.Fprintf(w, "<h1>Lab 5 aplikacja</h1>")
	fmt.Fprintf(w, "<p>IP: %s</p>", ip)
	fmt.Fprintf(w, "<p>Hostname: %s</p>", hostname)
	fmt.Fprintf(w, "<p>Version: %s</p>", version)
	fmt.Fprintf(w, "</body></html>")
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}