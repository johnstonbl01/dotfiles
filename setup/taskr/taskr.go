package taskr

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/fatih/color"
	"github.com/theckman/yacspin"
)

var cyan = color.New(color.FgHiCyan).SprintFunc()
var red = color.New(color.FgHiRed).SprintFunc()
var yellow = color.New(color.FgHiYellow).SprintFunc()

var finalTodos = []string{
	"All done! 🎉",
	"Next steps:",
	"",
	yellow("Install App Store apps"),
	"    [] Run dog",
	"    [] BetterSnapTool",
	"    [] Divvy",
	"    [] Tapes",
	"    [] Run dog",
	"    [] Todoist",
	"    [] Fantastical",
	"    [] Todoist",
	"    [] BarRemote",
	"",
	yellow("Download apps"),
	"    [] Sip (https://sipapp.io/)",
	"",
	yellow("Env setup"),
	"    [] npm login",
	"    [] import iterm profile",
	"    [] install iterm themes",
	"    [] install nvim plugins (vim --headless +PackerInstall +qa)",
	"    [] install tmux plugins (prefix + I)",
}

type TaskFn func(tskr *Taskr)

type Task struct {
	Title      string
	Skip       bool
	SubTasks   []Task
	Fn         TaskFn
	ErrContext string
}

func NewTask(title string, skip bool, errContext string, options ...func(*Task)) Task {
	task := Task{
		Title:      title,
		Skip:       skip,
		SubTasks:   []Task{},
		ErrContext: errContext,
	}

	for _, option := range options {
		option(&task)
	}

	return task
}

func (t *Task) ErrorPrefix() string {
	return fmt.Sprintf("%s%s", t.ErrContext, t.Title)
}

type Taskr struct {
	Debug           bool
	Spinner         *yacspin.Spinner
	UserEmail       string
	HomeDir         string
	SSHDir          string
	LangServerDir   string
	TempDir         string
	DevDir          string
	ZSHDir          string
	DotfilesDir     string
	NeoVimConfigDir string
	Errors          []string
	startTime       time.Time
}

func New(debug bool) *Taskr {
	scfg := yacspin.Config{
		Frequency:       100 * time.Millisecond,
		CharSet:         yacspin.CharSets[14],
		Colors:          []string{"fgHiYellow", "bold"},
		SuffixAutoColon: true,
		StopCharacter:   "✓",
		StopColors:      []string{"fgHiGreen", "bold"},
	}

	s, _ := yacspin.New(scfg)

	homeDir, _ := os.UserHomeDir()
	sshDir := fmt.Sprintf("%s/.ssh", homeDir)
	langServerDir := fmt.Sprintf("%s/.langservers", homeDir)
	tempDir := fmt.Sprintf("%s/temp", homeDir)
	devDir := fmt.Sprintf("%s/dev", homeDir)
	zshDir := fmt.Sprintf("%s/.oh-my-zsh", homeDir)
	dotfilesDir := fmt.Sprintf("%s/personal/dotfiles", devDir)
	neovimConfigDir := fmt.Sprintf("%s/.config/nvim", homeDir)

	t := &Taskr{
		Spinner:         s,
		Debug:           debug,
		HomeDir:         homeDir,
		SSHDir:          sshDir,
		LangServerDir:   langServerDir,
		TempDir:         tempDir,
		DevDir:          devDir,
		ZSHDir:          zshDir,
		DotfilesDir:     dotfilesDir,
		NeoVimConfigDir: neovimConfigDir,
		Errors:          []string{},
		startTime:       time.Now(),
	}

	return t
}

func (t *Taskr) SetEmail(email string) {
	t.UserEmail = email
}

func (t *Taskr) HandleTaskError(errPrefix string, err error) {
	if t.Debug {
		log.Print(err)
	}

	errMsg := fmt.Sprintf("%s: %s", errPrefix, red(err.Error()))

	t.Errors = append(t.Errors, errMsg)
}

func (t *Taskr) execTask(tsk Task) {
	if tsk.Skip {
		return
	}

	if t.Spinner.Status() == yacspin.SpinnerRunning {
		t.Spinner.Message(cyan(tsk.Title))
	} else {
		t.Spinner.Suffix(fmt.Sprintf(" %s", tsk.Title))
	}

	tsk.Fn(t)
}

func (t *Taskr) runAllTasks(tasks []Task) {
	for _, tsk := range tasks {
		t.processTask(tsk)
	}
}

func (t *Taskr) processTask(task Task) {
	hasSubTasks := len(task.SubTasks) > 0

	if hasSubTasks {
		t.Spinner.Suffix(fmt.Sprintf(" %s", task.Title))
		t.Spinner.Start()

		t.runAllTasks(task.SubTasks)
		t.Spinner.Stop()
	} else {
		t.execTask(task)
	}
}

func (t *Taskr) Run(taskList []Task) {
	for _, tsk := range taskList {
		if tsk.Skip {
			continue
		}

		t.processTask(tsk)
	}

	t.Spinner.Stop()
	fmt.Println(fmt.Sprintf("All tasks completed in %s", time.Since(t.startTime)))

	fmt.Println("=================  Errors  =================")

	for _, err := range t.Errors {
		fmt.Println(err)
	}

	for _, txt := range finalTodos {
		fmt.Println(txt)
	}
}
