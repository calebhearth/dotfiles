# ErgoDox EZ Key Index to Physical Position Mapping

The ErgoDox EZ has 76 keys per layer (indices 0-75). This document maps each index
to its physical position on the keyboard.

## Main Keys (Indices 0-37)

These follow the `LAYOUT_ergodox()` parameter order from QMK's `ergodox_ez.h`.

### Left Hand (Indices 0-34)

```
Row 1:  0    1    2    3    4    5    6
Row 2:  7    8    9   10   11   12   13
Row 3: 14   15   16   17   18   19   --
Row 4: 20   21   22   23   24   25   26
Row 5: 27   28   29   30   31   --   --
```

### Right Hand (Indices 32-69)

```
Row 1: 32   33   34   35   36   37   38
Row 2: 39   40   41   42   43   44   45
Row 3: --   46   47   48   49   50   51
Row 4: 52   53   54   55   56   57   58
Row 5: --   --   59   60   61   62   63
```

Note: The exact index boundaries above are approximate. The definitive mapping was
determined empirically by clicking each key in the Oryx UI and reading its index
from the URL.

## Thumb Clusters (Indices 64-75)

The thumb cluster mapping is non-obvious because Oryx's index order doesn't match
the physical layout or the LAYOUT_ergodox parameter order. These were determined
empirically.

### Left Thumb Cluster

Physical layout and corresponding Oryx indices:

```
                    ,-----------.
                    | 69  | 68  |     <- top row (Home, End on Base)
              ,-----|-----|-----|
              |     |     | 67  |     <- PgUp on Base
              | 66  | 65  |-----|
              |     |     | 64  |     <- PgDn on Base
              `-------------------'
                ^     ^
                |     Del on Base
                Backspace on Base
```

Index to key mapping (Base layer example):
- 64: PgDn (bottom inner)
- 65: Del (middle center)
- 66: Backspace (large bottom key)
- 67: PgUp (middle inner)
- 68: End (top right)
- 69: Home (top left)

### Right Thumb Cluster

Physical layout and corresponding Oryx indices:

```
,-----------.
| 74  | 75  |                        <- top row (Left, Right on Base)
|-----|-----|-----.
| 73  |     |     |                  <- Up on Base
|-----| 71  | 70  |
| 72  |     |     |                  <- Down on Base
`-------------------'
        ^     ^
        |     Space on Base
        Enter on Base
```

Index to key mapping (Base layer example):
- 70: Space (large bottom key)
- 71: Enter (middle center)
- 72: Down (bottom inner)
- 73: Up (middle inner)
- 74: Left (top left)
- 75: Right (top right)

## LAYOUT_ergodox Parameter Order vs. Oryx Indices

When reading a `LAYOUT_ergodox()` call in QMK source, the parameters follow this
order (left hand, then right hand, row by row, then thumb cluster). The thumb
cluster parameters in `LAYOUT_ergodox()` do NOT match the Oryx index order.

Use the tables above to translate. When in doubt, create a test key in the Oryx UI,
click on it, and read the index from the URL (it appears as the last number in the
path, e.g., `/ergodox-ez/layouts/GmLxR/latest/0/42` means layer 0, key index 42).
