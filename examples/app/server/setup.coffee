if patient.find().count() == 0
  patient.insert
    name: 'Miguel'
    surname: 'Alarcos'

if xcalendar.find().count() == 0
  xcalendar.insert
    name: 'agenda01'
    slotIni: '09:00'
    slotEnd: '12:00'
    duration: 30