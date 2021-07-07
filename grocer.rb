

def consolidate_cart(cart)
  final_hash = {}
  cart.each do |element_hash| #cart is an array of hashes, this gets us to first hash TEMPEH
    element_name = element_hash.keys[0]    # .keys hash method returns an array with all the keys -> in this case "TEMPEH"
    element_stats = element_hash.values[0] # .values hash method returns an array with all the values -> in this case price/clearance hash of "TEMPEH"
    if final_hash.has_key?(element_name)
      final_hash[element_name][:count] += 1 
    else
      final_hash[element_name] = {
        count: 1,
        price: element_stats[:price],
        clearance: element_stats[:clearance]
      }
    end
  end
  final_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]
    coupon_item = "#{item} W/COUPON"
      if cart[item]
        if !cart[coupon_item] && cart[item][:count] >= coupon[:num]
          cart[coupon_item] = {
            price: coupon[:cost] / coupon[:num],
            clearance: cart[item][:clearance],
            count: coupon[:num]
          }
          cart[item][:count] -= coupon[:num]
        elsif cart[coupon_item] && cart[item][:count] >= coupon[:num]
          cart[coupon_item][:count] += coupon[:num]
          cart[item][:count] -= coupon[:num]
        end
      end
    end
  cart
end


def apply_clearance(cart)
  cart.each do |product_name, stats|
    stats[:price] -= stats[:price] * 0.2 if stats[:clearance] == true
  end
  cart
end


def checkout(array, coupons)
  hash_cart = consolidate_cart(array)
  applied_coupons = apply_coupons(hash_cart, coupons)
  applied_clearance = apply_clearance(applied_coupons)
  total = applied_clearance.reduce(0) do |current_sum, (k, v)| 
    current_sum += v[:price] * v[:count] 
  end
  total > 100 ?  total * 0.9 : total
end

