FROM golang:alpine3.16


COPY ./server/ . 

WORKDIR /server

RUN go mod download 

RUN go build -o /react-app 

EXPOSE 4000 

CMD [ "/react-app" ]
