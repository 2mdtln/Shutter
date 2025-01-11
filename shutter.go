package main

import (
	"fmt"
	"os/exec"
	"time"
)

func main() {
	// Kapama saati (saat:dakika)
	shutdownHour := 20
	shutdownMinute := 00

	fmt.Printf("Bilgisayar %02d:%02d'de kapatılacak.\n", shutdownHour, shutdownMinute)

	// Şu anki zaman
	now := time.Now()g
	shutdownTime := time.Date(now.Year(), now.Month(), now.Day(), shutdownHour, shutdownMinute, 0, 0, now.Location())

	// Şu anki zaman ile kapatma zamanı arasındaki süre (Biraz hatalı)
	durationUntilShutdown := shutdownTime.Sub(now)

	if durationUntilShutdown > 0 {
		fmt.Printf("Kapatmaya kadar %v süre kaldı...\n", durationUntilShutdown)
		time.Sleep(durationUntilShutdown)
	} else {
		fmt.Println("Kapatma zamanı geçti!")
		return
	}

	// SH4TT3R
	cmd := exec.Command("shutdown", "/s", "/t", "0")
	err := cmd.Run()
	if err != nil {
		fmt.Printf("Kapatma komutu çalıştırılamadı: %s\n", err)
		return
	}

	fmt.Println("Bilgisayar kapatılacak...")

}
