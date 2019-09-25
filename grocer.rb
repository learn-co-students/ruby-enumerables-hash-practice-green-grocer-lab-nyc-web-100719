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
  
 i = 0
  coupons.map{ |n|
    string = n[:item]
    if (cart.key?(string) && cart[string][:count] >= n[:num])
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
        #price = cart["#{string} W/COUPON"][:price] + price
        
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

def apply_clearance(cart)
  # code here
  newHash = Hash.new
  cart.each_key{|n|
    
    newHash[n]= {
      count: cart[n][:count],
      clearance: cart[n][:clearance]
    }
    
    if (cart[n][:clearance])
      newPrice = cart[n][:price] * 0.8
      newPrice = newPrice.round(2)
      newHash[n][:price] = newPrice
    else
      newHash[n][:price] = cart[n][:price]
    end
    
    
  }
  newHash
end

def checkout(cart, coupons)
  # code here
  consolCart = consolidate_cart(cart)
  applCouponCart = apply_coupons(consolCart,coupons)
  clearanceCart = apply_clearance(applCouponCart)
  total = 0
  clearanceCart.each_key{ |n|
  total += clearanceCart[n][:price]*clearanceCart[n][:count]
  }
  
  if (total > 100.00)
    total = (total*0.9).round(2)
  end
  
  total
  
end
