package main

import (
	"database/sql"
	"fmt"
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	_ "github.com/lib/pq"
)

const (
	host     = "localhost"
	port     = 5432
	user     = "aboogie"
	password = "fatboy24"
	dbname   = "reactapp"
)

type Todo struct {
	ID    int    `json:"id"`
	Body  string `json:"body"`
	Title string `json:"title"`
	Done  bool   `json:"done"`
}

func db_connection() {
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s password=%s "+
		"dbname=%s sslmode=disable", host, port, user, password, dbname)

	println(psqlInfo)

	db, err := sql.Open("postgres", psqlInfo)
	CheckError(err)

	defer db.Close()

	err = db.Ping()
	CheckError(err)
}

func CheckError(err error) {
	if err != nil {
		panic(err)
	}
}

func InsertStmt(db *sql.DB, body string, title string) {
	sqlStatement := `INSERT INTO Todo (body, title) VALUES ($1, $2)`

	_, err := db.Exec(sqlStatement)
	CheckError(err)
}

func main() {

	db_connection()

	app := fiber.New()

	app.Use(cors.New(cors.Config{
		AllowOrigins: "http://localhost:3000",
		AllowHeaders: "Origin, Content-Type, Accept",
	}))

	todos := []Todo{}

	app.Get("/healthcheck", func(c *fiber.Ctx) error {
		return c.SendString("OK")
	})

	app.Post("/api/todos", func(c *fiber.Ctx) error {
		todo := &Todo{}

		if err := c.BodyParser(todo); err != nil {
			return err
		}

		todo.ID = len(todos) + 1

		todos = append(todos, *todo)

		return c.JSON(todos)

	})

	app.Patch("/api/todos/:id/done", func(c *fiber.Ctx) error {
		id, err := c.ParamsInt("id")

		if err != nil {
			return c.Status(401).SendString("Invalid ID")
		}

		for i, t := range todos {
			if t.ID == id {
				todos[i].Done = true
				break
			}
		}

		return c.JSON(todos)
	})

	app.Get("/api/todos", func(c *fiber.Ctx) error {
		return c.JSON(todos)
	})
	log.Fatal(app.Listen(":4005"))

}
