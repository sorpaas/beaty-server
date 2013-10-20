class GameController < ApplicationController
  def new
    if Game.last == nil or Game.last.player_2_id != -1
      @game = Game.create
      @game.player_1_id = -1
      @game.player_2_id = -1
      @game.winner_id = -1
      @game.save
    else
      @game = Game.last
    end
    
    @player = Player.create
    @player.life = 1000;
    @player.save
    
    result_json = {}
    result_json["game_id"] = @game.id
    result_json["player_id"] = @player.id
    if @game.player_1_id == -1
      @game.player_1_id = @player.id
      result_json["can_game_start"] = false
    else
      @game.player_2_id = @player.id
      result_json["can_game_start"] = true
    end
    @game.save
    
    render json: result_json
  end
  
  def wait
    @game = Game.find(params[:id])
    result_json = {}
    if @game.player_1_id == -1 or @game.player_2_id == -1
      result_json["can_game_start"] = false
    else
      result_json["can_game_start"] = true
    end
    
    render json: result_json
  end

  def hit
    @game = Game.find(params[:game_id])
    @self_player = Player.find(params[:self_id])
    result_json = {}
    
    beating_id = nil
    if @game.player_1_id == @self_player.id
      beating_id = @game.player_2_id
    else
      beating_id = @game.player_1_id
    end
    
    reducing_life = params[:life].to_i
    @other_player = Player.find(beating_id)
    @other_player.life -= reducing_life
    @other_player.save
    
    result_json["status"] = "ok"
    render json: result_json
  end

  def status
    @game = Game.find(params[:game_id])
    @player1 = Player.find(@game.player_1_id)
    @player2 = Player.find(@game.player_2_id)
    
    result_json = {}
    result_json["player_1_id"] = @player1.id
    result_json["player_1_life"] = @player1.life
    result_json["player_2_id"] = @player2.id
    result_json["player_2_life"] = @player2.life
    
    render json: result_json
  end
end
