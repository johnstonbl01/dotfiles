package main

import (
	"fmt"
	"os/user"
	"setup/taskr"
	"setup/tasks"

	"github.com/fatih/color"
)

func main() {
	tskr := taskr.New(true)

	green := color.New(color.FgHiGreen).SprintFunc()
	currUser, _ := user.Current()

	fmt.Printf("Welcome, %s! Let's get your machine all set up 🚀\n\n", green(currUser.Name))

	tskr.Run(tasks.Tasks)
}
