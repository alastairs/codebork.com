---
layout: post
title: 'Code Kata: Supermarket Pricing'
author: alastairs
nid: 156
created: 1305497878
---
So this afternoon I've been attempting the first of The Pragmatic Programmers' kata.  This is a modelling-only exercise, designed to get you thinking around a problem. You'll need to be familiar with the kata in order to get the most out of this post, so I'll go get a cup of tea whilst you <a href="http://codekata.pragprog.com/2007/01/code_kata_one_s.html">go read up on it</a>.
<!--break-->
Ok, now that you're more familiar with the kata and I'm adeqately refreshed, let's take a look at this thing.  I've come up with two approaches for your critique, and I suspect there's a better one just out of my reach.

<h3>Solution 1: a simplistic solution</h3>

Assuming we have a class called <code>Product</code>, it has one field called <code>Price</code>.  This solution essentially assumes that the actual price of an item changes when its put on offer.  For example, the can of beans at £0.65 becomes £0.33 per can when placed on a 3 for £1 offer; as a result of this, fractional money is permitted in this model to ensure correct rounding (so a single can is actually 33.3333&hellip;p recurring, not £0.33); without fractional money, products must have unequal pricing to make up for rounding errors (such as two cans at £0.33 and one at £0.34).  

This obviously leads us into a number of potential problems.  For example, all cans are now on sale on the offer price, no matter what quantity you purchase them in; furthermore, the shelf of 100 cans is now valued at £33.33, whereas it might be better for the supermarket to continue to value that shelf at the full £65.  

Equally, this approach doesn't work for items priced by quantity, such as loose strawberries priced at £1.99/kilo.  Is the price £1.99?  Do you then sell, for example, a quarter of a product priced accordingly?  

Buy-2-get-1-free can only work here if you calculate the price of a can as (£0.65 * 2)/3, in which case you are again changing the price of all cans on sale, no matter whether the customer buys 1 or follows the "rules" of the offer.

I think rounding wouldn't need to happen, as fractional money is permitted by the model.  However, once the prices have all been resolved, they would need to be rounded to the usual whole penny.  

<h3>Solution 2: a better (?) solution</h3>

The first solution could use some improvement.  For starters, the fractional money doesn't model the real world: no one carries around 0.5p any more, let alone 0.3333&hellip;p.  My second attempt sees the <code>Product</code> class expose two price fields: the base price (i.e., the standard retail price), and the offer price.

In the 3-for-a-pound scenario, the base price remains at £0.65 (this is fixed for the product) and the offer price is set to £0.33.  Rounding happens when setting the offer price.  The solves the problem of purchasing 4 cans in the offer, as you can calculate that the correct price is (offer price * 3) + base price.  <em>Or is it?</em>  In actual fact, the enforced rounding requires compensation: it should actually be ((offer price * 3) + £0.01) + base price.  An audit log would be needed to ensure that this was functioning correctly!

In the buy-2-get-1-free scenario, it becomes very difficult to work out what the offer price should be.  The best I could come up with was ((base price * 2)/3), which would be appropriately rounded (and again would need to be compensated for).  

This model is equivalent to the previous one for the strawberries.  The price per kilo is set as the base price, and is resolved at the point of sale.

However, in its favour, the shelf of 100 cans of beans is now deemed to be worth the full £65 again, and fractional money is not permitted by the model.  

So, this improves only slightly on the simplistic model, and all those extra pennies being added in feels a bit like the <a href="http://en.wikipedia.org/wiki/Deferent_and_epicycle" title="Deferent and Epicycle">epicycles</a> of old.  Additionally, they're obviously a recipe for disaster.

<h3>Solution 3: the "Enterprise" solution</h3>

The idea with this solution is to add in an external service to handle the responsibilities of calculating and administering the offers. So, a <code>Product</code> now has a flag to indicate whether or not it is a discrete item (such as a can of beans) or sold by quantity (such as loose strawberries). A <code>PriceManager</code> takes a <code>Product</code> and a quantity and resolves that to a price, e.g., for one can of beans, it would return £0.65; for 300g of strawberries priced at £1.99/kilo, it would return £0.60.  Rounding takes place within the <code>PriceManager</code>, and is calculated to the nearest penny.  The <code>PriceManager</code> calls an <code>OfferManager</code> to resolve any special offers applicable.  The <code>OfferManager</code> returns to the <code>PriceManager</code> an method for calculating the offer for that product.  Until the offer is satisfied, the <code>PriceManager</code> continues to return the standard retail price for the item (e.g., £0.65 for a can of beans), and when the offer rule is completely matched, the final item in the offer makes up the difference in price.  

So, for three cans of beans for £1, the <code>PriceManager</code> obtains an <code>Offer</code> stating that it requires three cans of beans.  The <code>PriceManager</code> returns £0.65 for the first two cans and -£0.95 for the third.  It will continue doing this for as many cans of beans as are purchased by the customer, thereby correctly charging the customer for the beans

In the buy two get one free offer, the <code>PriceManager</code> again obtains an <code>Offer</code> stating that it requires three cans of beans, and again returns £0.65 for the first two cans.  For the third can, it returns £0.00.  As before, it will continue doing this for as many cans of beans as are purchased by the customer, correctly applying the order.  

Finally, it separates the ideas of cost and price, so that the shelf of 100 cans of beans is still valued at £0.65 for stock costing purposes, even though it will be sold at a lower price.  

<h3>Conclusion</h3>

I think solution 3 is the most "correct", in terms of addressing the problem domain, but it seems really heavyweight (hence the title).  I welcome your feedback on these models, and would be interested to hear your own ideas on how to approach them.
