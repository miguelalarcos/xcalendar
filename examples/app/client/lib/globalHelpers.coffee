UI.registerHelper 'formatDate', (mdate) ->
  if mdate
    mdate.format('DD-MM-YYYY')