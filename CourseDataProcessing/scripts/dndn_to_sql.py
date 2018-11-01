import xml.etree.ElementTree as ET
import psycopg2 as P
import sys

def connect():
	if len(sys.argv) < 5:
		print('Missing args. Correct Usage: python dndn_to_sql -dbName -user  -host -password')
	else:
		try:
			conn = P.connect(args[1], args[2], args[3], args[4], args[5])
		except:
			print('error connecting to db')

def parseData():

	tree = ET.parse('../data/data.xml')
	root = tree.getroot()
	
	for course in root:
		courseNumber = course.get('number')
		courseSubject = course.get('subject')
		courseDesc = course.find('description').text
	
		#Get each period
		for periodic in course.findall('periodic'):
			perioidicName = periodic.get('name')
			periodicType = periodic.get('type')
			periodicGroup = periodic.get('group')
			periodicTopic = periodic.find('topic')
			periodicRoom = periodic.find('room')
			periodicInstructor = periodic.find('instructor')

			#Get the periodic time. Can store this in a better date format later.
			for timePeriod in periodic.findall('time'):
				timeDay = periodic.get('day')
				timeTime = periodic.get('time')
				timeDate = periodic.get('date')


connect()
