class UsersController < ApplicationController
  before_action :authenticate_user!

  def history
    @versions = PaperTrail::Version.order('created_at DESC')
  end
end
