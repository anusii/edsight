#!/bin/bash

DB_NAME="fais"

if [ $# -eq 1 ]; then
    DEGREE=$1
    QUERY="SELECT s.username AS uid, u.unitcode AS course FROM student s, unit u, enrolment e WHERE e.studentid = s.id AND e.unitid = u.unitid AND s.degree='$DEGREE';"
else
    QUERY="SELECT s.username AS uid, u.unitcode AS course FROM student s, unit u, enrolment e WHERE e.studentid = s.id AND e.unitid = u.unitid;"
fi

# echo "$QUERY"

sudo -u postgres psql $DB_NAME --csv -c "$QUERY"
