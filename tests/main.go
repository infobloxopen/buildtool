package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"golang.org/x/mod/semver"
)

func main() {
	fmt.Println(semver.Build("1.2.3"))

	path := os.Getenv("URL")
	if len(path) == 0 {
		path = "https://infoblox.com"
	}
	if _, err := http.Get(path); err != nil {
		log.Fatal(err)
	}
}
