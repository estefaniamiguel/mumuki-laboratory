class HomeController < ApplicationController
  def index
    redirect_to [Organization.central, Organization.central.book] if public_user?
  end

  private

  def public_user?
    !current_user? || current_user.permissions.empty?
  end
end
