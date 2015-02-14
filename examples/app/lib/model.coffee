@patient = new Meteor.Collection "Patient"
schema = new SimpleSchema
  name:
    type: String
  surname:
    type: String

patient.attachSchema(schema)