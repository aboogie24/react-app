package main 

import (
	"fmt"
	"log"
	"github.com/gofiber/fiber/v2"
) 

type Todo struct { 
	ID int `json:"id"`
	Body string `json:"body"`
	Title string `json:"title"`
	Done bool `json:"done"`
}

func main(){ 
	fmt.Print("Hello World")

	app := fiber.New()

	app.Get("/healthcheck", func(c *fiber.Ctx) error {
		return c.SendString("OK")
	})



	log.Fatal(app.Listen(":4000"))

}