print("Jobly SelfBuild system print("Jobly SelfBuild system initialized.")

import json
from datetime import datetime

def load_survey_data():
    with open("survey-data.json", "r") as file:
        data = json.load(file)
    return data

def save_survey_data(data):
    with open("survey-data.json", "w") as file:
        json.dump(data, file, indent=4)

def add_survey_response(response):
    data = load_survey_data()
    data["surveys"].append({"response": response, "timestamp": str(datetime.now())})
    save_survey_data(data)
    print("Survey response saved successfully.")

if __name__ == "__main__":
    add_survey_response("Example survey input.")
