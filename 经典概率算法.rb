# 经典概率算法
def draw_prize(prizes = {})
  chance = prizes.values.sum
  prizes.each do |prize_id, prize_chance|
    rand_num = 1 + rand(chance)
    if rand_num <= prize_chance
      return prize_id
    else
      chance -= prize_chance
    end
  end
end
