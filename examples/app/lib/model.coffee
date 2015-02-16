@patient = new Meteor.Collection "Patient"
schema = new SimpleSchema
  nhc:
    type: String
  name:
    type: String
  surname:
    type: String

patient.attachSchema(schema)

xCalendar.attachEventSchema
  patientId:
    type: String

xCalendar.setEventHelpers
  patient: ->
    patient.findOne(this.patientId)