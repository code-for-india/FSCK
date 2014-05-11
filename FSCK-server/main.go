package main

import (
	"github.com/mantishK/disaster/controllers"
	"github.com/mantishK/disaster/core/router"
	"github.com/mantishK/disaster/filters"
	"log"
	"net/http"
)

func main() {
	route()
}
func route() {
	//Create filters
	authenticateFilter := new(filters.Authenticate)
	authorizeFilter := new(filters.Authorize)

	//Create controller
	// noteController := controllers.NoteController
	checkPostController := controllers.CheckPostController
	userTokenController := controllers.UserTokenController
	//Create Router
	myRouter := router.New()

	//route

	myRouter.Post("/chehckpost", checkPostController.RegisterCheckPost, authenticateFilter, authorizeFilter)
	myRouter.Get("/checkpost/all", checkPostController.GetCheckPosts, authenticateFilter, authorizeFilter)
	myRouter.Get("/checkpost", checkPostController.GetCheckPost, authenticateFilter, authorizeFilter)

	myRouter.Post("/usertoken", userTokenController.RegisterUserToken, authenticateFilter, authorizeFilter)
	myRouter.Post("/usertoken/update", userTokenController.UpdateUserToken, authenticateFilter, authorizeFilter)
	myRouter.Get("/usertoken/checkposts", userTokenController.GetUserTokenAtPost, authenticateFilter, authorizeFilter)
	myRouter.Get("/usertoken", userTokenController.GetUserToken, authenticateFilter, authorizeFilter)

	http.Handle("/", myRouter)
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatalln(err)
	}
}
