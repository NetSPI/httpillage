class CharsetController < ApplicationController
  def index
    @charsets ||= Charset.all
  end

  def new
    @charset ||= Charset.new
  end

  def create

  end

  def edit

  end

  def update

  end
end