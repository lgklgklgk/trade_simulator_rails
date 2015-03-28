class TransactionsController < ApplicationController
  include TransactionsHelper
  def index
    @teams = Team.all
  end
  
  def next
    @player_roster = Player.find_all_by_team_id(params["player_team"])
    @ai_roster     = Player.find_all_by_team_id(params["ai_team"])
    @player_name   = Team.find(params["player_team"])
    @ai_name       = Team.find(params["ai_team"])
  end
  
  def trade_results
    @your_roster = Team.find(params["player_team"]).modified_team(params["player_id"], params["ai_id"])
    @their_roster = Team.find(params["ai_team"]).modified_team(params["ai_id"], params["player_id"])
    binding.pry
    #@trade = Trade.new({"player_team" => teams["player_team"], "ai_team" => teams["ai_team"], 
      #"all_the_player_ids" => params.values.map(&:to_i)})
    # counter_check
    # @ai_team      = Team.find(teams["ai_team"])
    # @your_players = word_connector(get_player_names(@trade.player_dealt_players))
    # @ai_players   = word_connector(get_player_names(@trade.ai_dealt_players))
  end
end
