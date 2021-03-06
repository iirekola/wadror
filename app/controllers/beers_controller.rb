class BeersController < ApplicationController

  before_action :set_beer, only: [:show, :edit, :update, :destroy]

  before_action :ensure_that_signed_in, except: [:index, :show, :list, :nglist]
  before_action :ensure_that_admin, only: [:destroy]
  before_action :skip_if_cached, only:[:index]

  def list
  end

  def nglist
  end

  def skip_if_cached
    @order = params[:order] || 'name'
    return render :index if fragment_exist?( "beerlist-#{@order}"  )
  end

  def index
    @beers = Beer.includes(:brewery, :style).all

    case @order
      when 'name' then @beers.sort_by{ |b| b.name }
      when 'brewery' then @beers.sort_by{ |b| b.brewery.name }
      when 'style' then @beers.sort_by{ |b| b.style.name }
    end
  end



  # GET /beers/1
  # GET /beers/1.json

  def show

    @rating = Rating.new
    @rating.beer = @beer
  end



  # GET /beers/new

  def new

    @beer = Beer.new
    @breweries = Brewery.all
    @styles = Style.all
  end



  # GET /beers/1/edit

  def edit
    @breweries = Brewery.all
    @styles = Style.all
  end



  # POST /beers

  # POST /beers.json
  def create

    @beer = Beer.new(beer_params)
    respond_to do |format|

      if @beer.save

        ["beerlist-name", "beerlist-brewery", "beerlist-style"].each{ |f| expire_fragment(f) }
        format.html { redirect_to beers_path, notice: 'Beer was successfully created.' }

        format.json { render :show, status: :created, location: @beer }

      else

        @breweries = Brewery.all
        @styles = Style.all
        format.html { render :new }

        format.json { render json: @beer.errors, status: :unprocessable_entity }

      end

    end
  end



  # PATCH/PUT /beers/1

  # PATCH/PUT /beers/1.json
  def update

    respond_to do |format|

      if @beer.update(beer_params)

        ["beerlist-name", "beerlist-brewery", "beerlist-style"].each{ |f| expire_fragment(f) }
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { render :show, status: :ok, location: @beer }

      else

        format.html { render :edit }

        format.json { render json: @beer.errors, status: :unprocessable_entity }

      end

    end

  end



  # DELETE /beers/1

  # DELETE /beers/1.json
  def destroy

    @beer.destroy

    ["beerlist-name", "beerlist-brewery", "beerlist-style"].each{ |f| expire_fragment(f) }
    respond_to do |format|

      format.html { redirect_to beers_url, notice: 'Beer was successfully destroyed.' }

      format.json { head :no_content }

    end

  end



  private
    

    # Use callbacks to share common setup or constraints between actions.
    def set_beer

      @beer = Beer.find(params[:id])

    end



    # Never trust parameters from the scary internet, only allow the white list through.


    def beer_params

      params.require(:beer).permit(:name, :style_id, :brewery_id)

    end

end
