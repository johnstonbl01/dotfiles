package tasks

import (
	"fmt"
	"os/exec"
	"setup/taskr"
)

const NVM_URL = "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh"
const RUST_URL = "https://sh.rustup.rs"

func languages(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("Node", false, "[languages] ", installNode),
		taskr.NewTask("Rust", false, "[languages] ", installRust),
		taskr.NewTask("Golang", false, "[languages] ", installGolang),
		taskr.NewTask("Lua", false, "[languages] ", installLua),
		taskr.NewTask("Python", false, "[languages] ", installPython),
	}
}

func installNode(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		fileName := fmt.Sprintf("%s/install-nvm.sh", tskr.TempDir)
		nvmDir := fmt.Sprintf("%s/.nvm", tskr.HomeDir)

		exportNvmDir := fmt.Sprintf("export NVM_DIR=\"%s\"", nvmDir)
		runNvm := fmt.Sprintf("[ -s \"%s/nvm.sh\" ] && \\. \"%s/nvm.sh\"", nvmDir, nvmDir)
		installLts := fmt.Sprintf("%s && %s && nvm install --lts", exportNvmDir, runNvm)

		if err := downloadFile(fileName, NVM_URL); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		if _, err := shellCommand(fileName, false); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		if _, err := shellCommand(installLts, false); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}

func installRust(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		fileName := fmt.Sprintf("%s/install-rust.sh", tskr.TempDir)
		installCmd := fmt.Sprintf("%s -y --quiet --no-modify-path", fileName)

		if err := downloadFile(fileName, RUST_URL); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		cmd := exec.Command(SHELL, "-c", installCmd)
		if _, err := cmd.Output(); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}

func installGolang(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		if _, err := shellCommand("brew install go --quiet", false); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}

func installLua(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		if _, err := shellCommand("brew install lua luarocks --quiet", false); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}

func installPython(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		if _, err := shellCommand("brew install python --quiet", false); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}
