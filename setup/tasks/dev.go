package tasks

import (
	"fmt"
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
		taskr.NewTask("Create dev folder", false, "[dev-env] ", createDevFolder),
		taskr.NewTask("Create screenshot folder", false, "[dev-env] ", createDevFolder),
		taskr.NewTask("Install Oh-My-Zsh", false, "[dev-env] ", installOhMyZsh),
		taskr.NewTask("Setup dotfiles", false, "[dev-env] ", setupDotfiles),
		taskr.NewTask("Install zsh-autosuggestions plugin", false, "[dev-env] ", setupZshAutoSuggestions),
		taskr.NewTask("Download tokyo night iterm theme", false, "[dev-env] ", downloadItermTheme),
		taskr.NewTask("Setup sandbox project", false, "[dev-env] ", createSandboxProject),
		taskr.NewTask("Map capslock => esc", false, "[dev-env] ", mapCapslockKey),
		taskr.NewTask("Install Inconsolata font", false, "[dev-env] ", installInconsolata),
		taskr.NewTask("Install NeoVim package manager", false, "[dev-env] ", installNeoVimPackageManager),
	}
}

func createDevFolder(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	devDir := fmt.Sprintf("%s/dev", homeDir)

	t.Fn = func(tskr *taskr.Taskr) {
		if err := os.MkdirAll(devDir, 0777); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}

func createScreenshotFolder(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	devDir := fmt.Sprintf("%s/Screenshots", homeDir)

	t.Fn = func(tskr *taskr.Taskr) {
		if err := os.MkdirAll(devDir, 0777); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}

func installOhMyZsh(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		fileName := fmt.Sprintf("%s/install-omz.sh", tskr.TempDir)

		if err := downloadFile(fileName, OMZ_URL); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		if _, err := shellCommand(fileName, false); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}

func setupDotfiles(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		cloneDotfiles := fmt.Sprintf("git clone git@github.com:johnstonbl01/dotfiles.git %s", tskr.DotfilesDir)
		symlinkVimrc := fmt.Sprintf("ln -sf %s/vim/* %s/", tskr.DotfilesDir, tskr.NeoVimConfigDir)
		symlinkZshrc := fmt.Sprintf("ln -sf %s/zsh/.zshrc %s/.zshrc", tskr.DotfilesDir, tskr.HomeDir)
		symlinkTmuxConfig := fmt.Sprintf("ln -sf %s/tmux/.tmux.conf %s/.tmux.conf", tskr.DotfilesDir, tskr.HomeDir)
		symlinkGitignore := fmt.Sprintf("ln -sf %s/.gitignore_global %s/.gitignore_global", tskr.DotfilesDir, tskr.HomeDir)
		symlinkGitconfig := fmt.Sprintf("ln -sf %s/.gitconfig %s/.gitconfig", tskr.DotfilesDir, tskr.HomeDir)
		symlinkZshTheme := fmt.Sprintf("ln -sf %s/zsh/dieter-custom.zsh-theme %s/themes", tskr.DotfilesDir, tskr.ZSHDir)

		cmd := exec.Command(SHELL, "-c", cloneDotfiles)
		if _, err := cmd.CombinedOutput(); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		if err := os.MkdirAll(tskr.NeoVimConfigDir, 0755); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		// TODO: Iterate through these symlinks and just use os.Symlink
		cmd = exec.Command(SHELL, "-c", symlinkZshrc)
		if _, err := cmd.CombinedOutput(); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		cmd = exec.Command(SHELL, "-c", symlinkGitignore)
		if _, err := cmd.CombinedOutput(); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		cmd = exec.Command(SHELL, "-c", symlinkGitconfig)
		if _, err := cmd.CombinedOutput(); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		cmd = exec.Command(SHELL, "-c", symlinkVimrc)
		if _, err := cmd.CombinedOutput(); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		cmd = exec.Command(SHELL, "-c", symlinkZshTheme)
		if _, err := cmd.CombinedOutput(); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		cmd = exec.Command(SHELL, "-c", symlinkTmuxConfig)
		if _, err := cmd.CombinedOutput(); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

	}
}

func setupZshAutoSuggestions(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		zshDir := fmt.Sprintf("%s/custom/plugins/zsh-autosuggestions", tskr.ZSHDir)
		cloneCmd := fmt.Sprintf("git clone https://github.com/zsh-users/zsh-autosuggestions %s", zshDir)
		cmd := exec.Command(SHELL, "-c", cloneCmd)

		if _, err := cmd.CombinedOutput(); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}

func downloadItermTheme(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		themeDir := fmt.Sprintf("%s/iterm-themes", tskr.DevDir)
		fileName := fmt.Sprintf("%s/tokyo-night.itermcolors", themeDir)

		if err := os.MkdirAll(themeDir, 0777); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		if err := downloadFile(fileName, TOKYO_NIGHT_ITERM_URL); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}

func createSandboxProject(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		sandboxDir := fmt.Sprintf("%s/sandbox", tskr.DevDir)
		jsDir := fmt.Sprintf("%s/js", sandboxDir)
		goDir := fmt.Sprintf("%s/go", sandboxDir)

		if err := os.MkdirAll(jsDir, 0777); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		if err := os.MkdirAll(goDir, 0777); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}

func mapCapslockKey(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		fileName := fmt.Sprintf("%s/Library/LaunchAgents/com.ldaws.CapslockEsc.plist", tskr.HomeDir)
		launchCmd := fmt.Sprintf("launchctl load %s", fileName)

		cmd := exec.Command(SHELL, "-c", launchCmd)

		if err := downloadFile(fileName, CAPSLOCK_SCRIPT); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		if _, err := cmd.CombinedOutput(); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}

func installInconsolata(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		tempFontDir := fmt.Sprintf("%s/inconsolata", tskr.TempDir)
		fileName := fmt.Sprintf("%s.zip", tempFontDir)
		fontDir := fmt.Sprintf("%s/Library/Fonts", tskr.HomeDir)

		completeFile := fmt.Sprintf("%s/Inconsolata Nerd Font Complete.otf", tempFontDir)
		boldFile := fmt.Sprintf("%s/Inconsolata Bold Nerd Font Complete.otf", tempFontDir)
		regularFile := fmt.Sprintf("%s/Inconsolata Regular Nerd Font Complete.otf", tempFontDir)

		if err := downloadFile(fileName, INCONSOLATA_FONT_URL); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		if _, err := unzip(fileName, tempFontDir); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		copy(completeFile, fontDir)
		copy(boldFile, fontDir)
		copy(regularFile, fontDir)
	}
}

func installNeoVimPackageManager(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		neovimLocals := fmt.Sprintf("%s/.local/share/nvim/site/pack/packer/start/packer.nvim", tskr.HomeDir)
		cloneCmd := fmt.Sprintf("git clone --depth 1 https://github.com/wbthomason/packer.nvim %s", neovimLocals)

		cmd := exec.Command(SHELL, "-c", cloneCmd)

		if _, err := cmd.CombinedOutput(); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}
