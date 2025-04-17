package main

import (
	"log"
	"os"

	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
)

func main() {
	app := pocketbase.New()
	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		// serves static files from the provided public dir (if exists)
		se.Router.GET("/{path...}", apis.Static(os.DirFS("./pb_public"), false))

		return se.Next()
	})

	app.OnRecordAfterCreateSuccess("projects").BindFunc(func(e *core.RecordEvent) error {
		collection, err := app.FindCollectionByNameOrId("boards")
		if err != nil {
			return err
		}

		log.Println("creating board for project", e.Record.Id)
		boardRecord := core.NewRecord(collection)
		boardRecord.Set("project", e.Record.Id)

		// validate and persist
		// (use SaveNoValidate to skip fields validation)
		err = app.Save(boardRecord)
		if err != nil {
			log.Println(err)
			return err
		}
		ids, err := createCategories(boardRecord.Id, app)
		if err != nil {
			return err
		}
		if ids != nil {
			boardRecord.Set("categories", ids)
			err = app.Save(boardRecord)
			if err != nil {
				return err
			}
		}
		// validate and persist
		// (use SaveNoValidate to skip fields validation)
		projectRecord, err := app.FindRecordById("projects", e.Record.Id)
		if err != nil {
			return err
		}
		projectRecord.Set("board", boardRecord.Id)

		err = app.Save(projectRecord)
		if err != nil {
			log.Println(err)
			return err
		}

		log.Println("created board for project", e.Record.Id)

		return e.Next()
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}

func createCategories(board string, app *pocketbase.PocketBase) ([]string, error) {
	collection, err := app.FindCollectionByNameOrId("categories")
	if err != nil {
		return nil, err
	}
	titles := []string{"To Do", "In Pogress", "Done"}
	colors := []int{4294901760, 4278190335, 4278255360}
	icons := []int{58245, 57537, 58950}
	ids := []string{}
	app.RunInTransaction(func(txApp core.App) error {
		for i, title := range titles {
			record := core.NewRecord(collection)
			record.Set("name", title)
			record.Set("position", i)
			record.Set("board", board)
			record.Set("color", colors[i])
			record.Set("icon",icons[i])
			if err := txApp.Save(record); err != nil {
				return err
			}
			ids = append(ids, record.Id)
		}
		return nil
	})
	return ids, nil
}
