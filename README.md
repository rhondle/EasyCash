# EasyCash
#### A simple POS system designed for my school cafeteria in 1995

In 1995 - when I was in high school - I suggested the idea of writing a simple point of sale system to the teacher who was responsible for overseeing the cafeteria program.

The cafeteria was fairly simple; the students enrolled in the economics class would take turns running it as a simple business, buying and selling a few frozen meals and treats to hungry students at lunchtime. The operation was quite basic: they kept track of sales on a piece of paper and I felt that it would be a simple task to improve on this process with a small computer program.

Because students rarely had much money of their own, the idea was that a notice could be sent home to parents requesting that they purchase gift cards for their kids to redeem for food at the cafeteria. And, as a bonus, they would be able to request and receive a detailed report showing what was purchased, the cost, and the date/time of each purchase as well as the remaining card balance.

An important feature is that the system implements a two-tiered card validation approach: because disk accesses are slow, a simple checksum to protect against mistyped (or fake) card numbers, followed by an actual lookup of the card number against a simple database. Extending the database was planned with an index for speed, and encryption for protection against tampering.

I started work on the project but abandoned it a short while later when it became apparent that there really wasn't any interest in it, despite what I had been led to believe. Needless to say, I was a bit irritated that my time had been wasted.

Nonetheless this program is mostly functional. Enjoy some screen shots and the ancient Pascal code :)

