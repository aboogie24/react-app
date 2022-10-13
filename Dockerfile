FROM golang:alpine3.16 AS base 

WORKDIR /app/

FROM base AS modules 
COPY ./server/go.mod . 
COPY ./server/go.sum . 
RUN go mod download

FROM modules as build 

COPY ./server/main.go . 
RUN CGO_ENABLED=0 GOOS=linux go build -a -o bin/react-app

FROM gcr.io/distroless/base:latest

WORKDIR /app/ 

COPY --from=build /app/bin/react-app . 

USER 1000 


ENTRYPOINT [ "/app/react-app" ]

CMD ["serve"]

# RUN ls 

# RUN go build -o /react-app 

# EXPOSE 4000 

# CMD [ "/react-app" ]
