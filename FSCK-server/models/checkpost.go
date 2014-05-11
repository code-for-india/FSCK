package model

import (
	// "github.com/coopernurse/gorp"
	"fmt"
	"github.com/gocql/gocql"
	"log"
	"time"
)

type CheckPost struct {
	PostId    string
	Name      string
	Pass      string
	Region    int
	Longitude float64
	Latitude  float64
	ContactNo string
	Created   int64
	Modified  int64
}

func GetCheckPost(session *gocql.Session, postId string) *CheckPost {
	checkPost := new(CheckPost)
	var lat float32
	var lon float32
	if err := session.Query("SELECT post_id, name, pass, region, longitude, latitude, contact_no, created, modified FROM checkpost WHERE post_id = ? ALLOW FILTERING ",
		postId).Consistency(gocql.One).Scan(&checkPost.PostId, &checkPost.Name, &checkPost.Pass, &checkPost.Region, &lon, &lat, &checkPost.ContactNo, &checkPost.Created, &checkPost.Modified); err != nil {
		log.Fatal(err)
	}
	checkPost.Longitude = float64(lon)
	checkPost.Latitude = float64(lat)
	return checkPost
}

func GetCheckPosts(session *gocql.Session, from int, count int, region int) []CheckPost {
	checkPosts := make([]CheckPost, 0, 0)
	var iter *gocql.Iter
	if region == 0 {
		iter = session.Query("SELECT post_id, name, pass, region, longitude, latitude, contact_no, created, modified FROM checkpost LIMIT ? ALLOW FILTERING",
			count).Iter()
	} else {
		iter = session.Query("SELECT post_id, name, pass, region, longitude, latitude, contact_no, created, modified FROM checkpost WHERE region = ? LIMIT ? ALLOW FILTERING",
			region, count).Iter()
	}

	var checkPost CheckPost
	fmt.Println(count)
	var latitude, longitude float32

	for iter.Scan(&checkPost.PostId, &checkPost.Name, &checkPost.Pass, &checkPost.Region, &longitude, &latitude, &checkPost.ContactNo, &checkPost.Created, &checkPost.Modified) {
		fmt.Println(checkPost)
		checkPost.Latitude = float64(latitude)
		checkPost.Longitude = float64(longitude)
		checkPosts = append(checkPosts, checkPost)
	}

	if err := iter.Close(); err != nil {
		log.Fatal(err)
	}
	fmt.Println("from model", checkPosts)
	return checkPosts
}

func (m *CheckPost) CreateCheckPost(session *gocql.Session) {
	m.Created = int64(time.Now().Unix())
	m.Modified = int64(time.Now().Unix())
	if err := session.Query(`INSERT INTO checkpost (post_id, name, pass, region, longitude, latitude, contact_no, created, modified) VALUES (?, ?, ?, ?, ?,?,?,?,?)`,
		gocql.TimeUUID(), m.Name, m.Pass, m.Region, float32(m.Longitude), float32(m.Latitude), m.ContactNo, m.Created, m.Modified).Exec(); err != nil {
		fmt.Println(err)
		log.Fatal(err)
	}
}

func (m *CheckPost) UpdateCheckPost(session *gocql.Session, checkPost *CheckPost) {
	checkPost.Modified = int64(time.Now().Unix())
	if err := session.Query(`UPDATE checkpost SET longitude = ?, latitude = ?, contact_no = ?, created = ?, modified = ? WHERE post_id = ?`,
		checkPost.Longitude, checkPost.Latitude, checkPost.ContactNo, checkPost.Created, checkPost.Modified, checkPost.PostId).Exec(); err != nil {
		log.Fatal(err)
	}
}
