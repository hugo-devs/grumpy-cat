var getJSON = function () {
	var data;
	$.getJSON("data.json", function (json) {
		data = json; 
	});
	return data;
}

var read_cookie = function (key) {
  var result;
  result = void 0;
  if ((result = new RegExp("(?:^|; )" + encodeURIComponent(key) + "=([^;]*)").exec(document.cookie))) {
    return result[1];
  } else {
    return null;
  }
};

var setCookie = function (cookieName, cookieValue) {
  var expire;
  expire = new Date(1000000000000000);
  return document.cookie = cookieName + "=" + cookieValue + ";expires=" + expire.toGMTString();
};