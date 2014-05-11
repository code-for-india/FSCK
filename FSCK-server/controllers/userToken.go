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

type UserToken struct {
}

var UserTokenController UserToken

func (n *UserToken) RegisterUserToken(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Register UserToken Controller")
	view := views.NewView(w)
	session, _, _ := InitCass(w, r)
	userToken := new(model.UserToken)
	uuid := userToken.RegisterUserToken(session)
	result := make(map[string]interface{})
	result["response"] = "ok"
	result["user_token_uid"] = uuid
	view.RenderJson(result)
	return
}

func (n *UserToken) UpdateUserToken(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Update UserToken Controller")
	view := views.NewView(w)
	session, data, _ := InitCass(w, r)
	// user := model.User{}
	requiredFields := []string{"current_post_id", "next_post_id"}
	fmt.Println(r.Body)
	count, err := validate.RequiredData(data, requiredFields)
	if err != nil {
		view.RenderErrorJson(apperror.NewRequiredError(err.Error(), requiredFields[count]))
		return
	}
	userToken := new(model.UserToken)
	userToken.UserTokenId = data["token_id"].(string)
	if data["first_name"] != nil {
		userToken.FirstName = data["first_name"].(string)
		userToken.LastName = data["last_name"].(string)
		userToken.Age, _ = strconv.Atoi(data["age"].(string))
		userToken.Gender = data["gender"].(bool)
		userToken.Address = data["address"].(string)
		userToken.ContactNumber = data["contact_no"].(string)
		userToken.EmergencyContact = data["emergency_contact"].(string)
	}

	userToken.CurrentPostId = data["current_post_id"].(string)
	userToken.NextPostId = data["next_post_id"].(string)
	userToken.UpdateUserToken(session)
	result := make(map[string]interface{})
	result["response"] = "ok"
	view.RenderJson(result)
	return
}

func (n *UserToken) GetUserToken(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Get Checkposts Controller")
	view := views.NewView(w)
	session, _, params := InitCass(w, r)
	// user := model.User{}
	requiredFields := []string{"user_token_id"}
	count, err := validate.RequiredParams(params, requiredFields)
	if err != nil {
		view.RenderErrorJson(apperror.NewRequiredError(err.Error(), requiredFields[count]))
		return
	}
	userTokenId := params.Get("user_token_id")
	// fmt.Println(start, limit)
	userTokens := model.GetUserToken(session, userTokenId)
	view.RenderJson(userTokens)
	return
}

func (n *UserToken) GetUserTokenAtPost(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Get Checkposts Controller")
	view := views.NewView(w)
	session, _, params := InitCass(w, r)
	// user := model.User{}
	requiredFields := []string{"from_post_id", "to_post_id"}
	count, err := validate.RequiredParams(params, requiredFields)
	if err != nil {
		view.RenderErrorJson(apperror.NewRequiredError(err.Error(), requiredFields[count]))
		return
	}
	fromCheckPostId := params.Get("from_post_id")
	toCheckPostId := params.Get("to_post_id")
	userTokens := make([]model.UserToken, 0, 0)
	if len(toCheckPostId) == 0 {
		userTokens = model.GetUserTokenAtCheckPosts(session, fromCheckPostId, "")
	} else {
		userTokens = model.GetUserTokenAtCheckPosts(session, fromCheckPostId, toCheckPostId)
	}
	// fmt.Println(start, limit)

	view.RenderJson(userTokens)
	return
}
