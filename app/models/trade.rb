class Trade < ActiveRecord::Base
  
  #def initialize(options)
    #@id                   = options["id"]
    #@accepted             = options["accepted"]
    #@player_team          = options["player_team"].to_i
    #@ai_team              = options["ai_team"].to_i
    #@player_dealt_players = []
    #@ai_dealt_players     = []
    #@all_the_player_ids   = options["all_the_player_ids"]
    #@player_team_with_ai_players = []
    #@ai_team_with_player_players = []
    #@war_diff                    = 0
    #@sample_players              = nil
    #set_player_dealt_ids(options["all_the_player_ids"])
    #hypothetical_remaining_player_team
    #hypothetical_remaining_ai_team
    #calculate_war_difference
 #end

  # def set_player_dealt_ids(array_containing_player_ids)
  #   player_objects = []
  #   array_containing_player_ids = array_containing_player_ids - [0]
  #   array_containing_player_ids.each do |x|
  #     player_objects << Player.find(x)
  #   end
  #   player_objects.each do |x|
  #     if x.team_id == @player_team
  #       @player_dealt_players << x
  #     else
  #       @ai_dealt_players     << x
  #     end
  #   end
  # end

  def hypothetical_remaining_player_team
    @player_team_with_ai_players = Player.find_all_by_team_id(@player_team)
    @player_dealt_players.each {|a| @player_team_with_ai_players.delete_if{|x| x.id == a.id}}
    @player_team_with_ai_players << @ai_dealt_players
  end

  def hypothetical_remaining_ai_team
    @ai_team_with_player_players = Player.find_all_by_team_id(@ai_team)
    @ai_dealt_players.each {|a| @ai_team_with_player_players.delete_if{|x| x.id == a.id}}
    @ai_team_with_player_players << @player_dealt_players
  end

  def team_has_too_many_players
    if @player_team_with_ai_players.flatten!.length <= 45 && @ai_team_with_player_players.flatten!.length <= 45
      if team_has_enough_of_each_position? == true
        evaluate_trade
      else
        return "Invalid trade! One team has a serious position deficiency!"
      end
    else
      return "Invalid trade! Team is over roster limit."
    end
  end

  def team_has_enough_of_each_position?
    positional_limits = {"Pitcher" => 10, "Catcher" => 2, "IF" => 6, "OF" => 4}
    positional_limits.each do |x,y|
      a = @player_team_with_ai_players.select { |a| a.position == x }.length
      b = @ai_team_with_player_players.select { |a| a.position == x }.length
      if a <= y || b <= y
        return false 
      else
        return true
      end
    end
  end
  
  def calculate_war_difference
    war_1 = 0
    war_2 = 0
    @player_dealt_players.each { |x| war_1 += x.war }
    @ai_dealt_players.each     { |x| war_2 += x.war }
    @war_diff = (war_1 - war_2)
  end
  
  def accept
    Trade.create(accepted: "yes") 
    trade_id = Trade.order(:id).last
    player_team = Team.find(@player_team)
    ai_team     = Team.find(@ai_team)
    @player_dealt_players.each do |x|
      Transaction.create(player: x.id, source: player_team.abbreviation, destination: ai_team.abbreviation, trade_id: trade_id.id) 
    end
    @ai_dealt_players.each do |x|
      Transaction.create(player: x.id, source: ai_team.abbreviation, destination: player_team.abbreviation, trade_id: trade_id.id) 
    end
    
  end
  
  def reject
    Trade.create(accepted: "no") 
    trade_id = Trade.order(:id).last
    player_team = Team.find(@player_team)
    ai_team     = Team.find(@ai_team)
    @player_dealt_players.each do |x|
      Transaction.create(player: x.id, source: player_team.abbreviation, destination: ai_team.abbreviation, trade_id: trade_id.id) 
    end
    @ai_dealt_players.each do |x|
      Transaction.create(player: x.id, source: ai_team.abbreviation, destination: player_team.abbreviation, trade_id: trade_id.id)
    end 
    return
  end
  
  def evaluate_trade
    if @war_diff >= 3
      accept
      return "That is an excellent offer, and we happily accept!"
    elsif @war_diff < 3 && @war_diff >= 1
      accept
      return "That seems like a fine offer. We accept."
    elsif @war_diff < 1 && @war_diff >= (-0.3)
      accept
      return "That offer is okay. We begrudgingly accept."
    else
      modify_dealt_players_for_counter_offer
    end
  end
  
  def modify_dealt_players_for_counter_offer
    player_roster = Player.find_all_by_team_id(@player_team)
    @player_dealt_players.each {|dealt_players| player_roster.delete_if{|player_id| (player_id.id) == dealt_players}}
    @sample_players = player_roster.select {|x| x.war >= @war_diff.abs}
    return
  end
  
  

end
