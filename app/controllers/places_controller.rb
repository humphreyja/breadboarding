class PlacesController < ApplicationController
  include Authenticated
  
  def index
    puts Current.user.breadboards
    @breadboards = Current.user.breadboards
  end
  
  def new
    @breadboard = Current.user.breadboards.find(params[:breadboard_id])
    @place = @breadboard.places.new(name: 'new place', position: params[:position])
    @place.save
    @autofocus = true
  end
  
  def edit
    @breadboard = Current.user.breadboards.find(params[:breadboard_id])
    @place = @breadboard.places.find(params[:id])
  end
  
  def update
    @breadboard = Current.user.breadboards.find(params[:breadboard_id])
    @place = @breadboard.places.find(params[:id])
    @place.update(place_params)
    
    new_ids = @place.affordances.pluck(:id)
    @new_keys = {}
    params[:place][:affordances_attributes] || [].each do |affordance_key, affordance|
      new_ids -= [affordance[:id].to_i] if affordance[:id].present?
    end
        
    params[:place][:affordances_attributes] || [].each do |affordance_key, affordance|
      if affordance[:id].nil?
        found_id = @place.affordances.where(id: new_ids).find_by(name: affordance[:name])&.id
        @new_keys[affordance_key] = found_id if found_id
      end
    end
    
    respond_to do |format|
      format.turbo_stream { render :updated }
      format.html { render :edit }
    end
  end
  
  def create
    @breadboard = Current.user.breadboards.find(params[:breadboard_id])
    @place = @breadboard.places.new(place_params)
    if @place.save
      @autofocus = true
      render :edit
    else
      render :new
    end
  end
  
  def destroy
    @breadboard = Current.user.breadboards.find(params[:breadboard_id])
    @place = @breadboard.places.find(params[:id])
    @position = @place.position
    if @place.destroy
      render :destroy
    else
      respond_to do |format|
        format.turbo_stream { render :updated }
        format.html { render :edit }
      end
    end
  rescue ActiveRecord::RecordNotFound
    @place = @breadboard.places.new(position: place_params[:position])
    @place.affordances.build(name: 'new affordance')
    @position = @place.position
    render :destroy
  end
  
  private
  
    def place_params
      params.require(:place).permit(
        :name,
        :position,
        affordances_attributes: [
          :id,
          :name,
          :position,
          :connection_id,
          :connection_position,
          :_destroy
        ]
      )
    end
end
