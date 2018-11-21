import re
import json

# This is the json file that will be returned
# Can change the function to return it if that is more convenient
JSONFILE = "schedule.json"

# Text file used for testing
TEXT = "test.txt"
debug = True

def findClasses(textInput):
	course = {}
	sched = {}
	if debug: print("Input:")
	with open(textInput, "r") as file:
		for line in file:
			m = re.match(r"(?P<CourseCode>\w{3,4})\s?(?P<CourseNum>\d{3}\w?)\s?[-|~]\s?(?P<Section>\w{2,3})", line)
			if m:
				if debug: print(m.groups())
				courseCode = str(m.group("CourseCode"))
				courseNum = str(m.group("CourseNum"))
				courseSec = str(m.group("Section"))
				if courseSec.find("8") == 0 and len(courseSec) > 2 :
					x = courseSec.find("8")
					courseSec = "B" + courseSec[x+1:]
				if courseSec.find("O") > -1:
					x = courseSec.find("O")
					courseSec = courseSec[:x] + "0" + courseSec[x+1:]
				key = courseCode + courseNum + "-"+ courseSec
				course[key] = {
					"CourseCode" : courseCode,
					"CourseNum" : courseNum,
					"Section" : courseSec
				}
				sched.update(course)
				
	with open(JSONFILE, "w") as file:
		json.dump(sched, file)
	if debug: print("Classes found:")
	if debug: print(json.dumps(sched))

# Test the function
m = findClasses(TEXT)