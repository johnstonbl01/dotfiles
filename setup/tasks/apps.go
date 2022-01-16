package tasks

import (
	"fmt"
	"os/exec"
	"setup/taskr"
)

func apps(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("", false, "[apps] ", brewCasks),
	}
}

func brewCasks(t *taskr.Task) {
	apps := []string{
		"alfred",
		// "google-chrome",
		"firefox",
		"ngrok",
		"qmoji",
		"notion",
		// "1password",
		"gitkraken",
		"spotify",
		// "slack",
		"iterm2",
		"rescuetime",
		"postman",
		"docker",
		"sip",
		"bartender",
	}

	t.Fn = func(tskr *taskr.Taskr) {
		for _, app := range apps {
			tskr.Spinner.Message(cyan(app))
			brewInstallApp := fmt.Sprintf("brew install --cask %s --quiet", app)

			installCmd := exec.Command(SHELL, "-c", brewInstallApp)

			if _, err := installCmd.CombinedOutput(); err != nil {
				prefix := fmt.Sprintf("%s%s", t.ErrContext, app)
				tskr.HandleTaskError(prefix, err)
			}
		}
	}
}
