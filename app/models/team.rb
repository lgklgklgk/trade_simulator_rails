class Team < ActiveRecord::Base
  has_many :players
  attr_accessible :name, :abbreviation, :general_manager, :image

def modified_team(id_array, other_id_array)
  id_array.each do |id|
    players.delete_if {|object| object.id == id.to_i}
  end
  other_id_array.each do |id|
    players << Player.find(id)
  end
  return players
end

def team_has_too_many_players
  if players.length <= 45 
    if team_has_enough_of_each_position? == true
      binding.pry
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
    a = players.select { |a| a.position == x }.length
    if a <= y 
      return false 
    else
      return true
    end
  end
end

end