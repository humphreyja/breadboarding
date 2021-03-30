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
    
    @new_keys = {}
    @place.transaction do
      @place.update!(place_params.except(:affordances_attributes))
      affordances_params = place_params[:affordances_attributes] || {}
      affordances_params.each do |affordance_key, affordance_attributes|
        if affordance_attributes[:id]
          affordance = @place.affordances.find_by(id: affordance_attributes[:id])
          next if affordance.nil?
          if affordance_attributes[:_destroy] == 'true'
            affordance.destroy!
          else
            affordance.update!(affordance_attributes.except(:id, :_destroy)) unless affordance_attributes[:name].blank?
          end
        else
          next if affordance_attributes[:name].blank?
          new_affordance = @place.affordances.create!(affordance_attributes) 
          @new_keys[affordance_key] = new_affordance.id
        end
      end
    end
    
    respond_to do |format|
      format.turbo_stream { render :updated }
      format.html { render :edit }
    end
  rescue ActiveRecord::RecordNotFound
    @place = @breadboard.places.new(position: place_params[:position])
    @position = @place.position
    render :destroy
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
