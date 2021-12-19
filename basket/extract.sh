#!/bin/bash

DB_NAME="fais"
QUERY="SELECT s.username AS uid, u.unitcode AS course FROM student s, unit u, enrolment e WHERE e.studentid = s.id AND e.unitid = u.unitid;"

sudo -u postgres psql $DB_NAME --csv -c "$QUERY"
