module Spree
  TaxonsController.class_eval do

    def show
      @taxon = Taxon.find_by_permalink!(params[:id])
      return unless @taxon

      # just a quick way to override product ordering for a given taxon on front-end
      # be careful this does not get taxon taxonomy/children products, it just gets the products 
      # directly associated to the taxon
      @products = @taxon.products

      curr_page = params[:page] || 1
      per_page = 12
      @products = @products.includes([:master => :prices])
      unless Spree::Config.show_products_without_price
        @products = @products.where("spree_prices.amount IS NOT NULL").where("spree_prices.currency" => current_currency)
      end
      @products = @products.page(curr_page).per(per_page)
    end

  end
end