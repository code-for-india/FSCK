package controllers

import (
	"fmt"
	"github.com/gocql/gocql"
	"github.com/mantishK/disaster/core/apperror"
	"github.com/mantishK/disaster/core/validate"
	// "github.com/mantishK/disaster/models"
	"github.com/mantishK/disaster/views"
	"log"
	"net/http"
	"strconv"
	"time"
)

type User struct {
}

var UserController User

func (n *User) RegisterUser(w http.ResponseWriter, r *http.Request) {
	fmt.Println("HEre")
	view := views.NewView(w)
	session, data, _ := InitCass(w, r)
	// user := model.User{}
	requiredFields := []string{"name", "phone", "pass"}
	count, err := validate.RequiredData(data, requiredFields)
	if err != nil {
		view.RenderErrorJson(apperror.NewRequiredError(err.Error(), requiredFields[count]))
		return
	}
	name := data["name"].(string)
	phone, _ := strconv.Atoi(data["phone"].(string))
	pass := data["pass"].(string)

	if err := session.Query(`INSERT INTO user (userid, created, name, phone, pass) VALUES (?, ?, ?, ?, ?)`,
		gocql.TimeUUID(), int32(time.Now().Unix()), name, phone, pass).Exec(); err != nil {
		log.Fatal(err)
	}

}

//
// func (n *Note) GetNotes(w http.ResponseWriter, r *http.Request) {
// 	view := views.NewView(w)
// 	dbMap, _, params := Init(w, r)
// 	note := model.Note{}
// 	requiredFields := []string{"start", "limit"}
// 	count, err := validate.RequiredParams(params, requiredFields)
// 	if err != nil {
// 		view.RenderErrorJson(apperror.NewRequiredError(err.Error(), requiredFields[count]))
// 		return
// 	}
//
// 	start, err := strconv.Atoi(params.Get("start"))
// 	limit, err := strconv.Atoi(params.Get("limit"))
// 	if err != nil {
// 		result := make(map[string]interface{})
// 		result["error"] = err.Error()
// 		result["response"] = "error"
// 		view.RenderJson(result)
// 		return
// 	}
//
// 	notes, len, err := note.Get(dbMap, start, limit)
// 	if err != nil {
// 		result := make(map[string]interface{})
// 		result["error"] = err.Error()
// 		result["response"] = "error"
// 		view.RenderJson(result)
// 		return
// 	}
// 	result := make(map[string]interface{})
// 	result["notes"] = notes
// 	result["count"] = len
// 	result["response"] = "ok"
// 	view.RenderJson(result)
// }
//
// func (n *Note) SaveNotes(w http.ResponseWriter, r *http.Request) {
// 	view := views.NewView(w)
// 	dbMap, data, _ := Init(w, r)
// 	note := model.Note{}
// 	requiredFields := []string{"title", "body"}
// 	count, err := validate.RequiredData(data, requiredFields)
// 	//err := validate.RequiredParams(params, requiredFields)
// 	if err != nil {
// 		view.RenderErrorJson(apperror.NewRequiredError(err.Error(), requiredFields[count]))
// 		// result := make(map[string]interface{})
// 		// result["error"] = err.Error()
// 		// result["response"] = "error"
// 		// view.RenderJson(result)
// 		return
// 	}
// 	note.Content = data["body"].(string)
// 	note.Title = data["title"].(string)
// 	err = note.Save(dbMap)
// 	if err != nil {
// 		result := make(map[string]interface{})
// 		result["error"] = err.Error()
// 		result["response"] = "error"
// 		view.RenderJson(result)
// 		return
// 	}
// 	result := make(map[string]interface{})
// 	result["response"] = "ok"
// 	view.RenderJson(result)
// }
