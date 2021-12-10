package tasks

import (
	"fmt"
	"os/exec"
	"setup/taskr"
)

func terminalApps(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("", false, "[terminal-apps] ", brewTerminalApps),
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

	t.Fn = func(tskr *taskr.Taskr) {
		for _, app := range apps {
			tskr.Spinner.Message(cyan(app))
			brewInstallApp := fmt.Sprintf("brew install %s --quiet", app)

			installCmd := exec.Command(SHELL, "-c", brewInstallApp)

			if _, err := installCmd.CombinedOutput(); err != nil {
				prefix := fmt.Sprintf("%s%s", t.ErrContext, app)
				tskr.HandleTaskError(prefix, err)
			}
		}
	}
}
