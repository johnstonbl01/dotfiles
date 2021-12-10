package tasks

import (
	"errors"
	"fmt"
	"os"
	"os/exec"
	"setup/taskr"
	"time"
)

const (
	HOMEBREW_URL = "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
)

func prereqs(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("Create temp dir", false, "[prereqs] ", createTempDir),
		taskr.NewTask("Install Homebrew", true, "[prereqs] ", installHomebrew),
		taskr.NewTask("Create language server dir", true, "[prereqs] ", createLangServersDir),
		taskr.NewTask("Install git", true, "[prereqs] ", installGit),
		taskr.NewTask("Setup SSH config", true, "[prereqs] ", createSSHConfig),
		taskr.NewTask("Generate public key", true, "[prereqs] ", generatePubKey),
		taskr.NewTask("Copy public key", false, "[prereqs] ", copyPubKey),
	}
}

func copyPubKey(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		var input string

		copyCmd := fmt.Sprintf("pbcopy < %s/id_rsa.pub", tskr.SSHDir)

		pbCopy := exec.Command(SHELL, "-c", copyCmd)
		pbCopy.Run()

		tskr.Spinner.Pause()

		fmt.Println("\nYour public key has been copied to the clipboard.")
		fmt.Println("Paste it into your Git client and then press ENTER to continue")
		fmt.Scanln(&input)

		eraseStdOut(4)

		tskr.Spinner.Unpause()

		time.Sleep(2 * time.Second)
	}
}

func createSSHConfig(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		sshConfig := fmt.Sprintf("%s/config", tskr.SSHDir)
		sshConfigContent := []byte("Host *\n AddKeysToAgent yes\n UseKeychain yes \n IdentityFile ~/.ssh/id_rsa")

		if err := createDir(tskr.SSHDir); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		if err := os.WriteFile(sshConfig, sshConfigContent, 0644); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}

func generatePubKey(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		// TODO: Migrate this to go code eventually
		keyGenCmd := fmt.Sprintf("ssh-keygen -t rsa -b 4096 -C \"%s\" -N '' -f \"%s/id_rsa\"", tskr.UserEmail, tskr.SSHDir)
		evalSSHAgent := exec.Command(SHELL, "-c", "eval \"$(ssh-agent -s)\"")

		if _, err := shellCommand(keyGenCmd, false); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		sshAgentOutput, err := evalSSHAgent.CombinedOutput()
		if err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		if !isValidProcessId(string(sshAgentOutput)) {
			err := errors.New("No valid process id for ssh agent")
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}

func installGit(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		if _, err := shellCommand("brew install git", false); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
		}
	}
}

func createTempDir(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		time.Sleep(500 * time.Millisecond)

		if err := createDir(tskr.TempDir); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
		}
	}
}

func createLangServersDir(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		time.Sleep(500 * time.Millisecond)

		if err := createDir(tskr.LangServerDir); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
		}
	}
}

func installHomebrew(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		fileName := fmt.Sprintf("%s/install-brew.sh", tskr.TempDir)

		if err := downloadFile(fileName, HOMEBREW_URL); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		if _, err := shellCommand(fileName, false); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}
