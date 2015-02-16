@patient = new Meteor.Collection "Patient"
schema = new SimpleSchema
  nhc:
    type: String
  name:
    type: String
  surname:
    type: String

patient.attachSchema(schema)

patient.helpers
  fullName: -> this.name + ' ' + this.surname

xCalendar.attachEventSchema
  patientId:
    type: String

xCalendar.setEventHelpers
  patient: ->
    patient.findOne(this.patientId)
