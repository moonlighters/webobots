class DocController < ApplicationController
  before_filter :require_user

  def waffle_language
  end

  def runtime_library
  end
end
