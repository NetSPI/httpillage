class CharsetController < ApplicationController
  def index
    @charsets ||= Charset.all
  end

  def new
    @charset ||= Charset.new
  end

  def create
    charset = Charset.create(
      { 
        :key       => params[:charset][:key],
        :val       => params[:charset][:val]
      }
    )

    if charset.valid?
      flash[:notice] = "Character Set Created Successfully"
    else
      flash[:error] = charset.errors.messages
    end

    redirect_to charsets_path
  end

  def edit

  end

  def update

  end

  def destroy
    @charset = Charset.find(params[:charsetid])

    @charset.destroy

    flash[:notice] = "Charset successfully removed"
    redirect_to charsets_path
  end
end