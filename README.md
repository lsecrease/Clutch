# Clutch

Firebase Data Model:

```
{
	"users": {
		"user-id": {
			"admin": true,
			"email": "example@gmail.com"
		}
	},
	
	"games": {
		"dd-mm-yy":{
			"game-id":{
				"category":"NFL",
				"participant-starting-value":50000,
				"location": {
					"lat":12.0000,
					"lon":3.0039
				},
				"venue":"Busch Stadium",
				"startTime":12301239901,
				"endRegistrationTime":10293912093,
				"endGameTime":1923098120398,
				"team1": {
					"name":"team name",
					"players": {
						"player-unique-id":
						{
							"name":"LeBraunny Jamison",
							"number": "1",
							"pointValue": 100000,
							"score":32
						}
					}
					
				},
				"team2": {
					"name":"team 2 name",
					"players": {
						"player-unique-id":
						{
							"name":"David Robinson",
							"number": "3",
							"pointValue": 100000,
							"score":32
						}
					}
				},
				"participant-ranking":[
						"user-id"
					],
				"participants": {
					"user-id": {
						"roster":["player id 1", "player id 2"],
						"score": 1000,
						"check-in-time":"date/time/thing",
						"leave-time":"date/time/thing",
						"disqualified": true
					}
				}
			}
		}
	}
}


```
