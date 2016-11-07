class PagesController < ApplicationController
  skip_before_action :require_logged_in

  layout 'landing'

  def show; end;
  def pricing; end;
  def features; end;
end