package tasks

import (
	"archive/tar"
	"archive/zip"
	"bufio"
	"compress/gzip"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"os/exec"
	"path"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
	"time"
)

const SHELL = "/bin/bash"

func checkError(err error) error {
	if err != nil {
		return err
	}

	return nil
}

func prompt(txt string) string {
	fmt.Println(txt)

	var reply string
	fmt.Scanln(&reply)

	return reply
}

func shellCommand(command string, debug bool) (string, error) {
	fmt.Printf("%s", command)
	cmd := exec.Command(SHELL, "-c", command)

	cmd.Stderr = os.Stderr
	stdin, err := cmd.StdinPipe()
	stdout, err := cmd.StdoutPipe()

	err = cmd.Start()
	scanner := bufio.NewScanner(stdout)

	for scanner.Scan() {
		o := scanner.Text()

		if debug {
			fmt.Println(o)
		}

		if strings.Contains(strings.ToLower(o), "RETURN") {
			io.WriteString(stdin, "\n")
		}
	}

	cmdOutput, err := ioutil.ReadAll(stdout)
	return string(cmdOutput), err
}

func isValidProcessId(evalOutput string) bool {
	re := regexp.MustCompile(`\d+`)

	strId := re.FindString(evalOutput)

	if len(strId) == 0 {
		return false
	}

	pId, err := strconv.Atoi(strId)

	if err != nil {
		return false
	}

	if pId < 1 {
		return false
	}

	return true
}

func eraseStdOut(numLines int) {
	time.Sleep(300 * time.Millisecond)

	for i := 1; i <= numLines; i++ {
		fmt.Print("\r\033[1A\033[K")
	}

	time.Sleep(500 * time.Millisecond)
}

func downloadFile(dest string, url string) error {
	resp, err := http.Get(url)
	checkError(err)
	defer resp.Body.Close()

	out, err := os.Create(dest)
	checkError(err)

	err = os.Chmod(dest, 0755)
	checkError(err)
	defer out.Close()

	_, err = io.Copy(out, resp.Body)
	checkError(err)

	return nil
}

func createDir(dirName string) error {
	if _, err := os.Stat(dirName); !os.IsNotExist(err) {
		return nil
	}

	err := os.Mkdir(dirName, 0755)
	checkError(err)

	return nil
}

func unzip(file string, dest string) ([]string, error) {
	var filenames []string

	r, err := zip.OpenReader(file)
	if err != nil {
		return filenames, err
	}

	defer r.Close()

	for _, f := range r.File {
		filePath := filepath.Join(dest, f.Name)

		filenames = append(filenames, filePath)

		if f.FileInfo().IsDir() {
			os.MkdirAll(filePath, os.ModePerm)
			continue
		}

		if err = os.MkdirAll(filepath.Dir(filePath), os.ModePerm); err != nil {
			return filenames, err
		}

		outFile, err := os.OpenFile(filePath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, f.Mode())
		if err != nil {
			return filenames, err
		}

		rc, err := f.Open()
		if err != nil {
			return filenames, err
		}

		_, err = io.Copy(outFile, rc)

		outFile.Close()
		rc.Close()

		if err != nil {
			return filenames, err
		}
	}

	return filenames, nil
}

func copyDir(srcDir string, destDir string) error {
	if err := os.MkdirAll(destDir, os.ModePerm); err != nil {
		return err
	}

	files, err := ioutil.ReadDir(srcDir)
	if err != nil {
		return err
	}

	for _, f := range files {
		srcFilePath := path.Join(srcDir, f.Name())
		destFilePath := path.Join(destDir, f.Name())

		if f.IsDir() {
			copyDir(srcFilePath, destFilePath)
		} else {
			copy(srcFilePath, destFilePath)
		}
	}

	return nil
}

func copy(src string, dest string) error {
	destFile, err := os.Create(dest)
	if err != nil {
		return err
	}
	defer destFile.Close()

	srcFile, err := os.Open(src)
	if err != nil {
		return err
	}
	defer srcFile.Close()

	if _, err = io.Copy(destFile, srcFile); err != nil {
		return err
	}

	return nil
}

func unTar(src string, dest string) error {
	r, err := os.Open(src)
	if err != nil {
		return err
	}

	gzr, err := gzip.NewReader(r)
	if err != nil {
		return err
	}
	defer gzr.Close()

	tr := tar.NewReader(gzr)

	for {
		header, err := tr.Next()

		switch {
		case err == io.EOF:
			return nil
		case err != nil:
			return err
		case header == nil:
			continue
		}

		target := filepath.Join(dest, header.Name)

		switch header.Typeflag {
		case tar.TypeDir:
			if err := os.MkdirAll(target, os.ModePerm); err != nil {
				return err
			}
		case tar.TypeReg:
			f, err := os.OpenFile(target, os.O_CREATE|os.O_RDWR, os.ModePerm)
			if err != nil {
				return err
			}

			if _, err := io.Copy(f, tr); err != nil {
				return err
			}

			f.Close()
		}
	}
}
