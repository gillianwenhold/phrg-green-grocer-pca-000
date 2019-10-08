def consolidate_cart(cart)
  new_cart = {}
  cart.each do |item|
    item.each do |name, info|
      if new_cart[name]
        info[:count] += 1
      else
        info[:count] = 1
        new_cart[name] = info
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  new_cart = {}
  cart.each do |item, info|
    new_cart[item] = info
    coupons.each do |coupon|
      if coupon[:item] == item
        new_cart[item + " W/COUPON"] = {}
        new_cart[item + " W/COUPON"][:clearance] = info[:clearance]
      end
    end
  end
  final_cart = coupon_results(cart, new_cart, coupons)
end



def apply_clearance(cart)
  clearance_cart = cart.each do |item, info|
    if info[:clearance] == true
      info[:price] = (info[:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  puts "CONSOLIDATED: " + consolidated_cart.to_s
  coupons_cart = apply_coupons(consolidated_cart, coupons)
  puts "COUPONS: " + coupons_cart.to_s
  clearance_cart = apply_clearance(coupons_cart)
  puts "CLEARANCE: " + clearance_cart.to_s
  prices = []
  clearance_cart.each do |item, info|
    prices << (info[:price] * info[:count]).round(2)
  end
  final = prices.sum
  if final > 100
    final = (final * 0.9).round(2)
  end
  final
end

def coupon_results(cart, new_cart, coupons)
  coupon_items = []
  coupons.each do |coupon|
    if coupon_items.include? coupon[:item]
      if new_cart[coupon[:item]][:count] >= coupon[:num]
        new_cart[coupon[:item] + " W/COUPON"][:count] += 1
        new_cart[coupon[:item]][:count] -= coupon[:num]
      end
    else
      if cart.keys.include? coupon[:item]
        if new_cart[coupon[:item]][:count] >= coupon[:num]
          coupon_items << coupon[:item]
          new_cart[coupon[:item] + " W/COUPON"][:price] = coupon[:cost]
          new_cart[coupon[:item] + " W/COUPON"][:count] = 1
          new_cart[coupon[:item]][:count] -= coupon[:num]
        end
      end
    end
  end
  new_cart
end
