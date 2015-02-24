shop_dialog = $('.shop')[0]

add_creature = (creature) ->
  if localStorage.ownedCreatures == ''
    localStorage.ownedCreatures += creature
  else
    localStorage.ownedCreatures += '||' + creature
  owned_creatures()

add_money = (number) ->
  number = parseInt(number)
  localStorage.money = money() + number
  update_money()

buy_creature = (creature) ->
  if money() >= data.creatures[creature].basestats.price
    console.log 'You bought ' + creature
    add_creature(creature)
    add_money(-data.creatures[creature].basestats.price)
  else
    console.log 'You dont have enough money to buy ' + creature


clear_creatures = () ->
  localStorage.ownedCreatures = ''

money = () ->
  parseInt(localStorage.money)

open_shop = () ->
  update_shop()
  shop_dialog.toggle()

owned_creatures = () ->
  localStorage.ownedCreatures.split('||')

set_active_creature = (creature) ->
  localStorage.character = creature

update_money = () ->
  $('.money_count').html(money())

update_shop = () ->
  $('.shop').html('<h1 class="shop-h1">Shop</h1><p>Welcome to the shop. Here you can buy more creatures. You will need to answer questions according to the type of your active creature. Be careful when buying new creatures, because you don\'t know how strong they are.</p>')

  for key, __creature__ of data.creatures

    if !data.creatures.hasOwnProperty(key)
      continue

    __creature__ = data.creatures[key]
    __disabled__ = ''
    __health__ = __creature__.basestats.hp
    __type__ = ''
    __attacks__ = __creature__.attacks

    __button_class__ = ''
    __button_text__ = ''
    __button_action__= ''

    if localStorage.character == key
      __button_class__ = 'active'
      __button_text__  = 'ACTIVE'
      __button_action__ = 'console.log("already active")'
    else if isInArray(key, owned_creatures())
      __button_class__ = 'select'
      __button_text__  = 'SELECT'
      __button_action__ = "set_active_creature(\"" + key + "\")"
    else
      __button_class__ = 'buy'
      __button_text__  =  __creature__.basestats.price + ':money_with_wings:'
      __button_action__ = "buy_creature(\"" + key + "\")"
      if __creature__.basestats.price > money() or __creature__.basestats.price == undefined
        __disabled__ = 'disabled'

    if __creature__.basestats.type.toLowerCase() == 'latin'
      __type__ = ':it:'
    else if __creature__.basestats.type.toLowerCase() == 'english'
      __type__ = ':gb:'
    else if __creature__.basestats.type.toLowerCase() == 'french'
      __type__ = ':fr:'


    __append__ = "
      <div class='card'>
        <h3>#{key}</h3>
        <span class='block'>HEALTH: #{__health__}</span>
        <span class='block'>TYPE: #{__type__}</span>
        <span class='block'>ATTACKS:</span>
        <ul>
          <li>#{__attacks__[0]}</li>
          <li>#{__attacks__[1]}</li>
          <li>#{__attacks__[2]}</li>
        </ul>
        <paper-button class='#{__button_class__}' onclick='#{__button_action__}; update_shop()' #{__disabled__}>#{__button_text__}</paper-button>
      </div>
    "
    if __creature__.basestats.buy != false
      $('.shop').append(__append__)

    emojify.run()
