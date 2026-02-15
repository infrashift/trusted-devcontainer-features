package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"text/template"
)

type Option struct {
	Type        string      `json:"type"`
	Proposals   []string    `json:"proposals"`
	Default     interface{} `json:"-"`
	Description string      `json:"description"`
	rawDefault  json.RawMessage
}

type Feature struct {
	Name              string                 `json:"name"`
	ID                string                 `json:"id"`
	Version           string                 `json:"version"`
	Description       string                 `json:"description"`
	Options           map[string]Option      `json:"options"`
	Customizations    map[string]interface{} `json:"customizations,omitempty"`
	PostCreateCommand string                 `json:"postCreateCommand,omitempty"`
	InstallsAfter     []string               `json:"installsAfter"`
}

func (f *Feature) UnmarshalJSON(data []byte) error {
	type Alias Feature
	aux := &struct {
		Options map[string]struct {
			Option
			RawDefault json.RawMessage `json:"default"`
		} `json:"options"`
		*Alias
	}{
		Alias: (*Alias)(f),
	}
	if err := json.Unmarshal(data, &aux); err != nil {
		return err
	}

	f.Options = make(map[string]Option) // Add this line to initialize the Options map

	for key, optionWithRawDefault := range aux.Options {
		option := optionWithRawDefault.Option
		rawDefault := optionWithRawDefault.RawDefault
		switch option.Type {
		case "string":
			var value string
			if err := json.Unmarshal(rawDefault, &value); err != nil {
				return err
			}
			option.Default = value
		case "boolean":
			var value bool
			if err := json.Unmarshal(rawDefault, &value); err != nil {
				return err
			}
			option.Default = value
		default:
			return fmt.Errorf("unsupported type: %s", option.Type)
		}
		f.Options[key] = option
	}

	return nil
}

func removeComments(data []byte) []byte {
	scanner := bufio.NewScanner(bytes.NewReader(data))
	var result []string
	commentRegexp := regexp.MustCompile(`^\s*//.*$`)
	for scanner.Scan() {
		line := scanner.Text()
		if !commentRegexp.MatchString(line) {
			result = append(result, line)
		}
	}
	return []byte(strings.Join(result, "\n"))
}

func main() {
	searchDir := "."

	templateFile, err := ioutil.ReadFile("feature-README.template")
	if err != nil {
		fmt.Printf("Error reading template file: %v\n", err)
		os.Exit(1)
	}
	mdTemplateStr := string(templateFile)

	err = filepath.Walk(searchDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if info.IsDir() || filepath.Base(path) != "devcontainer-feature.json" {
			return nil
		}

		data, err := ioutil.ReadFile(path)
		if err != nil {
			return err
		}

		dataWithoutComments := removeComments(data) // Remove comments before unmarshalling

		var feature Feature
		err = json.Unmarshal(dataWithoutComments, &feature)
		if err != nil {
			fmt.Printf("Warning: Error parsing file %s: %v\n", path, err)
			return nil
		}

		funcMap := template.FuncMap{
			"join": strings.Join,
		}

		tmpl, err := template.New("mdTemplate").Funcs(funcMap).Parse(mdTemplateStr)
		if err != nil {
			return err
		}

		readmePath := filepath.Join(filepath.Dir(path), "README.md")
		readmeFile, err := os.Create(readmePath)
		if err != nil {
			return err
		}
		defer readmeFile.Close()

		err = tmpl.Execute(readmeFile, feature)

		if err != nil {
			return err
		}

		// Check for NOTES.md and append its content
		notesPath := filepath.Join(filepath.Dir(path), "NOTES.md")
		if _, err := os.Stat(notesPath); !os.IsNotExist(err) {
			notesContent, err := ioutil.ReadFile(notesPath)
			if err != nil {
				fmt.Printf("Warning: Error reading NOTES.md file %s: %v\n", notesPath, err)
			} else {
				readmeFile.WriteString("\n---\n\n")
				readmeFile.Write(notesContent)
			}
		}

		fmt.Printf("Generated README.md for %s\n", path)
		return nil
	})

	if err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}
}
