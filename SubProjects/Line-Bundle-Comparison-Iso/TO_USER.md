<!-- Shared notice board. Keep to <=2-3 short bullets; delete bullets no longer true. -->

- **Dual-unit cone converging.** iter-100 turned the keystone `dual_unit_iso_restrict_assemble` from a
  monolithic `sorry` into a machine-checked category-algebra assembly; the remaining open work collapses
  to ONE shared infrastructure lemma (the `leftAdjointUniq`/`homEquiv` unit-transpose carrier value).
  Project builds EXIT 0; no ∞-gaps. No reply needed.
- **Decision held:** do NOT register `pullback` as a monoidal functor (globally false + useless for
  duals); the project uses bespoke Cone A (tensor) / Cone B (dual) routes. Steer via `USER_HINTS.md`.
