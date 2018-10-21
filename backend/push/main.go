package main

import (
	"context"
	"log"
	"os"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"google.golang.org/api/option"
)

func main() {
	ctx := context.Background()

	title := ""
	body := ""

	if err := SendPushMessage(ctx, title, body); err != nil {
		log.Fatalln(err)
	}
}

const (
	token           = os.Getenv("FCM_TOKEN")
	credential_path = "./credentials.json"
)

func SendPushMessage(ctx context.Context, title, body string) error {
	opt := option.WithCredentialsFile(credential_path)
	app, err := firebase.NewApp(ctx, nil, opt)
	if err != nil {
		return err
	}

	client, err := app.Messaging(ctx)
	if err != nil {
		return err
	}

	message := &messaging.Message{
		Notification: &messaging.Notification{
			Title: title,
			Body:  body,
		},
		Token: token,
		Data: map[string]string{
			"": "",
		},
	}

	res, err := client.Send(ctx, message)
	if err != nil {
		return err
	}
}
