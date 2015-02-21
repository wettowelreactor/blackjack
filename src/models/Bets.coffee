class window.Bets extends Backbone.Model
  initialize: ->
    @set('bet', 0)
    @set('sidebet', 0)
    @set('splitHand', false)
