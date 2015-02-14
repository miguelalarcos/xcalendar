@clienteCallback = ->
  clienteId: clienteId.get()
  text: cliente.findOne(clienteId.get()).nombre

@renderCitaCliente = (event) ->
  event.clienteId

Template.home.helpers
  calendar: -> xcalendar.get()