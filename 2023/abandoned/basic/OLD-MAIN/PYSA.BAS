  SCREEN 13
  sunattr = 14
  x = 120: y = 100


  'рисует новое солнце:
  'тело

      'рот
    CIRCLE (x, y + (5)), (2.9), 10
    PAINT (x, y + (5)), 4, 0
    CIRCLE (x, y), 20, 4
  'глаза
  CIRCLE (x - 3, y - 2), 3, 1
  CIRCLE (x + 3, y - 2), 3, 1
  PSET (x - 3, y - 2), i
  PSET (x + 3, y - 2), i

    FOR i = 1 TO 255
    CIRCLE (x, y + (5)), (2.9), i
    PAINT (x, y + (5)), 4, i
    SOUND i + 50 + RND * 2000, .1
  PSET (x - 3, y - 2), i
  PSET (x + 3, y - 2), i
FOR j = 1 TO 100: NEXT
    NEXT

