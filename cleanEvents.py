import requests
import json
import time
from datetime import date

def main():
    currentDateTime = time.strftime("%m/%d/%Y")
    getEvents(currentDateTime)

def getEvents(curDate):
    url = "https://ebox86-test.apigee.net/anonyvent"
    apiKey = "26kCJ32CVlb4R5qBH1wEHBEK5GgPABX8"

    response = requests.get("%s/events?apikey=%s" % (url, apiKey), verify=False)
    if response.status_code == 200:
        data = response.json()
        for x in data:
            start = x["startDate"]
            jsonDate = date(start)
            currentDate = date(curDate)
            diff = currentDate - jsonDate
            print(diff.days)
            

main()
