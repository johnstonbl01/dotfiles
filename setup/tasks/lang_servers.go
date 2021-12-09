package tasks

import (
	"fmt"
	"log"
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
		taskr.NewTask("", false, installNPMLangServers),
		taskr.NewTask("", false, installBrewLangServers),
		taskr.NewTask("lua-langauge-server", false, installLuaLangServer),
		taskr.NewTask("ltex-ls", false, isntallLTexLangServer),
		taskr.NewTask("updating langserver permissions", false, updateLangServerPermissions),
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

func installBrewLangServers(t *taskr.Task) {
	langServers := []string{
		"efm-langserver",
		"terraform-ls",
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

func installLuaLangServer(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	tempLangDir := fmt.Sprintf("%s/lua-language-server", TEMP_DIR)
	fileName := fmt.Sprintf("%s.zip", tempLangDir)
	langServerDir := fmt.Sprintf("%s/.langservers", homeDir)
	luaLangBinDir := fmt.Sprintf("%s/lua-language-server/bin", langServerDir)
	luaLangServerDir := fmt.Sprintf("%s/lua-language-server", langServerDir)

	t.Fn = func(_ *taskr.Taskr) error {
		// TODO: Maybe in future scrape to get latest version to install instead of hard-coding URL
		if err := downloadFile(fileName, LUA_LANG_URL); err != nil {
			log.Print(err)
			// handle err
		}

		if _, err := unzip(fileName, tempLangDir); err != nil {
			log.Print(err)
			// handle err
		}

		macDir := fmt.Sprintf("%s/macOS", tempLangDir)
		mainFile := fmt.Sprintf("%s/main.lua", macDir)

		copyDir(macDir, luaLangBinDir)
		copy(mainFile, fmt.Sprintf("%s/main.lua", luaLangServerDir))

		return nil
	}
}

func isntallLTexLangServer(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	tempLangDir := fmt.Sprintf("%s/ltex-ls", TEMP_DIR)
	fileName := fmt.Sprintf("%s.tar.gz", tempLangDir)
	ltexLangServerDir := fmt.Sprintf("%s/.langservers/ltex-ls", homeDir)

	t.Fn = func(_ *taskr.Taskr) error {
		// TODO: Maybe in future scrape to get latest version to install instead of hard-coding URL
		if err := downloadFile(fileName, MD_LANG_URL); err != nil {
			log.Print(err)
			// handle err
		}

		if err := unTar(fileName, tempLangDir); err != nil {
			log.Print(err)
			// handle err
		}

		files, err := os.ReadDir(tempLangDir)
		if err != nil {
			log.Print(err)
			// handle err
		}

		if len(files) > 1 {
			errMsg := "Too many files created from unTar"
			log.Print(errMsg)
			// handle err
		}

		copyDir(path.Join(tempLangDir, files[0].Name()), ltexLangServerDir)

		return nil
	}
}

func updateLangServerPermissions(t *taskr.Task) {
	homeDir, _ := os.UserHomeDir()
	cmd := fmt.Sprintf("chmod -R +x %s/.langservers", homeDir)

	t.Fn = func(_ *taskr.Taskr) error {
		if _, err := shellCommand(cmd, false); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}
