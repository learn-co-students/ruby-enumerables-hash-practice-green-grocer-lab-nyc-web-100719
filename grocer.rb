def consolidate_cart(cart) #cart starts as array [{"AVOCADO" => {:price => 3.00, :clearance => true}}, avocado, tempeh]
  #cart_hash[key] = value. key is "AVOCADO". Want to get {"AVOCADO" => {:price => 3.00, :clearance => true, :count => 1}}
cart_hash = {}
cart.each do |arrayitem|
  arrayitem.each do |name, iteminfo| #for each item in the array, have key(name) and value(iteminfo)
  cart_hash[name]? cart_hash[name][:count] += 1 : (cart_hash[name]= iteminfo; cart_hash[name][:count] = 1)
  #increments count if item already in cart, establishes item in cart if not and adds the key count and sets it to 1
  end
end
cart_hash
end

def apply_coupons(cart, coupons) #cart ex: {"AVOCADO" => {:price => 3.00, :clearance => true, :count => 3}, etc}
  #coupon array ex:[{:item => "AVOCADO", :num => 2, :cost => 5.00}]
  #want {"AVOCADO" => {same as before, :count => 1},"AVOCADO W/COUPON" => {:price => 2.50, :clearance => true, :count => 2}, etc}
coupons.each do |coupon|
  coupon_item = coupon[:item] #get item name out of array
  cart_item_dis = cart[coupon_item]
  applied_coupon = cart[(coupon_item + " W/COUPON")] #Has coupon been applied - does name w/coupon already exist in cart?
  if cart_item_dis && cart[coupon_item][:count] >= coupon[:num] #does the item to be couponed exist in the cart? Compares names with coupon array
    cart[(coupon_item + " W/COUPON")] = {:price => (coupon[:cost]/coupon[:num]), #cart key is item w/coupon, price from ex:5.00/2, cost/num
      :clearance => (cart_item_dis[:clearance]), #clearance same as regular item
      :count => (if applied_coupon #if item already couponed,
                applied_coupon[:count] + coupon[:num] #add couponed count to new coupon applied number
                else coupon[:num] #or new count is count of coupon
                end)}
    cart_item_dis[:count] = (cart_item_dis[:count] - coupon[:num]) #update count of non-couponed items of same name
  end #else it does not change the item in the cart if that items coupon does not exist
end
  return cart
end

def apply_clearance(cart) #discount the price of every item on clearance by 20 percent
  cart.map {|cart_key, cart_value|
    cart_value[:clearance]? cart_value[:price] = ((cart_value[:price])*0.8).round(2) : cart_value[:price]} #is clearance true? True - apply 20% discount : False - keep same price
  return cart
end

def checkout(cart, coupons)
consolidated_cart = consolidate_cart(cart)
coupon_cart = apply_coupons(consolidated_cart, coupons)
clearance_cart = apply_clearance(coupon_cart)
total = clearance_cart.reduce(0) {|acc, (name, details)| acc += (details[:price])*(details[:count])}
total > 100 ? total*0.9 : total
end
