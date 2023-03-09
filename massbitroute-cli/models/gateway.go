package models

import "time"

type Gateway struct {
	Id          string    `json:"id"`
	UserId      string    `json:"userId"`
	Name        string    `json:"name"`
	Description string    `json:"description"`
	Blockchain  string    `json:"blockchain"`
	Network     string    `json:"network"`
	Zone        string    `json:"zone"`
	AppKey      string    `json:"appKey"`
	Status      string    `json:"status"`
	CreatedAt   time.Time `json:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt"`
	Ip          string    `json:"ip"`
}
