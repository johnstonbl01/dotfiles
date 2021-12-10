package tasks

import (
	"os"
	"setup/taskr"
	"time"
)

func cleanup(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("Remove temp dir", false, "[cleanup] ", removeTempDir),
	}
}

func removeTempDir(t *taskr.Task) {
	t.Fn = func(tskr *taskr.Taskr) {
		time.Sleep(500 * time.Millisecond)

		if err := os.RemoveAll(tskr.TempDir); err != nil {
			tskr.HandleTaskError(t.ErrorPrefix(), err)
		}
	}
}
