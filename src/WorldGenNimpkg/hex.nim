import std/[math, strformat]
import nimraylib_now/[raylib, raymath, raygui]

type
    Vector2Int* = (int, int)
    HexPoint* = Vector2Int
    HexSize* = Vector2Int
    Hex* = object
        q*, r*, s*: int
    HexF* = object
        q*, r*, s*: float
    HexOrientation* = object
        forMatrix*: Vector4
        invMatrix*: Vector4
    HexLayout* = object
        ori*: HexOrientation
        size*: HexSize
        origin*: HexPoint
    HexLayoutRef* = ref HexLayout

const
    hexDirs* = [
        Hex(q: 1, r: 0, s: -1),
        Hex(q: 1, r: -1, s: 0),
        Hex(q: 0, r: -1, s: 1),
        Hex(q: -1, r: 0, s: 1),
        Hex(q: -1, r: 1, s: 0),
        Hex(q: 0, r: 1, s: -1)
    ]
    pointyOrientation* = HexOrientation(
        forMatrix: Vector4(x: sqrt(3'f), y: sqrt(3'f)/2, z: 0, w: 3/2),
        invMatrix: Vector4(x: sqrt(3'f)/3, y: -1/3, z: 0, w: 2/3)
    )

func `x`*(vec2Int: Vector2Int): int = vec2Int[0]
func `y`*(vec2Int: Vector2Int): int = vec2Int[1]
func `width`*(hexSize: HexSize): int = hexSize[0]
func `height`*(hexSize: HexSize): int = hexSize[1]
func `+`*(left: Hex, right: Hex): Hex =
    result = Hex(q: left.q + right.q, r: left.r + right.r, s: left.s + right.s)
func `-`*(left: Hex, right: Hex): Hex =
    result = Hex(q: left.q - right.q, r: left.r - right.r, s: left.s - right.s)
func `*`*(left: Hex, right: int): Hex =
    result = Hex(q: left.q * right, r: left.r * right, s: left.s * right)
func `*`*(left: int, right: Hex): Hex =
    result = right * left
func `rotateLeft`*(hex: Hex): Hex =
    result = Hex(q: -hex.s, r: -hex.q, s: -hex.r)
func `rotateRight`*(hex: Hex): Hex =
    result = Hex(q: -hex.r, r: -hex.s, s: -hex.q)
func `toDirection`*(operand: int): Hex =
    result = hexDirs[(6 + (operand mod 6)) mod 6]
func `magnitude`*(hex: Hex): int =
    result = int((abs(hex.q) + abs(hex.r) + abs(hex.s)) / 2)
func `distance`*(left: Hex, right: Hex): int =
    result = magnitude (left - right)
func `toVec2`*(hex: Hex, l: HexLayout): Vector2 =
    let x = (l.ori.forMatrix.x * float(hex.q) + l.ori.forMatrix.y * float(hex.r)) * float(l.size.width)
    let y = (l.ori.forMatrix.z * float(hex.q) + l.ori.forMatrix.w * float(hex.r)) * float(l.size.height)
    result = Vector2(x: x + float(l.origin.x), y: y + float(l.origin.y))
func `toHex`*(vec2: Vector2, l: HexLayout): HexF =
    let
        point = Vector2(
        x: (vec2.x - float(l.origin.x)) / float(l.size.width),
        y: (vec2.y - float(l.origin.y)) / float(l.size.height)
        )
        q = l.ori.invMatrix.x * point.x + l.ori.invMatrix.y * point.y
        r = l.ori.invMatrix.z * point.x + l.ori.invMatrix.w * point.y
    result = HexF(q: q, r: r, s: -q - r)


proc `drawHexGridLines`*(hexSeq: seq[Hex], layout: HexLayout) =
    for hex in hexSeq:
        let vec2 = hex.toVec2(layout)
        drawPolyLines(
            vec2,
            6,
            float layout.size.width,
            0,
            Red
        )
        drawText(
            cstring fmt"{hex.q}, {hex.r}",
            int vec2.x,
            int vec2.y,
            10,
            Red)