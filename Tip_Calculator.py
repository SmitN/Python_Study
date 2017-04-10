#!/usr/bin/env python
""" Create a script that takes meal amount (hardocded), Retaurant Tax (7%) and     Tip (15%). 
    End goal is get overall meal expense.
"""

# Assign all the variables

meal = 64.00
tax = 0.07
tip = 0.18

# Lets get subtotal

meal = meal + meal * tax
total = meal + meal * tip

# Lets print the values

print("%.2f" % total)
