get_JSON = ->
  data = undefined
  $.getJSON "data.json", (json) ->
    data = json
  data

read_cookie = (key) ->
  result = undefined
  result = undefined
  if result = new RegExp("(?:^|; )" + encodeURIComponent(key) + "=([^;]*)").exec(document.cookie)
    result[1]
  else
    undefined

set_cookie = (cookieName, cookieValue) ->
  expire = undefined
  expire = new Date(1000000000000000)
  document.cookie = cookieName + "=" + cookieValue + ";expires=" + expire.toGMTString()

load_cookies = ->
  console.log "loading cookies in to cookies obj"
  __to_load = ["name"]
  for key in __to_load
    cookies[key] = read_cookie(key)