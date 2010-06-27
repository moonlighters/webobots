class InvitesController < ApplicationController
  before_filter :get_invites
  before_filter :build_invite, :except => :destroy

  def index
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
