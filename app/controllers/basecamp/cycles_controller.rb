class Basecamp::CyclesController < ApplicationController
  include Authenticated
  
  before_action :assign_basecamp_session
  
  def index
    @cycles = Current.user.domain.cycles
  end

  def show
    @cycle = Current.user.domain.cycles.find(params[:id])
  end
  
  def new
    @cycle = Current.user.domain.cycles.new
  end
  
  def create
    @cycle = Current.user.domain.cycles.new(cycle_params)
    if @cycle.save!
      redirect_to basecamp_cycle_path(@cycle)
    else
      render :new
    end
  end

  def edit
    @cycle = Current.user.domain.cycles.find(params[:id])
  end
  
  def update
    @cycle = Current.user.domain.cycles.find(params[:id])
    if @cycle.update(cycle_params)
      redirect_to basecamp_cycle_path(@cycle)
    else
      render :edit
    end
  end
  
  def destroy
    @cycle = Current.user.domain.cycles.find(params[:id])
    @cycle.destroy
    redirect_to basecamp_session_path
  end
  
  def publish
    @cycle = Current.user.domain.cycles.find(params[:id])
    @cycle.publish!
    redirect_to basecamp_cycle_path(@cycle)
  end
  
  def fetch_pitches
    @cycle = Current.user.domain.cycles.find(params[:id])
    @cycle.fetch_pitches!
    redirect_to basecamp_cycle_path(@cycle)
  end
  
  private
  
  def cycle_params
    params.require(:cycle).permit(
      :number,
      :date
    )
  end
  
  def assign_basecamp_session
    @basecamp_session = Current.user.domain.basecamp_session
    @basecamp_session ||= Current.user.domain.build_basecamp_session
  end
  
end