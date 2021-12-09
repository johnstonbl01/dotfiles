package tasks

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"setup/taskr"
	"time"
)

const HOMEBREW_URL = "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

func prereqs(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("Create temp dir", false, createTempDir),
		taskr.NewTask("Install Homebrew", true, installHomebrew),
		taskr.NewTask("Create language server dir", true, createLangServersDir),
		taskr.NewTask("Install git", true, installGit),
		taskr.NewTask("Setup SSH config", true, createSSHConfig),
		taskr.NewTask("Generate public key", true, generatePubKey),
		taskr.NewTask("Copy public key", false, copyPubKey),
	}
}

func copyPubKey(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) error {
		var input string

		homeDir, _ := os.UserHomeDir()
		sshDir := fmt.Sprintf("%s/.ssh", homeDir)
		copyCmd := fmt.Sprintf("pbcopy < %s/id_rsa.pub", sshDir)

		pbCopy := exec.Command(SHELL, "-c", copyCmd)
		pbCopy.Run()

		tskr.Spinner.Pause()

		fmt.Println("\nYour public key has been copied to the clipboard.")
		fmt.Println("Paste it into your Git client and then press ENTER to continue")
		fmt.Scanln(&input)

		eraseStdOut(4)

		tskr.Spinner.Unpause()

		time.Sleep(2 * time.Second)

		return nil
	}
}

func createSSHConfig(t *taskr.Task) {
	t.Fn = func(_ *taskr.Taskr) error {
		homeDir, _ := os.UserHomeDir()
		sshDir := fmt.Sprintf("%s/.ssh", homeDir)
		sshConfig := fmt.Sprintf("%s/config", sshDir)
		sshConfigContent := []byte("Host *\n AddKeysToAgent yes\n UseKeychain yes \n IdentityFile ~/.ssh/id_rsa")

		if err := createDir(sshDir); err != nil {
			log.Print(err)
			// handle err

			return err
		}

		if err := os.WriteFile(sshConfig, sshConfigContent, 0644); err != nil {
			log.Print(err)
			// handle err

			return err
		}

		return nil
	}

}

func generatePubKey(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) error {
		homeDir, _ := os.UserHomeDir()
		sshDir := fmt.Sprintf("%s/.ssh", homeDir)

		// TODO: Migrate this to go code eventually
		keyGenCmd := fmt.Sprintf("ssh-keygen -t rsa -b 4096 -C \"%s\" -N '' -f \"%s/id_rsa\"", tskr.UserEmail, sshDir)
		evalSSHAgent := exec.Command(SHELL, "-c", "eval \"$(ssh-agent -s)\"")

		if _, err := shellCommand(keyGenCmd, false); err != nil {
			log.Print(err)
			// handle err
		}

		sshAgentOutput, err := evalSSHAgent.CombinedOutput()
		if err != nil {
			log.Print(err)
			// handle err
		}

		if !isValidProcessId(string(sshAgentOutput)) {
			log.Println("No valid process id for ssh agent")
			// hanlde err
		}

		return nil
	}
}

func installGit(t *taskr.Task) {
	t.Fn = func(_ *taskr.Taskr) error {
		if _, err := shellCommand("brew install git", false); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}

func createTempDir(t *taskr.Task) {
	t.Fn = func(_ *taskr.Taskr) error {
		time.Sleep(500 * time.Millisecond)

		if err := createDir(TEMP_DIR); err != nil {
			log.Print(err)
			// handle err

			return err
		}

		return nil
	}
}

func createLangServersDir(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	langServerLoc := fmt.Sprintf("%s/.langservers", homeDir)

	t.Fn = func(_ *taskr.Taskr) error {
		time.Sleep(500 * time.Millisecond)

		if err := createDir(langServerLoc); err != nil {
			log.Print(err)
			// handle err

			return err
		}

		return nil
	}
}

func installHomebrew(t *taskr.Task) {
	fileName := fmt.Sprintf("%s/install-brew.sh", TEMP_DIR)

	t.Fn = func(_ *taskr.Taskr) error {
		if err := downloadFile(fileName, HOMEBREW_URL); err != nil {
			log.Print(err)
			// handle err
		}

		if _, err := shellCommand(fileName, false); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}
