# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'wallet', new Wallet()
    @initGame()

  initGame: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @set 'splitHand', null
    @set 'activeHand', 'playerHand'
    @set 'bets', new Bets()
    @listenTo @get('playerHand'), 'splitPossible', -> @trigger('splitPossible')
    @listenTo @get('playerHand'), 'bust', -> @trigger('bust')
    @listenTo @get('playerHand'), 'stand', -> @trigger('stand')
    @listenTo @get('playerHand'), 'scoreGame', (params) -> @trigger('scoreGame', params)
    @listenTo @get('dealerHand'), 'scoreGame', -> @trigger('scoreGame')
    @listenTo @get('bets'), 'finishBet', -> @trigger('finishBet')


