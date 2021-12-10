package tasks

import (
	"fmt"
	"os/exec"
	"setup/taskr"
	"time"

	"github.com/fatih/color"
)

var cyan = color.New(color.FgHiCyan).SprintFunc()

var Tasks = []taskr.Task{
	taskr.NewTask("Prompt for email address", false, "[email-prompt] ", promptForEmail),
	taskr.NewTask("Prompt for admin password", false, "", promptForAdminPassword),
	taskr.NewTask("Prerequisites", false, "", prereqs),
	taskr.NewTask("Install terminal apps", false, "", terminalApps),
	taskr.NewTask("Install apps", false, "", apps),
	taskr.NewTask("Install language servers", false, "", languageServers),
	taskr.NewTask("Install programming languages", false, "", languages),
	taskr.NewTask("Install code formatters", false, "", codeFormatters),
	taskr.NewTask("Setup dev environment", false, "", setupDevEnv),
	taskr.NewTask("Setup OS", false, "", setupOs),
	taskr.NewTask("Clean up", false, "", cleanup),
}

func promptForAdminPassword(t *taskr.Task) {
	yellow := color.New(color.FgHiYellow).SprintFunc()
	green := color.New(color.FgHiGreen).SprintFunc()

	t.Fn = func(tskr *taskr.Taskr) {
		// Reset sudo timestamp so that it prompts every time
		resetPw := exec.Command(SHELL, "-c", "sudo -k")
		resetPw.Run()

		fmt.Println(yellow("Some commands will require your sudo password. Asking for it now so that it doesn't interrup the process later."))
		cmd := exec.Command(SHELL, "-c", "sudo -v")

		if err := cmd.Run(); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		eraseStdOut(5)

		fmt.Printf("%s 👍  Here we go!\n", green("Thanks!"))

		time.Sleep(1 * time.Second)

		eraseStdOut(1)
	}
}

func promptForEmail(t *taskr.Task) {
	var email string
	prompt := "Please enter your e-mail address (this should be the one you want to use for your public key):"

	t.Fn = func(tskr *taskr.Taskr) {
		fmt.Println(prompt)
		fmt.Scanln(&email)
		fmt.Println("")

		tskr.SetEmail(email)

		time.Sleep(1 * time.Second)
	}

}
