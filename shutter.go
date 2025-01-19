package main

import (
	"encoding/json"
	"log"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"time"

	"golang.org/x/sys/windows/svc"
)

type shutdownService struct {
	shutdownHour   int
	shutdownMinute int
}

type Config struct {
	ShutdownTime string `json:"shutdown_time"`
}

const defaultShutdownTime = "17:40"

func loadConfig() string {
	file, err := os.Open("config.json")
	if err != nil {
		return defaultShutdownTime
	}
	defer file.Close()

	var config Config
	if json.NewDecoder(file).Decode(&config) != nil || config.ShutdownTime == "" {
		return defaultShutdownTime
	}

	return config.ShutdownTime
}

func (s *shutdownService) Execute(args []string, r <-chan svc.ChangeRequest, statusChan chan<- svc.Status) (bool, uint32) {
	const cmdsAccepted = svc.AcceptStop | svc.AcceptShutdown
	statusChan <- svc.Status{State: svc.StartPending}

	log.Println("Service is starting...")
	statusChan <- svc.Status{State: svc.Running, Accepts: cmdsAccepted}

	for {
		select {
		case changeRequest := <-r:
			switch changeRequest.Cmd {
			case svc.Interrogate:
				statusChan <- changeRequest.CurrentStatus
			case svc.Stop, svc.Shutdown:
				log.Println("Service is stopping...")
				statusChan <- svc.Status{State: svc.StopPending}
				return false, 0
			default:
				log.Printf("Unexpected control request: %v", changeRequest.Cmd)
			}
		default:
			if s.shouldShutdown() {
				exec.Command("shutdown", "/s", "/t", "0").Run()
			}
			time.Sleep(1 * time.Minute)
		}
	}
}

func (s *shutdownService) shouldShutdown() bool {
	now := time.Now()
	return now.Hour() == s.shutdownHour && now.Minute() == s.shutdownMinute
}

func main() {
	isService, err := svc.IsWindowsService()
	if err != nil {
		log.Fatalf("serviceERR: %v", err)
	}

	shutdownTime := loadConfig()
	shutdownHour, shutdownMinute := parseShutdownTime(shutdownTime)

	if isService {
		svc.Run("ShutdownService", &shutdownService{shutdownHour, shutdownMinute})
		return
	}

	log.Println("DMode: Service is not running.")
}

func parseShutdownTime(timeStr string) (int, int) {
	parts := strings.Split(timeStr, ":")
	if len(parts) != 2 {
		log.Fatalf("Invalid time format.")
	}

	hour, err := strconv.Atoi(parts[0])
	if err != nil {
		log.Fatalf("Invalid hour")
	}

	minute, err := strconv.Atoi(parts[1])
	if err != nil {
		log.Fatalf("Invalid minute")
	}

	return hour, minute
}
