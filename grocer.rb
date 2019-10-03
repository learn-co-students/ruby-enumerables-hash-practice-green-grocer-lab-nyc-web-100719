def consolidate_cart(cart = {})
  new_cart = {}
  cart.each {|object| 
  object.each {|item, info| 
  if new_cart[item] 
    new_cart[item] [:count] += 1 
  else
    new_cart[item] = info 
    new_cart[item] [:count] = 1 
  end
  }
}
  new_cart
end








def apply_coupons(cart, coupons)
  coupons.each {|deal| 
  item = deal[:item]
  couponed_item = "#{item} W/COUPON"
  discounted_item_cost = deal[:cost] / deal [:num]
  original_item = cart[item]
  coupon_num = deal[:num] 
  if cart.include?(item) && cart.include?(couponed_item) 
    cart_count = original_item[:count]
    updated_count = cart_count - coupon_num
    if updated_count >= 0 
      original_item[:count] = updated_count
      cart[couponed_item] [:count] = cart[couponed_item] [:count] + deal[:num] 
    end
    elsif cart.include?(item)
    cart_count = original_item[:count]
    updated_count = cart_count - coupon_num
    if updated_count >= 0 
      original_item[:count] = updated_count 
      cart[couponed_item] = {:price => discounted_item_cost, :clearance => original_item [:clearance], :count => deal[:num]}
    end
  end
  }
  cart
end







def apply_clearance(cart)
  cart.map {|item, info|
  if info[:clearance]
    item_price = info[:price]
    item_discount = (item_price * 0.20).round(2)
    item_final = item_price - item_discount
    info[:price] = item_final
  end
  }
  cart 
end





def checkout(cart, coupons)
  cart_consolidated = consolidate_cart(cart)
  cart_couponed = apply_coupons(cart_consolidated, coupons)
  clearance_applied = apply_clearance(cart_couponed)
  total = 0.00
  clearance_applied.each do |item, info|
    item_total = info[:price] * info[:count]
    total += item_total
  end
  total > 100 ? total = total - (total * 0.10) : total
end

















