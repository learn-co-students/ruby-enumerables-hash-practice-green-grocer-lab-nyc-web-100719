require 'bigdecimal'

def consolidate_cart(cart)
  item_list = ["AVOCADO", "KALE", "BLACK_BEANS", "ALMONDS", "TEMPEH", "CHEESE", "BEER", "PEANUTBUTTER", "BEETS", "SOY MILK"]
  hash = Hash.new
  x = 0 # cart counter
  y = 0 # item_list counter

  while x < cart.length && y < item_list.length
    #puts "Checking for #{item_list[y]}"
    if cart[x][item_list[y]] && !hash[item_list[y]]
      hash[item_list[y]] = {:price => cart[x][item_list[y]][:price], :clearance => cart[x][item_list[y]][:clearance], :count => 1}
      x += 1 # go to next item in cart
      y = 0 # restarting from beginning of item_list
      #puts "#{item_list[y]} is now in cart."
    elsif cart[x][item_list[y]] && hash[item_list[y]]
      hash[item_list[y]][:count] += 1
      #puts "Incrementing #{item_list[y]} count by 1."
      x += 1 # go to next item in cart
      y = 0 # restarting from beginning of item_list
    else
      y += 1 # go to next item in item_list
    end
  end
  return hash
end

def apply_coupons(cart, coupons)
  x = 0 # cart counter
  y = 0 # coupon counter
  while x < cart.length && y < coupons.length
    if cart[coupons[y][:item]] # check if current coupon item is the same as current cart item
      count_w_coupon = (cart[coupons[y][:item]][:count].to_i / coupons[y][:num]) * coupons[y][:num] # new count with coupon
      count_no_coupon = cart[coupons[y][:item]][:count].to_i % coupons[y][:num] # new count without coupon
      if count_w_coupon > 0
        cart[coupons[y][:item]][:count] = count_no_coupon
      end
      if count_w_coupon > 0
        new_hash = {coupons[y][:item] + " W/COUPON" => {:price => coupons[y][:cost] / coupons[y][:num], :clearance => cart[coupons[y][:item]][:clearance], :count => count_w_coupon}}
        cart.merge!(new_hash)
      end
      #p cart
      #return cart
    else
      x += 1
    end
    y += 1
    #return
  end
  return cart
end

def apply_clearance(cart)
  cart.each_key do |item|
    if cart[item][:clearance]
      new_price = BigDecimal(cart[item][:price],3)
      new_price = new_price.mult(0.8,3).to_f
      cart[item][:price] = new_price
    end
  end
  return cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0.00
  cart.each_key do |item|
    total = total + (cart[item][:price] * cart[item][:count])
  end
  if total > 100
    total = total * 0.9
  end
  return total
end
