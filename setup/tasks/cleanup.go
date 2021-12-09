package tasks

import (
	"fmt"
	"log"
	"os"
	"setup/taskr"
	"time"
)

func cleanup(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("Remove temp dir", false, removeTempDir),
	}
}

func removeTempDir(t *taskr.Task) {
	t.Fn = func(_ *taskr.Taskr) error {
		time.Sleep(500 * time.Millisecond)

		if err := os.RemoveAll(TEMP_DIR); err != nil {
			log.Print(err)
			// handle err
		}

		return nil
	}
}

func finalizeMessage(t *taskr.Task) {
	t.Fn = func(_ *taskr.Taskr) error {
		fmt.Println("All done 🎉")
		return nil
	}
}
