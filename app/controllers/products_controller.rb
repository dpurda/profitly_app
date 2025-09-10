class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    @product.stock_id = params[:stock_id] if params[:stock_id]
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        if @product.stock_id.present?
          format.html { redirect_to stock_path(@product.stock), notice: 'Product was successfully created.' } # rubocop:disable Rails/I18nLocaleTexts
        else
          format.html { redirect_to @product, notice: 'Product was successfully created.' } # rubocop:disable Rails/I18nLocaleTexts
        end
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to stock_path(@product.stock), notice: 'Product was successfully updated.' } # rubocop:disable Rails/I18nLocaleTexts
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to stock_path(@product.stock), notice: 'Product was successfully destroyed.' } # rubocop:disable Rails/I18nLocaleTexts
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.expect(product: [ :description, :in_price, :out_price, :size, :prod_code, :stock_id ])
    end
end
