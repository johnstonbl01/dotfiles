package main

import (
	"fmt"
	"os/user"
	"setup/taskr"
	"setup/tasks"

	"github.com/fatih/color"
)

// const (
// 	HOMEBREW_URL = "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
// 	TEMP_DIR     = "./temp"
// )

func main() {
	tskr := taskr.New(true)

	// askForSudoPw := func(t taskr.Task) {
	// 	t.Type = taskr.TASK
	// 	t.IgnoreSpinner = true
	// 	t.Fn = func() error {
	// 		fmt.Println("Some commands will require your sudo password. Asking for it now so that it doesn't interrup the process later.")
	// 		cmd := exec.Command("/bin/bash", "-c", "sudo -v")
	// 		time.Sleep(2 * time.Second)
	// 		fmt.Print("\033[H\033[2J")
	// 		cmd.Stdout = os.Stdout
	// 		cmd.Stderr = os.Stderr
	// 		cmd.Stdin = os.Stdin
	// 		if err := cmd.Run(); err != nil {
	// 			fmt.Printf("%s", err)
	// 			return err
	// 		}

	// 		return nil
	// 	}
	// }

	// createTempDir := func(t taskr.Task) {
	// 	t.Type = taskr.TASK
	// 	t.Fn = func() error {
	// 		time.Sleep(500 * time.Millisecond) // forced delay
	// 		if err := utils.CreateDir(TEMP_DIR); err != nil {
	// 			msg := fmt.Sprintf("%s", err)
	// 			taskr.Log.Debug(msg)

	// 			return err
	// 		}

	// 		return nil
	// 	}
	// }

	// installHomebrew := func(t *task.Task) {
	// 	fileName := fmt.Sprintf("%s/install-brew.sh", TEMP_DIR)

	// 	t.Type = task.TASK
	// 	t.Fn = func() error {
	// 		if err := utils.DownloadFile(fileName, HOMEBREW_URL); err != nil {
	// 			msg := fmt.Sprintf("%s", err)
	// 			taskr.Log.Debug(msg)

	// 			return err
	// 		}

	// 		if _, err := utils.ShellCommand("./temp/install-brew.sh", false); err != nil {
	// 			msg := fmt.Sprintf("%s", err)
	// 			taskr.Log.Debug(msg)

	// 			return err
	// 		}

	// 		return nil
	// 	}
	// }

	// prepare := func(t *task.Task) {
	// 	t.Type = task.GROUP
	// 	t.Tasks = []task.Task{
	// 		task.NewTask("Create temp dir", false, createTempDir),
	// 		task.NewTask("Install Homebrew", false, installHomebrew),
	// 	}
	// }

	// tasks := []task.Task{
	// 	task.NewTask("Get sudo pw", false, askForSudoPw),
	// 	task.NewTask("Prepare", false, prepare),
	// 	task.NewTask("Remove temp dir", true, removeTempDir),
	// }
	green := color.New(color.FgHiGreen).SprintFunc()
	currUser, _ := user.Current()

	fmt.Printf("Welcome, %s! Let's get your machine all set up 🚀\n\n", green(currUser.Name))

	tskr.Run(tasks.Tasks)
}
