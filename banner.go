package banner

import (
	"fmt"
)

// prints the version message
const version = "v0.0.2"

func PrintVersion() {
	fmt.Printf("Current haktrailsfree version %s\n", version)
}

// Prints the Colorful banner
func PrintBanner() {
	banner := `
    _______ _______  _____ _______ _______  _______  ___   _____                    
   / _____// ___  / / ___//______//    ___)/______/ /  /  / ___/
  / /____ / /__/ / (__  )   / /  /  /\ \     / /   /  /  (__  ) 
 /______/ \___ _/  /____/  / /  /__/  \_\ __/_/__ /  /___/____/       
/_/           `           /_/            /______//______/ 

	fmt.Printf("%s\n%75s\n\n", banner, "Current haktrailsfree version "+version)
}
