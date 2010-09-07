class InvitesController < ApplicationController
  before_filter :require_admin

  def index
    @invite = Invite.new
    @invites = Invite.all
  end

  def create
    @invite = Invite.new params[:invite]
    if @invite.save
      redirect_to admin_invites_path, :notice => "Инвайт#{comment_for @invite} успешно создан"
    else
      redirect_to admin_invites_path, :alert => "Инвайт не создан"
    end
  end

  def destroy
    invite = Invite.find(params[:id])
    invite.destroy
    redirect_to admin_invites_path, :notice => "Инвайт#{comment_for invite} удален"
  end

  private

  def comment_for(invite)
    " (#{invite.comment})" unless invite.comment.blank?
  end
end
