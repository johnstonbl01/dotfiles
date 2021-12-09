package tasks

import (
	"fmt"
	"log"
	"os/exec"
	"setup/taskr"
)

func codeFormatters(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("black", false, installPythonBlack),
		taskr.NewTask("", false, installNPMFormatters),
		taskr.NewTask("", false, installBrewFormatters),
	}
}

func installPythonBlack(t *taskr.Task) {
	t.Fn = func(_ *taskr.Taskr) error {
		cmd := exec.Command(SHELL, "-c", "pip3 install black")
		if _, err := cmd.CombinedOutput(); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}

func installNPMFormatters(t *taskr.Task) {
	langServers := []string{
		"lua-fmt",
		"eslint_d",
		"prettier-plugin-svelte",
		"prettier",
	}

	t.Fn = func(tskr *taskr.Taskr) error {
		for _, ls := range langServers {
			tskr.Spinner.Message(cyan(ls))
			npmInstallLs := fmt.Sprintf("npm i -g %s", ls)

			installCmd := exec.Command(SHELL, "-c", npmInstallLs)

			if _, err := installCmd.CombinedOutput(); err != nil {
				log.Print(err)

				// handle err
			}
		}
		return nil
	}
}

func installBrewFormatters(t *taskr.Task) {
	langServers := []string{
		"rust-analyzer",
	}

	t.Fn = func(tskr *taskr.Taskr) error {
		for _, ls := range langServers {
			tskr.Spinner.Message(cyan(ls))
			npmInstallLs := fmt.Sprintf("brew install %s --quiet", ls)

			installCmd := exec.Command(SHELL, "-c", npmInstallLs)

			if _, err := installCmd.CombinedOutput(); err != nil {
				log.Print(err)

				// handle err
			}
		}
		return nil
	}
}
