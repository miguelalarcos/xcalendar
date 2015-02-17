UI.registerHelper 'formatDate', (date) ->
  mdate = moment(date).local()
  if mdate
    mdate.format('DD-MM-YYYY')

UI.registerHelper 'formatDateTime', (date) ->
  mdate = moment(date).local()
  if mdate
    mdate.format('DD-MM-YYYY HH:mm')

UI.registerHelper 'formatDateMonthYear', (mdate) ->
  if mdate
    mdate.format('MMM-YYYY')

UI.registerHelper 'formatDateDay', (mdate) ->
  if mdate
    mdate.format('ddd-DD')

UI.registerHelper 'sub', (txt, len)->
    if txt and txt.length > len
      return txt[0..len] + '...'
    else
      return txt