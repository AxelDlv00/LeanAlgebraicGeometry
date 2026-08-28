Implemented and committed `1e9ba8973e` (`milne: characterize local residue surjectivity`).

Added `LinearMap.surjective_iff_surjective_residue` in `MilneLib/Nakayama.lean`: for finite targets over a local ring, surjectivity iff surjectivity after reduction modulo the maximal ideal.

Verified twice with:

```bash
$HORIZON_BIN check --lean MilneLib/Nakayama.lean
```

Both passed. The scoped file is clean in the ledger.
