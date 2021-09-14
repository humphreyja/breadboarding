class BreadboardsController < ApplicationController
  include Authenticated
  
  def index
    @breadboards = Current.user.breadboards
    @cycle = Current.user.domain.cycles.active.first
  end
  
  def new
    @breadboard = Current.user.breadboards.create(name: 'unnamed breadboard')
    
    redirect_to edit_breadboard_path(@breadboard)
  end
  
  def edit
    @breadboard = Current.user.breadboards.find(params[:id])
  end
  
  def update
    @breadboard = Current.user.breadboards.find(params[:id])
    @breadboard.update(breadboard_params)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(:updated_at, partial: 'breadboards/updated_at', locals: { breadboard: @breadboard }) }
      format.html { render :edit }
    end
  end
  
  def delete_request
    @breadboard = Current.user.breadboards.find(params[:id])
  end
  
  def destroy
    @breadboard = Current.user.breadboards.find(params[:id])
    if @breadboard.destroy
      redirect_to breadboards_path
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:updated_at, partial: 'breadboards/updated_at', locals: { breadboard: @breadboard }) }
        format.html { render :edit }
      end
    end
  end
  
  private
  
    def breadboard_params
      params.require(:breadboard).permit(:name)
    end
end
