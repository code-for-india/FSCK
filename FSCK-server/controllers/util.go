package controllers

import (
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/coopernurse/gorp"
	"github.com/gocql/gocql"
	"github.com/mantishK/disaster/config"
	"github.com/mantishK/disaster/models"
	"net/http"
	"net/url"
)

func Init(w http.ResponseWriter, r *http.Request) (*gorp.DbMap, map[string]interface{}, url.Values) {
	dbMap := config.NewConnection()
	var data interface{}
	buf := new(bytes.Buffer)
	buf.ReadFrom(r.Body)
	json.Unmarshal(buf.Bytes(), &data)
	if data == nil {
		return dbMap, nil, r.URL.Query()
	}
	return dbMap, data.(map[string]interface{}), r.URL.Query()
}

func InitCass(w http.ResponseWriter, r *http.Request) (*gocql.Session, map[string]interface{}, url.Values) {
	session := config.NewCassConnection()
	var data interface{}
	buf := new(bytes.Buffer)
	buf.ReadFrom(r.Body)
	json.Unmarshal(buf.Bytes(), &data)
	fmt.Println(data)
	if data == nil {
		return session, nil, r.URL.Query()
	}
	return session, data.(map[string]interface{}), r.URL.Query()
}

func getCheckPost(session *gocql.Session, w http.ResponseWriter, r *http.Request) *model.CheckPost {
	token := new(model.Token)
	token.GetPostId(session)
	checkPost := model.GetCheckPost(session, token.CheckPostId)
	return checkPost
}
