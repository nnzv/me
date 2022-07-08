package main

import (
    "os"
    "io/fs"
    f "flag"
    "strings"
    "path/filepath"
    "log"
)

func main() {
    obj := new(Link)

    obj.getFiles()

    switch(Flag()) {
    case "u":
        err := obj.DelLink()
        if err != nil {
            log.Fatal(err)
        }
    default:
        err := obj.SymLink()
        if err != nil {
            log.Fatal(err)
        }
    }
}

type Linker interface {
    getFiles()
     SymLink() error
}

type Link struct {
    Abs []string
    Rel []string
}

func (l *Link) getFiles() {
    filepath.Walk("src", func(path string, f fs.FileInfo, err error) error {
        if err != nil {
            log.Fatal(err)
        }

        abs, err := filepath.Abs(path)
        if err != nil {
            log.Fatal(err)
        }

        if !f.IsDir() {

            home, err := os.UserHomeDir()
            if err != nil {
                log.Fatal(err)
            }
            path = strings.ReplaceAll(path, "src/", "")
            path = filepath.Join(home, path)

            l.Abs = append(l.Abs, abs)
            l.Rel = append(l.Rel, path)
        }
        return nil
    })
}

func (l Link) SymLink() error {
    for i := range l.Abs {

        par := filepath.Dir(l.Rel[i])

        err := os.Mkdir(par, 0750)
        if err != nil && !os.IsExist(err) {
            return err
        }

	    os.Symlink(l.Abs[i], l.Rel[i]) 
    }
    return nil
}

func (l Link) DelLink() error {
    for i := range l.Rel {
        err := os.Remove(l.Rel[i])
        if err != nil {
            return err
        }
    }
    return nil
}

func init() {
    f.Bool(
            "u", false,
        "Unlink files",
    )
    f.Parse()
}

var Flag = func() string {
    var used string
    f.Visit(func(fg *f.Flag) {
        used = fg.Name
    })
    return used
}
