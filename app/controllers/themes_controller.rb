class ThemesController < ApplicationController
  include Authenticated

  def update
    current_user.theme = theme_params[:theme]
    current_user.save

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(:theme_controller, partial: 'themes/theme_controller') }
      format.html { head :ok, content_type: "text/html" }
    end
  end
  
  private
    def theme_params
      params.require(:user).permit(:theme)
    end
end
