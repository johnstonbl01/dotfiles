package runner

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
)

const SHELL = "/bin/bash"

type TaskType string
type TaskFn func() error

type TaskGroup struct {
	title string
	group []Task
}

type Task struct {
	fn    TaskFn
	title string
	skip  bool
}

func NewTask(title string, skip bool, fn TaskFn) Task {
	task := Task{}

	task.fn = fn
	task.title = title
	task.skip = skip

	return task
}

func shellCommand(command string) {
	cmd := exec.Command(SHELL, "-c", command)
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout

	err := cmd.Run()

	if err != nil {
		log.Fatal(err)
	}
}

func debugLog(str string) {
	log.Println(str)
}

func createTempDir() error {
	if _, err := os.Stat("./temp"); !os.IsNotExist(err) {
		return nil
	}

	err := os.Mkdir("temp", 0755)

	if err != nil {
		debugLog(fmt.Sprint(err))
		return err
	}

	return nil
}

func checkError(err error) error {
	if err != nil {
		return err
	}

	return nil
}

func downloadfile(dest string, url string) error {
	debugLog(fmt.Sprintf("downloading file from %s", url))

	resp, err := http.Get(url)

	if err != nil {
		return err
	}

	defer resp.Body.Close()

	out, err := os.Create(dest)

	if err != nil {
		return err
	}

	err = os.Chmod(dest, 0755)

	if err != nil {
		return err
	}

	defer out.Close()

	_, err = io.Copy(out, resp.Body)

	return nil
}

func cleanUp() error {
	if err := os.RemoveAll("./temp"); err != nil {
		return err
	}

	return nil
}

func installBrew() error {
	if err := downloadfile("./temp/install-brew.sh", "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"); err != nil {
		return err
	}

	return nil
}

func execTask(t Task) {
	if t.skip {
		return
	}

	fmt.Printf("Starting task - %s", t.title)

	if err := t.fn(); err != nil {
		fmt.Printf("Failed to %s", t.title)
		return
	}

	fmt.Printf("%s completed", t.title)
}

func runAllTasks(tasks []Task) {
	for _, t := range tasks {
		execTask(t)
	}
}

func Run() {
	createWorkingDir := NewTask("Create temp dir", false, createTempDir)
	downloadBrew := NewTask("Download brew", false, installBrew)
	cleanupTask := NewTask("Cleanup", false, cleanUp)

	tasks := []Task{createWorkingDir, downloadBrew, cleanupTask}

	runAllTasks(tasks)
}
