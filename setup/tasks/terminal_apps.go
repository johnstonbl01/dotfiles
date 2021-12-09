package tasks

import (
	"fmt"
	"log"
	"os/exec"
	"setup/taskr"
)

func terminalApps(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("", false, brewTerminalApps),
	}
}

func brewTerminalApps(t *taskr.Task) {
	apps := []string{
		"zsh",
		"terraform",
		"neovim",
		"autojump",
		"jq",
		"ffmpeg",
		"tree",
		"zsh-autosuggestions",
		"readline",
		"ripgrep",
		"fzf",
		"bat",
		"fd",
		"awscli",
		"exercism",
		"hub",
		"tig",
		"watchman",
	}

	t.Fn = func(tskr *taskr.Taskr) error {
		for _, app := range apps {
			tskr.Spinner.Message(cyan(app))
			brewInstallApp := fmt.Sprintf("brew install %s --quiet", app)

			installCmd := exec.Command(SHELL, "-c", brewInstallApp)

			if _, err := installCmd.CombinedOutput(); err != nil {
				log.Print(err)
				// handle err
			}
		}

		return nil
	}
}
