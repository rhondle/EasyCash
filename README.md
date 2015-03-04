# EasyCash
####A simple POS system designed for my school cafeteria in 1995

In 1995, during high school, I suggested the idea of writing a simple point of sale system to the teacher who was responsible for overseeing the cafeteria program.

The cafeteria was fairly simple; the students enrolled in the economics class would take turns running it as a simple business, buying and selling a few frozen meals and treats to hungry students at lunchtime. The operation was quite basic; they kept track of sales on a piece of paper and I felt that it would be simple to improve on this process.

The ideas was that since students rarely had much money of their own, it would be trivial to set a notice out to parents allowing them to purchase gift cards for their kids that could be redeemed at the cafeteria, and as a bonus, be able to request and receive a detailed report showing what was purchased, the cost, and the date/time of each purchase.

One obvious feature is that the system implements a two-tiered card validation approach: a simple checksum to protect against mistyped (or fake) card numbers, and a more intensive lookup of the actual number against a simple database - it was intended to add an index and also encrypt the database in production.

I started work on the project but abandoned it a short while later when it became apparent that there really wasn't any interest in it, despite what I had been led to believe.

