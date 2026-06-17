# Blueprint-writer directive — GF tower-descent helper + Step-4 fix (iter-016)

## Chapter
`blueprint/src/chapters/Picard_FlatteningStratification.tex` (edit ONLY this file).

## Goal
The iter-015 GF prover reduced L5 (`lem:gf_polynomial_core`) Step 4 to a NEW helper
`free_localizationAway_of_away_tower`, which is distinct from L3b
(`lem:gf_splice_shortExact_free_transport`). Two must-fixes (lvb-gf + lean-auditor):

### 1. Add a blueprint block for the new helper (clears coverage debt — currently a
`lean_aux` node).
- `\label{lem:gf_away_tower_descent}`
- `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower}`
- Statement (abstract module `T`): given `g ≠ 0` in `A`, `h ≠ 0` in `Localization.Away g`,
  and freeness of `LocalizedModule (powers h) (LocalizedModule (powers g) T)` over
  `Localization.Away h`, there exists `f ≠ 0` in `A` with `LocalizedModule (powers f) T`
  free over `Localization.Away f`. In words: free over the iterated localisation
  `(T_g)_h` ⟹ free over `T_f` for a single `f ∈ A`.
- `\uses{}` (the localisation-transport facts the Lean proof actually needs — record as a
  `% LEAN DEPS:` comment for the exact Mathlib names, and cite the abstract ones in
  `\uses`): `IsLocalization.surj` (clear the denominator `h·algebraMap s = algebraMap a`,
  `s ∈ powers g`), `IsLocalization.Away.mul_of_associated` (the key ring identification
  `IsLocalization.Away (g·a) (Localization.Away h)` via `Associated (algebraMap a) h`),
  `IsLocalization.algEquiv`, `Module.Free.of_ringEquiv`, `IsLocalizedModule.linearEquiv`,
  `LinearEquiv.extendScalarsOfIsLocalization`.
- Proof sketch (from the prover's in-body plan): clear the denominator of `h` over
  `A_g` to get `a ∈ A` with `Associated (algebraMap a) h`; set `f := g·a ≠ 0` (a SINGLE
  power — see the witness caveat below); the composite localisation map
  `ψ := mkLinearMap(powers h) ∘ mkLinearMap(powers g) : T → D` satisfies
  `IsLocalizedModule (powers (g·a)) ψ` (localisation-of-localisation; prove via the three
  `IsLocalizedModule` axioms — no packaged Mathlib lemma); transport `hfree` along the
  ring iso `Away(g·a) ≅ A_h` (`IsLocalization.algEquiv`) and the induced semilinear
  module equiv (`extendScalarsOfIsLocalization`) to get `T_{g·a}` free over `A_{g·a}`.
- WITNESS CAVEAT (lean-auditor): the witness is `f := g·a` (single product), NOT a square.
  The prover's stray "hf0 hf0" note would give `f²`; state the helper's conclusion at the
  single power `g·a` so the next prover does not introduce `f²`.

### 2. Fix Step 4 of `lem:gf_polynomial_core` (~line 1204).
Step 4 currently cites `\cref{lem:gf_splice_shortExact_free_transport}` (L3b) for the
"descend the witness from `A_g` to `A`" transport. That is the WRONG lemma — L3b is the
coarser/finer `f = f'·f''` transport; the actual landed obligation is the iterated-`Away`-
tower descent. Repoint Step 4's citation to the new `\cref{lem:gf_away_tower_descent}`,
and adjust the prose: `(T_g)_h` over `(A_g)_h` ⟹ (via `lem:gf_away_tower_descent`) `T_f`
free over `A_f` for `f := g·a`. Add `lem:gf_away_tower_descent` to the proof's `\uses{}`
(line ~1151 area) and keep the existing `\uses` entries.

## Out of scope
- `genericFlatness` (GF-geo), L4 prose changes, any other block's statement/pin/marker.
- Do NOT add or remove `\leanok`.
