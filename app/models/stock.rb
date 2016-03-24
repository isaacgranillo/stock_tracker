class Stock < ActiveRecord::Base

	def self.find_by_ticker(ticker)
		where(symbol: ticker).first
	end

	def self.new_from_lookup(symbol)
		looked_up_stock = StockQuote::Stock.quote(symbol)
		return nil unless looked_up_stock.name
		
		new_stock = new(symbol: looked_up_stock.symbol, name: looked_up_stock.name)
		new_stock.last_price = new_stock.price
		new_stock
	end

	def price
		closing_price = StockQuote::Stock.quote(symbol).close
		return "#{closing_price} (Closing)" if closing_price

		opening_price = StockQuote::Stock.quote(symbol).open
		return "#{opening_price} (Opening)" if opening_price
		"Not Available"
	end
end
