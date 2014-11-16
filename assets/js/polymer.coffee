document.addEventListener "polymer-ready", ->
  navicon = document.getElementById("navicon")
  drawerPanel = document.getElementById("drawerPanel")
  navicon.addEventListener "click", ->
    drawerPanel.togglePanel()
    return
  init()
  return