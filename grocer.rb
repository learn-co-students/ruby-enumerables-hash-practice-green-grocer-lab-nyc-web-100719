#look at notes on below methods in sublime text green_grocer file

def consolidate_cart(cart)
  cart_hash = {} 
  cart.each do |array_element| 
    array_element.each do |item_name, item_attributes_hash| 
        if cart_hash[item_name] 
          cart_hash[item_name][:count] += 1 
        else
          cart_hash[item_name] = item_attributes_hash 
          cart_hash[item_name][:count] = 1  
        end 
    end
  end
  p cart_hash 
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash| 
    coupon_hash.each do |key, value| 
      coupon_item_name = coupon_hash[:item] 
      if cart[coupon_item_name] && cart[coupon_item_name][:count] >= coupon_hash[:num]  
        if cart["#{coupon_item_name} W/COUPON"] 
          cart["#{coupon_item_name} W/COUPON"][:count] += coupon_hash[:num] 
        else 
          cart["#{coupon_item_name} W/COUPON"] = { 
            :price => coupon_hash[:cost] / coupon_hash[:num], 
            :clearance => cart[coupon_item_name][:clearance], 
            :count => coupon_hash[:num] 
          }
        end
        cart[coupon_item_name][:count] -= coupon_hash[:num] 
      end
    end
  end
  p cart 
end

def apply_clearance(cart)
  cart.each do |item_name, attribute_hash|
      if attribute_hash[:clearance] == true 
        attribute_hash[:price] = (attribute_hash[:price] * 0.80).round(2) 
      end
    end 
  p cart 
end

def checkout(cart, coupons)
  cart1 = consolidate_cart(cart)
  cart2 = apply_coupons(cart1, coupons)
  cart3 = apply_clearance(cart2)
  total = 0 
  cart3.each do |item_name, attribute_hash|
    total = total + (attribute_hash[:price] * attribute_hash[:count])
  end
  total > 100 ? total = (total * 0.90) : total 
  p total 
end
