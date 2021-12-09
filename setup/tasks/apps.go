package tasks

import (
	"fmt"
	"log"
	"os/exec"
	"setup/taskr"
)

func apps(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("", false, brewCasks),
	}
}

func brewCasks(t *taskr.Task) {
	apps := []string{
		"alfred",
		"google-chrome",
		"firefox",
		"ngrok",
		"qmoji",
		"notion",
		"1password",
		"gitkraken",
		"spotify",
		"slack",
		"iterm2",
		"rescuetime",
		"postman",
		"docker",
		"sip",
		"bartender",
	}

	t.Fn = func(tskr *taskr.Taskr) error {
		for _, app := range apps {
			tskr.Spinner.Message(cyan(app))
			brewInstallApp := fmt.Sprintf("brew install --cask %s --quiet", app)

			installCmd := exec.Command(SHELL, "-c", brewInstallApp)

			if _, err := installCmd.CombinedOutput(); err != nil {
				log.Print(err)
				// handle err
			}
		}

		return nil
	}
}
