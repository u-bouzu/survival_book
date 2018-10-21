package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"time"

	"github.com/dghubble/go-twitter/twitter"
	"github.com/dghubble/oauth1"
	"github.com/go-playground/validator"
	"github.com/labstack/echo"
	"github.com/labstack/gommon/log"
)

type SuccessResponse struct {
	Text string `json:"text"`
}

type BadResponse struct {
	Err    string `json:"err"`
	Status string `json:"status"`
}

func CustomSuccessResponse(text string) SuccessResponse {
	return SuccessResponse{
		Text: text,
	}
}

func CustomBadResponse(err error) BadResponse {
	return BadResponse{
		Status: "ERROR",
		Err:    fmt.Sprintf("%v", err),
	}
}

type CustomValidator struct {
	Validator *validator.Validate
}

func (cv *CustomValidator) Validate(i interface{}) error {
	return cv.Validator.Struct(i)
}

var (
	env *TwitterEnv
)

func init() {
	var err error
	env, err = SetEnv()
	if err != nil {
		fmt.Fprintln(os.Stderr, "err")
		os.Exit(1)
	}
}

func main() {
	e := echo.New()
	e.Validator = &CustomValidator{
		Validator: validator.New(),
	}
	e.Logger.SetLevel(log.INFO)
	e.GET("/disaster/info", disasterHandler)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Start server
	go func() {
		if err := e.Start(":" + port); err != nil {
			e.Logger.Info("shut down the server")
		}
	}()

	quit := make(chan os.Signal)
	signal.Notify(quit, os.Interrupt)
	<-quit
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	if err := e.Shutdown(ctx); err != nil {
		e.Logger.Fatal(err)
	}

}

func disasterHandler(c echo.Context) error {
	config := oauth1.NewConfig(env.ConsumerKey, env.ConsumerSecret)
	token := oauth1.NewToken(env.AccessToken, env.AccessTokenSecret)
	httpClient := config.Client(oauth1.NoContext, token)

	client := twitter.NewClient(httpClient)
	tweets, resp, err := client.Timelines.UserTimeline(&twitter.UserTimelineParams{
		UserID: 116548789, //特務機関NERV
		Count:  1,
	})
	if err != nil {
		return c.JSON(http.StatusInternalServerError, CustomBadResponse(err))
	}
	_ = resp

	return c.JSON(http.StatusOK, CustomSuccessResponse(tweets[0].Text))
}
