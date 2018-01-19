package main

import (
	"net/http"
	"os"
)

func main() {
	resp, err := http.Get("http://localhost/health")

	if err != nil || resp.StatusCode != 200 {
		os.Exit(1)
	}
	os.Exit(0)
}
