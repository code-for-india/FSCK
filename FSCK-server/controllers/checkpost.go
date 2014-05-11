package controllers

import (
	"fmt"
	// "github.com/gocql/gocql"
	"github.com/mantishK/disaster/core/apperror"
	"github.com/mantishK/disaster/core/validate"
	"github.com/mantishK/disaster/models"
	"github.com/mantishK/disaster/views"
	// "log"
	"net/http"
	"strconv"
	// "time"
)

type CheckPost struct {
}

var CheckPostController CheckPost

func (n *CheckPost) RegisterCheckPost(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Register Checkpost Controller")
	view := views.NewView(w)
	session, data, _ := InitCass(w, r)
	// user := model.User{}
	requiredFields := []string{"pass", "region", "name", "longitude", "latitude", "contact_no"}
	count, err := validate.RequiredData(data, requiredFields)
	if err != nil {
		view.RenderErrorJson(apperror.NewRequiredError(err.Error(), requiredFields[count]))
		return
	}
	checkPost := new(model.CheckPost)
	checkPost.Pass = data["pass"].(string)
	checkPost.Name = data["name"].(string)
	checkPost.Region, _ = strconv.Atoi(data["region"].(string))
	checkPost.Longitude, err = strconv.ParseFloat(data["longitude"].(string), 64)
	checkPost.Latitude, err = strconv.ParseFloat(data["latitude"].(string), 64)
	checkPost.ContactNo = data["contact_no"].(string)
	checkPost.CreateCheckPost(session)
	result := make(map[string]interface{})
	result["response"] = "ok"
	view.RenderJson(result)
	return
}

func (n *CheckPost) GetCheckPosts(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Get Checkposts Controller")
	view := views.NewView(w)
	session, _, params := InitCass(w, r)
	// user := model.User{}
	requiredFields := []string{"start", "count"}
	count, err := validate.RequiredParams(params, requiredFields)
	if err != nil {
		view.RenderErrorJson(apperror.NewRequiredError(err.Error(), requiredFields[count]))
		return
	}
	start, _ := strconv.Atoi(params.Get("start"))
	limit, _ := strconv.Atoi(params.Get("count"))
	checkPosts := make([]model.CheckPost, 0, 0)
	if len(params.Get("region")) != 0 {
		region, _ := strconv.Atoi(params.Get("region"))
		fmt.Println(start, limit)
		checkPosts = model.GetCheckPosts(session, start, limit, region)
	} else {
		fmt.Println(start, limit)
		checkPosts = model.GetCheckPosts(session, start, limit, 0)
	}
	view.RenderJson(checkPosts)
	return
}

func (n *CheckPost) GetCheckPost(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Get Checkpost Controller")
	view := views.NewView(w)
	session, _, params := InitCass(w, r)
	// user := model.User{}
	requiredFields := []string{"id"}
	count, err := validate.RequiredParams(params, requiredFields)
	if err != nil {
		view.RenderErrorJson(apperror.NewRequiredError(err.Error(), requiredFields[count]))
		return
	}
	id := params.Get("id")
	checkPost := model.GetCheckPost(session, id)
	view.RenderJson(checkPost)
	return
}
