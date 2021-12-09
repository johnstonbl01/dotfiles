package tasks

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"setup/taskr"
)

const OMZ_URL = "https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
const TOKYO_NIGHT_ITERM_URL = "https://raw.githubusercontent.com/enkia/tokyo-night-vscode-theme/master/tokyo-night.itermcolors"
const CAPSLOCK_SCRIPT = "https://gist.githubusercontent.com/liamdawson/8dba17715c452dad996932291193c353/raw/420d97c10526403849d8a5279cb2007840e546cd/com.ldaws.CapslockEsc.plist"
const INCONSOLATA_FONT_URL = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Inconsolata.zip"

func setupDevEnv(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("Create dev folder", false, createDevFolder),
		taskr.NewTask("Create screenshot folder", false, createDevFolder),
		taskr.NewTask("Install Oh-My-Zsh", false, installOhMyZsh),
		taskr.NewTask("Setup dotfiles", false, setupDotfiles),
		taskr.NewTask("Install zsh-autosuggestions plugin", false, setupZshAutoSuggestions),
		taskr.NewTask("Download tokyo night iterm theme", false, downloadItermTheme),
		taskr.NewTask("Setup sandbox project", false, createSandboxProject),
		taskr.NewTask("Map capslock => esc", false, mapCapslockKey),
		taskr.NewTask("Install Inconsolata font", false, installInconsolata),
		taskr.NewTask("Install NeoVim package manager", false, installNeoVimPackageManager),
	}
}

