class Basecamp::PitchesController < ApplicationController
  include Authenticated
  
  before_action :assign_basecamp_cycle

  def index
    @pitches = @cycle.pitches
  end
  
  def vote
    @pitch = @cycle.pitches.find { |pitch| pitch.id == params[:id].to_i }
    @cycle.vote_for_pitch!(@pitch.id, Current.user)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("pitch.#{@pitch.id}", partial: 'basecamp/pitches/pitch', locals: { pitch: @pitch, cycle: @cycle, current_user_id: Current.user.id }) }
      format.html { redirect_to basecamp_cycle_pitches_path(@cycle) }
    end
  end
  
  def remove_vote
    @pitch = @cycle.pitches.find { |pitch| pitch.id == params[:id].to_i }
    @cycle.remove_vote_for_pitch!(@pitch.id, Current.user)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("pitch.#{@pitch.id}", partial: 'basecamp/pitches/pitch', locals: { pitch: @pitch, cycle: @cycle, current_user_id: Current.user.id }) }
      format.html { redirect_to basecamp_cycle_pitches_path(@cycle) }
    end
  end
  
  
  private
  
  def assign_basecamp_cycle
    @cycle = Current.user.domain.cycles.find(params[:cycle_id])
  end
  
end