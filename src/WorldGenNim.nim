# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import nimraylib_now/[raylib]
import WorldGenNimpkg/hex

when isMainModule:
#   var testGrid = @[
#     Hex(q: -2, r: -2, s: 4),
#     Hex(q: -1, r: -2, s: -3),
#     Hex(q: 0, r: -2, s: 2),
#     Hex(q: 1, r: -2, s: 1),
#     Hex(q: 2, r: -2, s: 0),
#     Hex(q: 3, r: -2, s: -1),
#     Hex(q: 4, r: -2, s: -2),
#     Hex(q: -3, r: -1, s: 4),
#     Hex(q: -2, r: -1, s: 3),
#     Hex(q: -1, r: -1, s: 2),
#     Hex(q: 0, r: -1, s: 1),
#     Hex(q: 1, r: -1, s: 0),
#     Hex(q: 2, r: -1, s: -1),
#     Hex(q: 3, r: -1, s: -2),
#     Hex(q: 4, r: -1, s: -3),
#   ]

  var testGrid: seq[Hex] = @[]

  for idx in -5 .. 5:
    for idy in -4 .. 4:
      testGrid.add(Hex(q: idx, r: idy, s: -idx - idy))
  
  const layout = HexLayout(
    ori: pointyOrientation,
    size: (50, 50),
    origin: (400, 300)
  )

  initWindow(800, 600, "hex")
  setTargetFPS(60)

  while not windowShouldClose():
    beginDrawing()
    clearBackground(Raywhite)
    drawHexGridLines(testGrid, layout)
    endDrawing()
  closeWindow()