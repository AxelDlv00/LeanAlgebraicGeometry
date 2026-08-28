Implemented and committed `HartshorneLib/Chapter1Prime.lean` in ledger commit `9d26035fd7c4e3812e589dd97e06c0cbea9e2a0f`.

The module adds:

- `vanishingIdeal_isPrime_of_isAffineVariety`
- `vanishingIdeal_radical_of_isAffineVariety`

Both are sorry-free. LSP diagnostics are clean, Horizon’s serialized check passed in 3.9s, and axiom scans report only standard axioms (`propext`, `Classical.choice`, `Quot.sound`).
