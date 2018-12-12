import xml.etree.ElementTree as ET
import sys, datetime, json, urllib, os

# Script to grab course data from http://dndn.ethv.net (easier than from peoplesoft). Dndn devs said its alright to use
# their data but requested that we use our own server to reduce load on theirs. Also, since we are grabbing it anyway
# im converting to json for ease of use and making it way smaller.

DNDN_TERMLIST = 'http://dndn.ethv.net/database/termlist.xml'
DNDN_COURSE_PREFIX = 'http://dndn.ethv.net/database/'
TMP_XML_PATH_PREFIX = '/tmp/'
OUTPUT_FOLDER = '../public/course-data/'


def scrape_data():
    # Check for output directory (and create if needed)
    if not os.path.exists(os.path.dirname(OUTPUT_FOLDER)):
        try:
            os.makedirs(os.path.dirname(OUTPUT_FOLDER))
        except OSError as exc:  # Guard against race condition
            if exc.errno != errno.EEXIST:
                raise

    # Get terms
    contents = urllib.urlopen(DNDN_TERMLIST).read()
    term_data = parse_termlist(contents)
    with open(OUTPUT_FOLDER + 'terms.json', 'w+') as file:
        file.write(json.dumps(term_data))

    # Get and write each term to .json
    print('writing term...')
    for term in term_data:
        name = term['name']
        print(name)
        data = parse_data(get_term(name), name)
        with open(OUTPUT_FOLDER + 'courses-' + name + '.json', 'w+') as file:
            file.write(json.dumps(data, separators=(',', ':'))) # dump minified json


# Get xml for term from dndn and return a path to local copy
def get_term(name):
    path = TMP_XML_PATH_PREFIX + name + '.xml'
    urllib.urlretrieve(DNDN_COURSE_PREFIX + name + '.xml', path)
    return path


# Parse term list from dndn into dictionary
def parse_termlist(termlistxml):
    root = ET.fromstring(termlistxml)

    terms = []

    for term in root:
        name = term.get('name')
        desc = term.get('desc')

        terms.append({
            'name': name,
            'desc': desc
        })

    return terms


# Parse course data from dndn into dictionary
def parse_data(pathtoinput, semester):
    tree = ET.parse(pathtoinput)
    root = tree.getroot()

    courses = {}

    for course in root:
        course_number = course.get('number')
        course_subject = course.get('subject')
        course_desc = course.find('description').text
        periodics = {}

        courses[course_subject + ' ' + course_number] = {
            'number': course_number,
            'subject': course_subject,
            'description': course_desc,
            'periodics': periodics
        }

        # Get each period
        for periodic in course.findall('periodic'):
            periodic_name = periodic.get('name')
            periodic_type = periodic.get('type')
            periodic_group = periodic.get('group')
            periodic_topic = periodic.find('topic')
            periodic_room = periodic.find('room')
            periodic_instructor = periodic.find('instructor')
            time_periods = []

            periodics[periodic_type + ' ' + periodic_name] = {
                'name': periodic_name,
                'type': periodic_type,
                'group': periodic_group,
                'topic': periodic_topic or '',
                'room': periodic_room or '',
                'instructor': periodic_instructor or '',
                'time-periods': time_periods
            }

            # Get the periodic time
            for time_period in periodic.findall('time'):
                time_day = time_period.get('day')
                time_time = time_period.get('time')
                time_date = time_period.get('date')

                time_periods.append({
                    'day': time_day,
                    'time': time_time,
                    'date': time_date
                })

            # End time period loop
        # End periodic loop
    # End course loop

    course_data = {
        'version': datetime.datetime.now().strftime('%d/%m/%Y'),
        'semester': semester,
        'courses': courses
    }

    return course_data


scrape_data()
