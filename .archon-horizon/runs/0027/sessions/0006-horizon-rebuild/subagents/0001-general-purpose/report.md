Everything is complete and verified. Here is the final report.

## Summary

Created `AlgebraicJacobian/Picard/DivisorClass.lean` (465 lines, ≤ 500) implementing §2.6(a) of the wave-3 Picard design, and added `import AlgebraicJacobian.Picard.DivisorClass` to `AlgebraicJacobian.lean` right after the `.Picard.RelPic` line. No other files touched.

### (a) Declarations landed (one-line semantics)

Generic helper (in `CategoryTheory.PresheafOfGroups`):
- `OneCocycle.ext_evInf` (private) — two 1-cocycles over a poset are equal if their `evInf` pair values agree.

In `AlgebraicGeometry.Scheme`:
- `sectionRestrict_comp`, `coe_unitsRestrict` (private) — ring-restriction composition; coe of a restricted unit = ring restriction of its coe.
- `unitsCocycle_ext` — a unit cocycle is determined by its `unitsEvInf` pair values.
- `unitsCocycle_isCohomologous` — cohomology criterion from a units 0-cochain conjugating pair values.
- `structure LocalEquations` — fields `cover : PointedCover`, `eqn : ∀ x, Γ(X, cover.opens x)`, `regular` (germ of `eqn x` at every point is a nonzerodivisor in the stalk), `ratio_isUnit` (overlap ratios are units).

In `Scheme.LocalEquations`:
- `eqn_restrict_mem_nonZeroDivisors` — every restriction of an equation to a sub-open is a nonzerodivisor (via sheaf `section_ext` + germ-nonzerodivisibility). [Deliverable 2]
- `ratioUnit`, `eqn_restrict_eq`, `ratioUnit_unique` — the transition unit `g x y = eqn x / eqn y`, its defining equation, and uniqueness from regularity. [Deliverable 3]
- `ratioUnit_trans` — cocycle identity `g x y · g y z = g x z` on triple overlaps (mirrors `unitsEvInf_trans`). [Deliverable 4]
- `unitsCocycle`, `unitsCocycle_evInf`, `picClass` — the Čech 1-cocycle (via `OneCocycle.ofPairs`), its pair values, and the Picard class `𝒪(D) = CechPic.mk cover class`. [Deliverables 1, 4]
- `restrict`, `restrict_ratioUnit`, `picClass_restrict` — refine along `𝒱 ≤ cover`; class unchanged (`mk_unitsRes`). [Deliverable 6]
- `mul` (+ `mul_ratio_eq`, `mul_ratioUnit`, `picClass_mul`) — pointwise product on `cover ⊓ cover'`; `(d.mul d').picClass = d.picClass * d'.picClass` (anchored on `mk_mul_mk_inf`). [Deliverable 7]
- `rescale` (+ `rescale_ratio_eq`, `rescale_ratioUnit`, `inv_mul_mul_inv_cancel`, `rescale_coboundary`, `picClass_rescale`) — multiply equations by units; class unchanged via the `v⁻¹` coboundary (`IsCohomologous.class_eq`). [Deliverable 5]

### (b) Verification commands run
- `lake env lean AlgebraicJacobian/Picard/DivisorClass.lean` → **EXIT=0**.
- `lake build AlgebraicJacobian.Picard.DivisorClass` → **EXIT=0** (olean at `.lake/build/lib/lean/.../DivisorClass.olean`; only the pre-existing "Copyright too short" header lint, matching Pic.lean's style).
- `lake env lean AlgebraicJacobian.lean` (root aggregator with new import) → **EXIT=0**, no errors.
- Final LSP diagnostics on the file → **empty** (zero errors/warnings).

### (c) Axiom audit
`#print axioms` on `picClass`, `eqn_restrict_mem_nonZeroDivisors`, `ratioUnit_trans`, `picClass_restrict`, `picClass_mul`, `picClass_rescale` — every one reports exactly `[propext, Classical.choice, Quot.sound]`. No `sorry`, no new axioms.

### (d) Attempted and deleted
None deleted in the final file — all attempted deliverables (1–7) closed. The path there hit two temporary dead-ends, both worked around rather than abandoned:
- `mul`/`rescale` initially failed with the layer's "target not type-correct under `instances` transparency" wall whenever `rw`/`simp` touched `unitsEvInf`/`X.unitsRestrict`/`.res`/`*`-of-cocycles. Fixed by the memory's recipe: replace those `rw`s with term-mode (`calc`, `congrArg`, `.trans`) and a `rfl`-closed `have`, plus explicit `ˣ` type-ascriptions to resolve `HMul` metavariable stalls on nested infima.

### (e) Deviations from the spec shapes
- **Deliverable 8 (pullback) not implemented** — spec-marked "only if you still have room and everything above is green." At 465/500 lines, faithfully mirroring `pullbackUnitsCocycle` plus a `hreg` pulled-back-regularity hypothesis would exceed the line cap, so it was omitted (not attempted-and-broken).
- **`ratio_isUnit` uses the explicit `∃ u : Γ(…)ˣ` form** (the design's clarifying note) rather than the bare `IsUnit (…)` sketch, so `ratioUnit`/`eqn_restrict_eq` extract cleanly.
- **Deliverable 5 realized as `rescale`** (a unitwise-rescaling operation on a single `LocalEquations`, same cover by construction) rather than comparing two arbitrary same-cover systems — the spec's suggested "defeq-friendly variant," which sidesteps cover-cast friction.
- `picClass`, `ratioUnit`, `restrict`, `mul`, `rescale` are `noncomputable`/plain `def` as appropriate (`ratioUnit` uses `Exists.choose`); all `Prop` fields keep the structure itself in `Type u`.
