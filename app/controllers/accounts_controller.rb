class AccountsController < ApplicationController
  layout 'panel'
  before_filter :authenticate_user!

  def index

  end

  def destroy

  end

end