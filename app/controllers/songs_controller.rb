class SongsController < ApplicationController
  def index
    @songs = Song.all
    @artist = params[:artist_id].nil? ? nil : Artist.where(id: params[:artist_id]).first
    if !params[:artist_id].nil? then
      @artist.nil? ? redirect_to(artists_path, alert: 'Artist not found') : @songs = @artist.songs
    end
  end

  def show
    @song = Song.where(id: params[:id]).first
    if (@song.nil?) then
      flash[:alert] = "Song not found: #{params[:id]}"
      if (!params[:artist_id].nil?) then 
        @artist = Artist.find(params[:artist_id])
        @artist.nil? ? flash[:alert] = "Can't find artist with id: #{params[:artist_id]}" : redirect_to(artist_songs_path(@artist))
      end
    end
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end
end

