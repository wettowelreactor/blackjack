# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @initGame()

  initGame: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @listenTo @get('playerHand'), 'scoreGame', (params) -> @trigger('scoreGame', params)
    @listenTo @get('playerHand'), 'stand', -> @get('dealerHand').play()
    @listenTo @get('dealerHand'), 'scoreGame', -> @trigger('scoreGame')


