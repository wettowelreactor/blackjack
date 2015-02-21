class window.Bets extends Backbone.Model
  initialize: ->
    @set('bet', 0)
    @set('sideBet', 0)
    @set('splitHand', false)
    @set('firstBetActive', false)
    @set('sideBetActive', false)

  finishBet: ->
    @trigger('finishBet')
