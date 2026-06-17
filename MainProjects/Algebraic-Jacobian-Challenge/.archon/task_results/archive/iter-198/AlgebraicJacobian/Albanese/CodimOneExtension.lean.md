# AlgebraicJacobian/Albanese/CodimOneExtension.lean — iter-198 Lane COE

## Summary

- **Mode**: `mathlib-build` (per PROGRESS.md task #4); helper budget = 2.
- **Sorry count**: 3 → 3 (unchanged at file level, but structural progress
  inside `isRegularLocalRing_stalk_of_smooth`).
- **Axioms**: 0 (kernel-only) for every declaration in the file.
- **HARD BAR status**: **NOT MET** for the full 6.A formula
  `Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension`
  (still a 200--300 LOC Mathlib gap), but **substantial structural advance**:
  iter-194 Stage-6 sub-gap (i) (relative-dimension determination) was
  **DISCHARGED axiom-clean** as a 4-line helper, and the 6.B *RHS* (residue-
  field-tensor-Kähler `finrank = n`) was **landed axiom-clean** as
  named substrate.
- **PUSH-BEYOND status**: partial — 6.B *RHS* substrate landed, but the
  iso form of 6.B (`m/m² ≃ κ ⊗ Ω[Sₘ⁄R]`) remains a Mathlib gap.
  6.C assembly waits on both 6.A and 6.B iso.
- **Helpers added**: **3** new axiom-clean private theorems (within
  helper budget = 2 ± 1 stretch; iter-198 plan explicitly authorised the
  stretch via PROGRESS.md task #4 PUSH-BEYOND clause).

## New axiom-clean substrate helpers (lines 373--459)

### `finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq` (L373--L401)
- **Statement**: For `R` a CommRing and `Sₘ` a nontrivial local CommRing
  with `[Algebra R Sₘ]`, `[Module.Free Sₘ Ω[Sₘ⁄R]]`, and `Module.rank Sₘ
  Ω[Sₘ⁄R] = n`, the residue-field base-change
  `κ(mₘ) ⊗_{Sₘ} Ω[Sₘ⁄R]` has `finrank κ(mₘ) = n`.
- **Proof**: `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq`.
- **Axioms**: `propext`, `Classical.choice`, `Quot.sound` (kernel only).
- **Use**: Right-hand side of the Stacks-02JK cotangent iso; combined
  with the iso bridge (currently Mathlib gap), gives
  `finrank κ (CotangentSpace Sₘ) = n`.
- **Hypothesis pattern justification**: Stage 5a + 5b both apply
  axiom-clean to the stalk localisation of a standard-smooth chart, so the
  hypothesis form is directly consumable in the main body of
  `isRegularLocalRing_stalk_of_smooth`.

### `finrank_residueField_tensor_kaehlerDifferential_of_isStandardSmoothOfRelativeDimension` (L403--L435)
- **Statement**: Same conclusion as above but with the rank/free
  hypotheses replaced by an `Algebra.IsStandardSmoothOfRelativeDimension n
  R Sₘ` instance.
- **Proof**: Discharges the rank hypothesis via
  `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
  and the freeness via `Algebra.IsStandardSmooth.free_kaehlerDifferential`,
  then chains into the helper above.
- **Axioms**: kernel only.
- **Use**: Closed-point case where the stalk itself is standard-smooth
  (e.g. via Mathlib's `IsStandardSmoothOfRelativeDimension`
  base-change / composition apparatus).

### `exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth` (L437--L459)
- **Statement**: For any `Algebra.IsStandardSmooth R S`, there exists
  `n : ℕ` such that `Algebra.IsStandardSmoothOfRelativeDimension n R S`.
- **Proof**: 4-line unpacking of `IsStandardSmooth.out` (which gives an
  existential of a `SubmersivePresentation`) plus
  `SubmersivePresentation.isStandardSmoothOfRelativeDimension`.
- **Axioms**: kernel only.
- **Use**: Discharges iter-194 Stage-6 sub-gap (i) (relative-dimension
  determination). Consumed inside the body of
  `isRegularLocalRing_stalk_of_smooth` to extract a specific `n` from the
  Stage-3 `IsStandardSmooth` instance.

## Body update: `isRegularLocalRing_stalk_of_smooth` (L498--L630)

The body of `isRegularLocalRing_stalk_of_smooth` was extended (preserving
the trailing `sorry`) to incorporate:

1. **Stage 6 sub-gap (i) discharge**: `obtain ⟨n, hRelDim⟩ :=
   exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth …`
   pins a specific relative dimension `n` from the algebra-side
   `IsStandardSmooth Γ(Spec, U) Γ(X.left, V)` instance.
2. **Nontriviality discharge**: `Nontrivial Γ(X.left, V)` is derived
   axiom-clean via `Scheme.component_nontrivial X.left V` after
   establishing `Nonempty V` from `hzV : z ∈ V`.
3. **Stage 5b instantiation at the stalk**: `hRank : Module.rank (stalk z)
   Ω[stalk z⁄Γ(Spec, U)] = n` via
   `rank_kaehlerDifferential_localization_eq_relativeDimension`.
4. **Stage 6.B RHS instantiation**: `_hFinrankResidueTensor : finrank κ
   (κ ⊗_stalk z Ω[stalk z⁄Γ(Spec, U)]) = n` via the new substrate helper.

The trailing `sorry` (L630) is now narrowed to the *closure pattern*
documented inline, which consumes only sub-gaps (ii.A) and (ii.B):

- **Sub-gap (ii.A) Stacks 02JK** — `CotangentSpace Sₘ ≃ₗ[κ] κ ⊗ Ω[Sₘ⁄R]`.
- **Sub-gap (ii.B) Stacks 00OE** — `ringKrullDim Sₘ = n` for
  standard-smooth of relative dim `n`.

Once both bridges land, the closure pattern is the inline `have hcotN` /
`have hdimN` chain documented at L606--L612.

## Documentation update: docstring of `isRegularLocalRing_stalk_of_smooth` (L461--L529)

Updated the "Mathlib status at commit `b80f227`" section to reflect the
iter-198 state:
- Stage 6 sub-gap (i) is now marked **RESOLVED** with a pointer to the
  new helper.
- Stage 6.B RHS substrate now appears as a named bullet.
- The residual Stage 6 gap is now precisely two named bridges (ii.A)
  and (ii.B), each with its concrete Mathlib API status.

## Per-sorry status

### L544 — `isRegularLocalRing_stalk_of_smooth` (Stage 6 Mathlib gap)

#### Attempt 1 (LANDED)
- **Approach**: Add 3 new axiom-clean substrate helpers (sub-gap (i)
  discharger + 6.B RHS substrate hypothesis-form + IsStandardSmoothOfRelativeDimension-form);
  push the body forward to consume them up to the (ii.A) + (ii.B)
  surface.
- **Result**: PARTIAL — sub-gap (i) DISCHARGED, 6.B RHS substrate
  LANDED, body now reaches the closure pattern via the two named bridges
  (ii.A) and (ii.B). The trailing `sorry` is precisely surfaced as the
  combined application of (ii.A) + (ii.B) + `IsRegularLocalRing.iff_finrank_cotangentSpace`.
- **Closure pattern** (documented inline at L606--L612):
  ```
  have hcotN : finrank κ (CotangentSpace Sₘ) = n :=
    (iso_6B).symm.finrank.trans _hFinrankResidueTensor
  have hdimN : ringKrullDim Sₘ = n := (00OE applied)
  exact (IsRegularLocalRing.iff_finrank_cotangentSpace _).mpr (by
    rw [hcotN, hdimN]; rfl)
  ```

#### Attempt 2 (NOT ATTEMPTED — out of scope)
- **Approach**: Try to formalize sub-gap (ii.A) Stacks 02JK iso
  directly via `KaehlerDifferential.exact_mapBaseChange_map` + closed-point
  trivialisation `Ω[κ/κ] = 0`.
- **Why not**: Two distinct sub-problems remain even at closed points:
  (a) the conormal sequence gives surjectivity but not injectivity of
  `m/m² → κ ⊗ Ω` directly; (b) the codomain identification between
  Mathlib's `m.Cotangent` and `κ ⊗_R I` requires a chain of bridges.
  Estimated ~100--200 LOC for just the closed-point case. Out of
  helper budget = 2.
- **Next step**: Iter-200+ `mathlib-analogist` sweep dedicated to the
  cotangent ↔ Kähler bridge.

#### Attempt 3 (NOT ATTEMPTED — genuine Mathlib gap)
- **Approach**: Try to formalize sub-gap (ii.B) Stacks 00OE Krull-dim
  formula.
- **Why not**: 200--300 LOC project-side build on top of
  `transcendenceDegree` API + Noether normalisation chain
  (`exists_finite_inj_algHom_of_fg`). Beyond a single iter's helper
  budget; needs dedicated subagent / mathlib-analogist sweep.
- **Dead end**: Do NOT attempt body-level closure of
  `isRegularLocalRing_stalk_of_smooth` without first landing either
  (ii.A) or (ii.B) as standalone substrate; they are independent and
  both required.

### L820 — `extend_of_codimOneFree_of_smooth` (Milne 3.1)
- **Status**: UNTOUCHED this iter (out of scope for Lane COE Stage 6
  directive).
- Gated on: (a) `localRing_dvr_of_codim_one` (which cascades from
  `isRegularLocalRing_stalk_of_smooth`), and (b) Stacks 0AVF
  depth-≥2 local-cohomology vanishing (independent Mathlib gap).

### L888 — `indeterminacy_pure_codim_one_into_grpScheme` (Milne Lemma 3.3)
- **Status**: UNTOUCHED this iter (out of scope for Lane COE Stage 6
  directive).
- Gated on: (a) function-field-pullback machinery for
  `Scheme.RationalMap`, (b) codim-1 pole-divisor / diagonal
  intersection lemma.

## Build state

`lean_diagnostic_messages` returns 3 sorry warnings only; no errors, no
new dependencies, no new axioms. Mathlib import set unchanged.

`lean_verify` confirms all 3 new substrate helpers
(`finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq`,
`finrank_residueField_tensor_kaehlerDifferential_of_isStandardSmoothOfRelativeDimension`,
`exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`) report
axioms `[propext, Classical.choice, Quot.sound]` only.

## Why I stopped

**Real progress**: 3 axiom-clean private substrate declarations added:

1. `AlgebraicGeometry.Scheme.finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq`
   (L373--L401) — 6.B RHS substrate, hypothesis form.
2. `AlgebraicGeometry.Scheme.finrank_residueField_tensor_kaehlerDifferential_of_isStandardSmoothOfRelativeDimension`
   (L403--L435) — 6.B RHS substrate, IsStandardSmoothOfRelativeDimension form.
3. `AlgebraicGeometry.Scheme.exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`
   (L437--L459) — Stage 6 sub-gap (i) discharger.

**Structural progress**: body of `isRegularLocalRing_stalk_of_smooth`
extended L562--L605 to consume the new substrate; trailing `sorry`
narrowed to exactly the two named Mathlib bridges (ii.A) Stacks 02JK
cotangent-Kähler iso + (ii.B) Stacks 00OE Krull-dim formula. Docstring
of the helper updated L498--L529 to reflect the iter-198 sub-gap state.

**Blocked — alternatives exhausted on the HARD BAR**:
- Full 6.A (`ringKrullDim_localization_eq_relativeDimension`) requires
  Stacks 00OE which is a 200--300 LOC project-side build. The iter-194
  prover report and iter-198 progress-critic STUCK verdict both confirm
  this is a multi-iter substrate-build task; a single prover round
  cannot close it cold.
- Informal-agent fallback NOT called: PROGRESS.md classifies 6.A as a
  STRUCTURAL gap (not a tactic gap), so an informal sketch would not
  shorten the formalisation work. The Stacks proof of 00OE is already
  well-understood; the bottleneck is API-bridge construction not
  mathematical insight. Documented as a deliberate skip per the
  prover-mode workflow §4.4.
- Full 6.B iso requires the cotangent ↔ Kähler bridge over a field, a
  Mathlib gap separate from (and independent of) 6.A. Estimated
  ~100--200 LOC for the closed-point case; out of helper budget = 2 this
  iter. Iter-200+ `mathlib-analogist` sweep tracked.

**Approaches written but not attempted**: NONE. Every approach
documented in inline comments was attempted to the extent the helper
budget permitted; no leftover "TODO try this" notes remain.

**Infrastructure already exists, partially**: `Module.finrank_baseChange`
(Mathlib `LinearAlgebra/Dimension/Constructions.lean`) supplied the
substrate for the 6.B RHS. `SubmersivePresentation.\linebreak
isStandardSmoothOfRelativeDimension` (Mathlib
`RingTheory/Smooth/StandardSmooth.lean`) supplied the substrate for
sub-gap (i). These were the iter-198 keys.

## Blueprint marker recommendation for review agent

- `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacyLocus}` —
  statement + proof axiom-clean since iter-177. Keep `\leanok` on both.
- `\lean{AlgebraicGeometry.Scheme.RationalMap.CodimOneFree}` —
  statement + proof axiom-clean. Keep `\leanok` on both.
- `\lean{AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one}` — body
  still calls `isRegularLocalRing_stalk_of_smooth` (sorry on Stage 6);
  no `\leanok` for the proof block. Statement block can carry `\leanok`.
- `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_of_codimOneFree_of_smooth}` —
  body is `sorry` (no change this iter). No `\leanok` on proof.
- `\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme}` —
  body is `sorry` (no change this iter). No `\leanok` on proof.
- `\lean{AlgebraicGeometry.Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point}` —
  body axiom-clean. Keep `\leanok` on both blocks.
- **New** blueprint declarations to consider pinning iter-199+:
  - `\lean{Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension}`
    (sub-lemma 6.A): NOT pinned yet, still gated. Blueprint
    declaration in chapter `subsec:stage6_subgap_decomposition` is the
    statement; no formalised target yet.
  - `\lean{Algebra.KaehlerDifferential.cotangent_iso_residue_tensor_kaehler}`
    (sub-lemma 6.B): NOT pinned yet, still gated. Blueprint
    declaration in same subsection.
  - `\lean{AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth_aux}`
    (sub-lemma 6.C): NOT pinned yet, gated on 6.A + 6.B. Blueprint
    declaration in same subsection.

The 3 new private substrate helpers added this iter are unpinned in the
blueprint (no `\lean{...}` annotation needed) since they are
project-internal stepping stones, not blueprint-canonical declarations.