func createDevFolder(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	devDir := fmt.Sprintf("%s/dev", homeDir)

	t.Fn = func(_ *taskr.Taskr) error {
		if err := os.MkdirAll(devDir, 0777); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}

func createScreenshotFolder(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	devDir := fmt.Sprintf("%s/Screenshots", homeDir)

	t.Fn = func(_ *taskr.Taskr) error {
		if err := os.MkdirAll(devDir, 0777); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}

func installOhMyZsh(t *taskr.Task) {
	fileName := fmt.Sprintf("%s/install-omz.sh", TEMP_DIR)

	t.Fn = func(_ *taskr.Taskr) error {
		if err := downloadFile(fileName, OMZ_URL); err != nil {
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

// TODO: set folder vars on taskr struct
func setupDotfiles(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	neovimDir := fmt.Sprintf("%s/.config/nvim", homeDir)
	zshDir := fmt.Sprintf("%s/.oh-my-zsh", homeDir)
	dotfilesDir := fmt.Sprintf("%s/dev/dotfiles", homeDir)
	cloneDotfiles := fmt.Sprintf("git clone git@github.com:johnstonbl01/dotfiles.git %s", dotfilesDir)
	symlinkVimrc := fmt.Sprintf("ln -sf %s/vim/* %s/", dotfilesDir, neovimDir)
	symlinkZshrc := fmt.Sprintf("ln -sf %s/zsh/.zshrc %s/.zshrc", dotfilesDir, homeDir)
	symlinkGitignore := fmt.Sprintf("ln -sf %s/.gitignore_global %s/.gitignore_global", dotfilesDir, homeDir)
	symlinkGitconfig := fmt.Sprintf("ln -sf %s/.gitconfig %s/.gitconfig", dotfilesDir, homeDir)
	symlinkZshTheme := fmt.Sprintf("ln -sf %s/zsh/dieter-custom.zsh-theme %s/themes", dotfilesDir, zshDir)

	t.Fn = func(_ *taskr.Taskr) error {
		cmd := exec.Command(SHELL, "-c", cloneDotfiles)
		if _, err := cmd.CombinedOutput(); err != nil {
			log.Print(err)
			// handle err
		}

		if err := os.MkdirAll(neovimDir, 0755); err != nil {
			log.Print(err)
			// handle err
		}

		// TODO: Iterate through these symlinks and just use os.Symlink
		cmd = exec.Command(SHELL, "-c", symlinkZshrc)
		if _, err := cmd.CombinedOutput(); err != nil {
			log.Print(err)
			// handle err
		}

		cmd = exec.Command(SHELL, "-c", symlinkGitignore)
		if _, err := cmd.CombinedOutput(); err != nil {
			log.Print(err)
			// handle err
		}

		cmd = exec.Command(SHELL, "-c", symlinkGitconfig)
		if _, err := cmd.CombinedOutput(); err != nil {
			log.Print(err)
			// handle err
		}

		cmd = exec.Command(SHELL, "-c", symlinkVimrc)
		if _, err := cmd.CombinedOutput(); err != nil {
			log.Print(err)
			// handle err
		}

		cmd = exec.Command(SHELL, "-c", symlinkZshTheme)
		if _, err := cmd.CombinedOutput(); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}

func setupZshAutoSuggestions(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	zshDir := fmt.Sprintf("%s/.oh-my-zsh/custom/plugins/zsh-autosuggestions", homeDir)
	cloneCmd := fmt.Sprintf("git clone https://github.com/zsh-users/zsh-autosuggestions %s", zshDir)

	t.Fn = func(_ *taskr.Taskr) error {
		cmd := exec.Command(SHELL, "-c", cloneCmd)

		if _, err := cmd.CombinedOutput(); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}

func downloadItermTheme(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	themeDir := fmt.Sprintf("%s/dev/iterm-themes", homeDir)
	fileName := fmt.Sprintf("%s/tokyo-night.itermcolors", themeDir)

	t.Fn = func(_ *taskr.Taskr) error {
		if err := os.MkdirAll(themeDir, 0777); err != nil {
			log.Print(err)
			// handle err
		}

		if err := downloadFile(fileName, TOKYO_NIGHT_ITERM_URL); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}

func createSandboxProject(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	sandboxDir := fmt.Sprintf("%s/dev/sandbox", homeDir)
	jsDir := fmt.Sprintf("%s/js", sandboxDir)
	goDir := fmt.Sprintf("%s/go", sandboxDir)

	t.Fn = func(_ *taskr.Taskr) error {
		if err := os.MkdirAll(jsDir, 0777); err != nil {
			log.Print(err)
			// handle err
		}

		if err := os.MkdirAll(goDir, 0777); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}

func mapCapslockKey(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	fileName := fmt.Sprintf("%s/Library/LaunchAgents/com.ldaws.CapslockEsc.plist", homeDir)
	launchCmd := fmt.Sprintf("launchctl load %s", fileName)

	t.Fn = func(_ *taskr.Taskr) error {
		cmd := exec.Command(SHELL, "-c", launchCmd)

		if err := downloadFile(fileName, CAPSLOCK_SCRIPT); err != nil {
			log.Print(err)
			// handle err
		}

		if _, err := cmd.CombinedOutput(); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}

func installInconsolata(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	tempFontDir := fmt.Sprintf("%s/inconsolata", TEMP_DIR)
	fileName := fmt.Sprintf("%s.zip", tempFontDir)
	fontDir := fmt.Sprintf("%s/Library/Fonts", homeDir)

	completeFile := fmt.Sprintf("%s/Inconsolata Nerd Font Complete.otf", tempFontDir)
	boldFile := fmt.Sprintf("%s/Inconsolata Bold Nerd Font Complete.otf", tempFontDir)
	regularFile := fmt.Sprintf("%s/Inconsolata Regular Nerd Font Complete.otf", tempFontDir)

	t.Fn = func(_ *taskr.Taskr) error {
		if err := downloadFile(fileName, INCONSOLATA_FONT_URL); err != nil {
			log.Print(err)
			// handle err
		}

		if _, err := unzip(fileName, tempFontDir); err != nil {
			log.Print(err)
			// handle err
		}

		copy(completeFile, fontDir)
		copy(boldFile, fontDir)
		copy(regularFile, fontDir)

		return nil
	}
}

func installNeoVimPackageManager(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	neovimLocals := fmt.Sprintf("%s/.local/share/nvim/site/pack/packer/start/packer.nvim", homeDir)
	cloneCmd := fmt.Sprintf("git clone --depth 1 https://github.com/wbthomason/packer.nvim %s", neovimLocals)

	t.Fn = func(_ *taskr.Taskr) error {
		cmd := exec.Command(SHELL, "-c", cloneCmd)

		if _, err := cmd.CombinedOutput(); err != nil {
			log.Print(err)

			// handle err
		}

		return nil
	}
}
