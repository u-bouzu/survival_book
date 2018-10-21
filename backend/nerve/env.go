package main

import (
	"fmt"
	"os"

	"github.com/pkg/errors"
)

type TwitterEnv struct {
	AccessToken       string
	AccessTokenSecret string
	ConsumerKey       string
	ConsumerSecret    string
}

func SetEnv() (*TwitterEnv, error) {
	conKey, err := lookUpEnv("CON_KEY_TW")
	if err != nil {
		return nil, errors.Wrap(err, "consumer key not found")
	}
	conSecretKey, err := lookUpEnv("CON_SECRET_KEY_TW")
	if err != nil {
		return nil, errors.Wrap(err, "consumer secret key not found")
	}
	accessKey, err := lookUpEnv("ACCESS_KEY_TW")
	if err != nil {
		return nil, errors.Wrap(err, "access key not found")
	}
	accessSecretKey, err := lookUpEnv("ACCESS_SECRET_KEY_TW")
	if err != nil {
		return nil, errors.Wrap(err, "access secret key not found")
	}

	return &TwitterEnv{
		AccessToken:       accessKey,
		AccessTokenSecret: accessSecretKey,
		ConsumerKey:       conKey,
		ConsumerSecret:    conSecretKey,
	}, nil
}

func lookUpEnv(key string) (string, error) {
	env, ok := os.LookupEnv(key)
	if !ok {
		return "", fmt.Errorf("%s is invalid token key", key)
	}
	return env, nil
}
