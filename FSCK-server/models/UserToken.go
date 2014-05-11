package model

import (
	// "github.com/coopernurse/gorp"
	"fmt"
	"github.com/gocql/gocql"
	"log"
	"time"
)

type UserToken struct {
	UserTokenId      string
	FirstName        string
	LastName         string
	Address          string
	Gender           bool
	Age              int
	ContactNumber    string
	EmergencyContact string
	CurrentPostId    string
	NextPostId       string
	Created          int64
	Modified         int64
}

func GetUserToken(session *gocql.Session, UserTokenId string) *UserToken {
	userToken := new(UserToken)
	if err := session.Query("SELECT user_token_id, first_name, last_name, address, gender, age, contact_number, emergency_contact, current_post_id, next_post_id, created, modified FROM user_token WHERE user_token_id = ?",
		UserTokenId).Consistency(gocql.One).Scan(&userToken.UserTokenId, &userToken.FirstName, &userToken.LastName, &userToken.Address, &userToken.Gender, &userToken.Age, &userToken.ContactNumber, &userToken.EmergencyContact, &userToken.CurrentPostId, &userToken.NextPostId, &userToken.Created, &userToken.Modified); err != nil {
		log.Fatal(err)
	}
	return userToken
}

func GetUserTokenAtCheckPosts(session *gocql.Session, fromCheckPostId, toCheckPostId string) []UserToken {
	userTokens := make([]UserToken, 0, 0)
	var iter *gocql.Iter
	if len(toCheckPostId) == 0 {
		iter = session.Query("SELECT user_token_id, first_name, last_name, address, gender, age, contact_number, emergency_contact, current_post_id, next_post_id, created, modified FROM user_token WHERE current_post_id = ? ALLOW FILTERING",
			fromCheckPostId).Iter()
	} else {
		iter = session.Query("SELECT user_token_id, first_name, last_name, address, gender, age, contact_number, emergency_contact, current_post_id, next_post_id, created, modified FROM user_token WHERE current_post_id = ? AND next_post_id = ? ALLOW FILTERING", fromCheckPostId, toCheckPostId).Iter()
	}

	var userToken UserToken

	for iter.Scan(&userToken.UserTokenId, &userToken.FirstName, &userToken.LastName, &userToken.Address, &userToken.Gender, &userToken.Age, &userToken.ContactNumber, &userToken.EmergencyContact, &userToken.CurrentPostId, &userToken.NextPostId, &userToken.Created, &userToken.Modified) {

		userTokens = append(userTokens, userToken)
	}

	if err := iter.Close(); err != nil {
		log.Fatal(err)
	}
	fmt.Println("from model", userToken)
	return userTokens
}

func (m *UserToken) RegisterUserToken(session *gocql.Session) string {
	m.Created = int64(time.Now().Unix())
	m.Modified = int64(time.Now().Unix())
	timeUuid := gocql.TimeUUID()
	if err := session.Query(`INSERT INTO user_token (user_token_id, first_name, last_name, address, gender, age, contact_number, emergency_contact, current_post_id, next_post_id, created, modified) VALUES (?, ?, ?, ?, ?,?,?,?,?,?,?,?)`,
		timeUuid, m.FirstName, m.LastName, m.Address, m.Gender, m.Age, m.ContactNumber, m.EmergencyContact, gocql.TimeUUID(), gocql.TimeUUID(), m.Created, m.Modified).Exec(); err != nil {
		fmt.Println(err)
		log.Fatal(err)
	}
	return timeUuid.String()
}

func (m *UserToken) UpdateUserToken(session *gocql.Session) {
	m.Modified = int64(time.Now().Unix())
	if len(m.FirstName) != 0 {
		if err := session.Query(`UPDATE user_token SET first_name = ?, last_name = ?, address = ?, gender = ?, age = ?, contact_number = ?, emergency_contact = ?, current_post_id, next_post_id=?, modified=? WHERE post_id = ?`,
			m.FirstName, m.LastName, m.Address, m.Gender, m.Age, m.ContactNumber, m.EmergencyContact, m.CurrentPostId, m.NextPostId, m.Modified).Exec(); err != nil {
			log.Fatal(err)
		}
	} else {
		if err := session.Query(`UPDATE user_token SET current_post_id, next_post_id=?, modified=? WHERE post_id = ?`,
			m.NextPostId, m.Modified).Exec(); err != nil {
			log.Fatal(err)
		}
	}
}

// func ()
//
// func (n *Note) Get(dbMap *gorp.DbMap, start, limit int) ([]Note, int, error) {
// 	notes := []Note{}
// 	_, err := dbMap.Select(&notes, "SELECT * FROM note ORDER BY modified DESC LIMIT ?,?", start, limit)
// 	if err != nil {
// 		return nil, 0, err
// 	}
// 	return notes, len(notes), nil
// }
//
// func (n *Note) Save(dbMap *gorp.DbMap) error {
// 	n.Created = time.Now().Unix()
// 	n.Modified = time.Now().Unix()
// 	err := dbMap.Insert(n)
// 	if err != nil {
// 		return err
// 	}
// 	return nil
// }
