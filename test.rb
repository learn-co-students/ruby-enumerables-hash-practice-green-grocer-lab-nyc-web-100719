def find_item(name)
  items.find { |item| item[name] }
end

def find_coupon(name)
  coupons.find { |coupon| coupon[:item] == name }
end

def items
	[
		{"AVOCADO" => {:price => 3.00, :clearance => true}},
		{"KALE" => {:price => 3.00, :clearance => false}},
		{"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
		{"ALMONDS" => {:price => 9.00, :clearance => false}},
		{"TEMPEH" => {:price => 3.00, :clearance => true}},
		{"CHEESE" => {:price => 6.50, :clearance => false}},
		{"BEER" => {:price => 13.00, :clearance => false}},
		{"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
		{"BEETS" => {:price => 2.50, :clearance => false}}
	]
end



def coupons
	[
		{:item => "AVOCADO", :num => 2, :cost => 5.00},
		{:item => "BEER", :num => 2, :cost => 20.00},
		{:item => "CHEESE", :num => 3, :cost => 15.00}
	]
end

def consolidate_cart(cart)
  # code here
  newHash = Hash.new
  
  
  cart.map { |n|
  
    m = n.keys[0]
    
    
    if (newHash.key?(m))
      newHash[m][:count] = newHash[m][:count] + 1
    else
      
        
      newHash[m] = {
        price: n[m][:price],
        clearance: n[m][:clearance],
        count: 1
        
      }
    end
  
  }
  
  newHash
end




    

def apply_coupons(cart, coupons)
  # code here
  
  newHash = Hash.new
  i = 0
  coupons.map{ |n|
    string = n[:item]
    if (cart.key?(string))
      cart[string][:count] -= n[:num]
      #clearance = cart[n[:item]][:clearance]
     clearance = cart[string][:clearance]
      
      price = n[:cost] / n[:num]
      count = n[:num]
      
      #delete if quantity is 0
      #if (cart[n[:item]][:count] < 1)
       # cart.delete(n[:item])
      #end
      
      if (cart.key?("#{string} W/COUPON"))
        price = cart["#{string} W/COUPON"][:price] + price
        
        count = cart["#{string} W/COUPON"][:count] + count
        cart["#{string} W/COUPON"][:price] = price
        cart["#{string} W/COUPON"][:clearance] = clearance
        cart["#{string} W/COUPON"][:count] =  count
      else
        cart["#{string} W/COUPON"] = {
          price: price,
          clearance: clearance,
          count: count
        }
      end
    end
    
  }
  
  cart
end

avocado = find_item("AVOCADO")
coupon = find_coupon("AVOCADO")
consol_cart = consolidate_cart([avocado, avocado, avocado, avocado, avocado])
two_coupon_result = apply_coupons(consol_cart, [coupon, coupon])

puts "begin here \n\n\n"

concattest = "|\n"
temp = concattest.clone
two = temp.concat("|\n")
puts concattest
puts two
puts two_coupon_result






