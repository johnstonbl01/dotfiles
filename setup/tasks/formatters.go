package tasks

import (
	"fmt"
	"os/exec"
	"setup/taskr"
)

func codeFormatters(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("black", false, "[formatters] ", installPythonBlack),
		taskr.NewTask("", false, "[formatters] ", installNPMFormatters),
		taskr.NewTask("", false, "[formatters] ", installBrewFormatters),
	}
}

func installPythonBlack(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		cmd := exec.Command(SHELL, "-c", "pip3 install black")
		if _, err := cmd.CombinedOutput(); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}

func installNPMFormatters(t *taskr.Task) {
	langServers := []string{
		"lua-fmt",
		"eslint_d",
		"prettier-plugin-svelte",
		"prettier",
	}

	t.Fn = func(tskr *taskr.Taskr) {
		for _, f := range langServers {
			tskr.Spinner.Message(cyan(f))
			npmInstallFmt := fmt.Sprintf("npm i -g %s", f)

			installCmd := exec.Command(SHELL, "-c", npmInstallFmt)

			if _, err := installCmd.CombinedOutput(); err != nil {
				prefix := fmt.Sprintf("%s%s", t.ErrContext, f)
				tskr.HandleTaskError(prefix, err)
			}
		}
	}
}

func installBrewFormatters(t *taskr.Task) {
	langServers := []string{
		"rust-analyzer",
	}

	t.Fn = func(tskr *taskr.Taskr) {
		for _, f := range langServers {
			tskr.Spinner.Message(cyan(f))
			brewInstallFmt := fmt.Sprintf("brew install %s --quiet", f)

			installCmd := exec.Command(SHELL, "-c", brewInstallFmt)

			if _, err := installCmd.CombinedOutput(); err != nil {
				prefix := fmt.Sprintf("%s%s", t.ErrContext, f)
				tskr.HandleTaskError(prefix, err)
			}
		}
	}
}
