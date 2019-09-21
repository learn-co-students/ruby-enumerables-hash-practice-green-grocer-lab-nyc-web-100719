def consolidate_cart(cart)
i = 0
hash = {}
while i < cart.length 
    cart[i].each do |key,value|
        if value[:count]
            value[:count] += 1
        else value[:count] = 1
        end
        hash[key] = value
        end
        i += 1
    end
    return hash
end


def apply_coupons(cart, coupons)
    i = 0
    while i < coupons.length
    coupon_name = coupons[i][:item]
    coupon_number_amount = coupons[i][:num]
    if cart.include? (coupon_name) 
      if cart["#{coupon_name}"][:count] >= coupon_number_amount
        
        cart["#{coupon_name} W/COUPON"] = {:price => coupons[i][:cost]/coupon_number_amount, :count => coupon_number_amount, :clearance => cart[coupons[i][:item]][:clearance]}
        
        cart["#{coupon_name}"][:count] -= coupon_number_amount
        
      while cart["#{coupon_name }"][:count] >= coupon_number_amount
         cart["#{coupon_name} W/COUPON"][:count] += coupon_number_amount
         cart["#{coupon_name}"][:count] -= coupon_number_amount 
       end
      end
    end
    i += 1
    end
    return cart
  end


def apply_clearance(cart)
  price = 0
  cart.each do |key, value|
    if value[:clearance] == true 
      price = value[:price] * 0.8
      price_update = price.round(2)
      value[:price] = price_update
    end
  end
return cart
end

def checkout(cart, coupons)
  item_cost = 0
  total_cost = 0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cart.each do |key, value|
    item_cost = value[:price] * value[:count]
    total_cost += item_cost
    if total_cost > 100
      total_cost *= 0.9
    end
  end
  return total_cost
end
