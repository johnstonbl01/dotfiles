package tasks

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"setup/taskr"
)

const NVM_URL = "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh"
const RUST_URL = "https://sh.rustup.rs"

func languages(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("Node", false, installNode),
		taskr.NewTask("Rust", false, installRust),
		taskr.NewTask("Golang", false, installGolang),
		taskr.NewTask("Lua", false, installLua),
		taskr.NewTask("Python", false, installPython),
	}
}

func installNode(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	fileName := fmt.Sprintf("%s/install-nvm.sh", TEMP_DIR)
	nvmDir := fmt.Sprintf("%s/.nvm", homeDir)

	exportNvmDir := fmt.Sprintf("export NVM_DIR=\"%s\"", nvmDir)
	runNvm := fmt.Sprintf("[ -s \"%s/nvm.sh\" ] && \\. \"%s/nvm.sh\"", nvmDir, nvmDir)
	installLts := fmt.Sprintf("%s && %s && nvm install --lts", exportNvmDir, runNvm)

	t.Fn = func(_ *taskr.Taskr) error {
		if err := downloadFile(fileName, NVM_URL); err != nil {
			log.Print(err)
			// handle err
		}

		if _, err := shellCommand(fileName, false); err != nil {
			log.Print(err)
			// handle err
		}

		if _, err := shellCommand(installLts, false); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}

func installRust(t *taskr.Task) {
	fileName := fmt.Sprintf("%s/install-rust.sh", TEMP_DIR)
	installCmd := fmt.Sprintf("%s -y --quiet --no-modify-path", fileName)

	t.Fn = func(_ *taskr.Taskr) error {
		if err := downloadFile(fileName, RUST_URL); err != nil {
			log.Print(err)
			// handle err
		}

		cmd := exec.Command(SHELL, "-c", installCmd)
		if _, err := cmd.Output(); err != nil {
			log.Print(err)
		}

		return nil
	}
}

func installGolang(t *taskr.Task) {
	t.Fn = func(_ *taskr.Taskr) error {
		if _, err := shellCommand("brew install go --quiet", false); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}

func installLua(t *taskr.Task) {
	t.Fn = func(_ *taskr.Taskr) error {
		if _, err := shellCommand("brew install lua luarocks --quiet", false); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}

func installPython(t *taskr.Task) {
	t.Fn = func(_ *taskr.Taskr) error {
		if _, err := shellCommand("brew install python --quiet", false); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}
