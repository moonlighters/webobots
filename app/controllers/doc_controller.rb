class DocController < ApplicationController
  before_filter :require_user

  def waffle_language
  end
end
