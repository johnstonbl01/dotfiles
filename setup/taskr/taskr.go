package taskr

import (
	"fmt"
	"log"
	"time"

	"github.com/fatih/color"
	"github.com/theckman/yacspin"
)

var cyan = color.New(color.FgHiCyan).SprintFunc()

type TaskFn func(tskr *Taskr) error

const (
	GROUP = "group"
	TASK  = "task"
)

type Task struct {
	Title    string
	Skip     bool
	SubTasks []Task
	Fn       TaskFn
}

func NewTask(title string, skip bool, options ...func(*Task)) Task {
	task := Task{Title: title, Skip: skip, SubTasks: []Task{}}

	for _, option := range options {
		option(&task)
	}

	return task
}

type Taskr struct {
	Debug     bool
	Spinner   *yacspin.Spinner
	UserEmail string
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

	t := &Taskr{Spinner: s, Debug: debug}

	return t
}

func (t *Taskr) SetEmail(email string) {
	t.UserEmail = email
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

	if err := tsk.Fn(t); err != nil {
		log.Print(err)
		// handle err
	}
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
}
