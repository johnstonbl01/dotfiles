package tasks

import (
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path"
	"setup/taskr"
)

// Version 2.5.2
const LUA_LANG_URL = "https://nightly.link/sumneko/lua-language-server/actions/artifacts/121358706.zip"
const MD_LANG_URL = "https://github.com/valentjn/ltex-ls/releases/download/15.2.0/ltex-ls-15.2.0-mac-x64.tar.gz"

func languageServers(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("", false, "[lang-servers] ", installNPMLangServers),
		taskr.NewTask("", false, "[lang-servers] ", installBrewLangServers),
		taskr.NewTask("ltex-ls", false, "[lang-servers] ", isntallLTexLangServer),
		taskr.NewTask("updating langserver permissions", false, "[lang-servers] ", updateLangServerPermissions),
	}
}

func installNPMLangServers(t *taskr.Task) {
	langServers := []string{
		"@tailwindcss/language-server",
		"graphql-language-service-cli",
		"graphql",
		"svelte-language-server",
		"typescript",
		"vim-language-server",
		"vls",
		"vscode-langservers-extracted",
		"yaml-language-server",
		"pyright",
		"bash-language-server",
	}

	t.Fn = func(tskr *taskr.Taskr) {
		for _, ls := range langServers {
			tskr.Spinner.Message(cyan(ls))
			npmInstallLs := fmt.Sprintf("npm i -g %s", ls)

			installCmd := exec.Command(SHELL, "-c", npmInstallLs)

			if _, err := installCmd.CombinedOutput(); err != nil {
				prefix := fmt.Sprintf("%s%s", t.ErrContext, ls)
				tskr.HandleTaskError(prefix, err)
			}
		}
	}
}

func installBrewLangServers(t *taskr.Task) {
	langServers := []string{
		"efm-langserver",
		"terraform-ls",
		"lua-language-server",
	}

	t.Fn = func(tskr *taskr.Taskr) {
		for _, ls := range langServers {
			tskr.Spinner.Message(cyan(ls))
			npmInstallLs := fmt.Sprintf("brew install %s --quiet", ls)

			installCmd := exec.Command(SHELL, "-c", npmInstallLs)

			if _, err := installCmd.CombinedOutput(); err != nil {
				prefix := fmt.Sprintf("%s%s", t.ErrContext, ls)
				tskr.HandleTaskError(prefix, err)
			}
		}
	}
}

func isntallLTexLangServer(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		tempLangDir := fmt.Sprintf("%s/ltex-ls", tskr.TempDir)
		fileName := fmt.Sprintf("%s.tar.gz", tempLangDir)
		ltexLangServerDir := fmt.Sprintf("%s/ltex-ls", tskr.LangServerDir)

		// TODO: Maybe in future scrape to get latest version to install instead of hard-coding URL
		if err := downloadFile(fileName, MD_LANG_URL); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		if err := unTar(fileName, tempLangDir); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		files, err := os.ReadDir(tempLangDir)
		if err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		if len(files) > 1 {
			err := errors.New("Too many files created from unTar")

			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}

		copyDir(path.Join(tempLangDir, files[0].Name()), ltexLangServerDir)
	}
}

func updateLangServerPermissions(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		cmd := fmt.Sprintf("chmod -R +x %s/.langservers", tskr.HomeDir)
		if _, err := shellCommand(cmd, false); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
			return
		}
	}
}
