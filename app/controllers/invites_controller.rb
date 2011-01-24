class InvitesController < ApplicationController
  before_filter :require_admin

  def index
    @invite = Invite.new
    @invites = Invite.all
  end

  def create
    @invite = Invite.new params[:invite]
    if @invite.save
      redirect_to admin_invites_path, :notice => "Инвайт (#{@invite.comment}) успешно создан"
    else
      redirect_to admin_invites_path, :alert => "Инвайт не создан"
    end
  end

  def destroy
    invite = Invite.find(params[:id])
    invite.destroy
    redirect_to admin_invites_path, :notice => "Инвайт (#{invite.comment}) удален"
  end

  private
  
  def get_invites
    @invites = Invite.all
  end

  def build_invite
    @invite = Invite.new
  end

  def comment_for(invite)
    " (#{invite.comment})" unless invite.comment.blank?
  end
end
