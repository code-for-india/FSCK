package model

import (
	// "github.com/coopernurse/gorp"
	// "time"
	"fmt"
	"github.com/gocql/gocql"
	"log"
)

type Token struct {
	CheckPostId string
	TokenId     string
}

func (m *Token) AddToken(session *gocql.Session) {
	tokenId := gocql.TimeUUID()
	if err := session.Query(`INSERT INTO token_login (token_id,check_post_id) VALUES (?,?)`, tokenId, m.CheckPostId).Exec(); err != nil {
		fmt.Println(err)
		log.Fatal(err)
	}
	m.TokenId = tokenId.String()
}

func (m *Token) GetPostId(session *gocql.Session) {
	token := new(Token)
	if err := session.Query("SELECT token_id, check_post_id FROM token_login WHERE token_id = ?",
		m.TokenId).Consistency(gocql.One).Scan(&token.TokenId, &token.CheckPostId); err != nil {
		log.Fatal(err)
	}
}
