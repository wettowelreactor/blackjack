# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @initGame()

  initGame: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @set 'splitHand', null
    @set 'activeHand', 'playerHand'
    @listenTo @get('playerHand'), 'splitPossible', -> @trigger('splitPossible')
    @listenTo @get('playerHand'), 'bust', -> @trigger('bust')
    @listenTo @get('playerHand'), 'stand', -> @trigger('stand')
    @listenTo @get('playerHand'), 'scoreGame', (params) -> @trigger('scoreGame', params)
    @listenTo @get('dealerHand'), 'scoreGame', -> @trigger('scoreGame')


