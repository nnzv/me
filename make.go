// Package main provides linking and unlink operations
package main

import (
    "os"
    f "flag"
    "strings"
    "path/filepath"
    "log"
)

// Dotfiles directory
var root string = "src"

func main() {
    obj := new(Link)

    err := obj.GetFiles()
    if err != nil {
        log.Fatal(err)
    }

    switch Flag() {
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

// Link holds absolute and relative files
type Link struct {
    // Abs are absolute files from source directory
    Abs []string
    // Rel are relative files from user home directory
    Rel []string
}

// Linker is the interface 
type Linker interface {
    // GetFiles defines absolute and relative files. Returns 
    // an error if there's any.
    GetFiles() error
    // SymLink creates symbolic link from absolute files to 
    // relative files. Returns an error if there's any.
     SymLink() error
    // Delink remove relative files. Returns an error if there's any.
     DelLink() error
}


func (l *Link) GetFiles() (err error) {
    err = filepath.Walk(root, func(path string, f os.FileInfo, err error) error {
        if err != nil {
            return err
        }

        abs, err := filepath.Abs(path)
        if err != nil {
            return err
        }

        if !f.IsDir() {
            home, err := os.UserHomeDir()
            if err != nil {
                return err
            }

            path = strings.ReplaceAll(path, "src/", "")
            path = filepath.Join(home, path)

            l.Abs = append(l.Abs, abs)
            l.Rel = append(l.Rel, path)
        }
        return nil
    })
    if err != nil {
        return err
    }
    return nil
}

func (l Link) SymLink() (err error) {
    for i := range l.Abs {

        parent := filepath.Dir(l.Rel[i])

        err := os.MkdirAll(parent, 0750)
        if err != nil && !os.IsExist(err) {
            return err
        }

        err = os.Symlink(l.Abs[i], l.Rel[i]) 
        if err != nil {
            return err
        }
    }
    return nil
}

func (l Link) DelLink() (err error) {
    for i := range l.Rel {
        err := os.Remove(l.Rel[i])
        if err != nil {
            return err
        }
    }
    return nil
}

// Initialize program flags
func init() {
    f.Bool(
            "u", false,
        "Unlink files",
    )
    f.Parse()
}

// Get flags that have been set
var Flag = func() string {
    var used string
    f.Visit(func(fg *f.Flag) {
        used = fg.Name
    })
    return used
}
