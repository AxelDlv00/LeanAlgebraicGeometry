# Blueprint Writer Report

## Slug
lofft-blocks

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Changes Made

### A. `[LocallyOfFiniteType (X ⊗ Y).hom]` stated across the chain; "[IsAlgClosed] only" retired
- **Revised header `% NOTE` block** (proof of `thm:rigidity_lemma`) — collapsed the iter-159/160
  notes and added an iter-161 note recording (i) the route-B decomposition of bridge 2 into the
  two named sub-lemmas (Step 2 proven, Step 1 residual), and (ii) the plan-authorized signature
  change adding `[LocallyOfFiniteType (X ⊗ Y).hom]` to the FIVE chain lemmas in addition to
  `[IsAlgClosed kbar]`, with the one-sentence WHY (Step 2 needs dense closed points = Jacobson, free
  over finite-type k̄). Retired the "[IsAlgClosed] is the only added instance" claim.
- **Revised `rmk:rigidity_lemma_decomposition`** — "Status (iter-161)": now states bridge 2 is
  decomposed (Step 2 = `morphism_eq_of_eqAt_closedPoints` proven; Step 1 =
  `rigidity_eqAt_closedPoint_of_proper_into_affine` the lone deep residual), and that BOTH
  `[IsAlgClosed k̄]` and `[LocallyOfFiniteType (X⊗Y).hom]` are carried across the five chain lemmas
  (named explicitly). Removed the stale "adds [IsAlgClosed] to all three chain lemmas" line.
- **Revised the `lem:rigidity_eqOn_dense_open` formalization note** — retitled to "algebraically
  closed base, and locally-of-finite-type source"; explains both instances and WHY the finite-type
  one yields Jacobson density; lists the propagation targets (now including both bridge sub-lemmas).
- **Revised the bridge-2 note inside the `dense_open` proof** — updated to say the dense-closed-points
  density is supplied by the new `[LocallyOfFiniteType]` hypothesis, that the hom-extensionality
  connective is now BUILT as `morphism_eq_of_eqAt_closedPoints`, and that Step 1 is the chain's
  single deep residual.
- **Revised the `lem:rigidity_eqOn_saturated_open_to_affine` statement** — added "locally of finite
  type over k̄" to the hypotheses on `X × Y`, with the parenthetical that this makes `U` a Jacobson
  space (the hypothesis Step 2 consumes).
- **Replaced the stale `% NOTE (iter-160 review)` signature-gap comment** on that lemma with an
  iter-161 note marking the gap RESOLVED (hypothesis added, `JacobsonSpace U` now a routine
  discharge).

### B. Two new `\lean{}`-tagged sub-lemma blocks
- **Added lemma** `\label{lem:morphism_eq_of_eqAt_closedPoints}` /
  `\lean{AlgebraicGeometry.morphism_eq_of_eqAt_closedPoints}` — Step 2, PROVEN. Project-bespoke
  (no SOURCE lines). Statement: W reduced + Jacobson, Z separated; `g₁,g₂ : W ⟶ Z` agreeing along
  the residue-field point at every closed point are equal. Proof sketch: coproduct
  `∐ Spec κ(x) → W` is dominant (range = closed points, dense by `closure_closedPoints`);
  componentwise agreement via `Sigma.ι_desc`/`Sigma.hom_ext`; `ext_of_isDominant` cancels. Mirrors
  the Lean proof body exactly.
- **Added lemma** `\label{lem:rigidity_eqAt_closedPoint_of_proper_into_affine}` /
  `\lean{AlgebraicGeometry.rigidity_eqAt_closedPoint_of_proper_into_affine}` — Step 1, residual
  (`sorry`). Reused the existing Mumford verbatim `% SOURCE QUOTE PROOF` already in the chapter
  (Ch. II §4, p. 43; PDF page 54). Statement: with the saturated-open data, fix a closed point `x`
  of `U`; `f` and `retract ≫ f` agree at `x` after the residue-field probe. Proof sketch: the
  closed slice `X_y ≅ X` (κ(y)=k̄) maps into the affine `U₀`; `Γ(X_y)=k̄` via
  `isField_of_universallyClosed` + `finite_appTop_of_universallyClosed` + alg-closedness;
  `ext_of_isAffine` pins it to the single point `f(x₀,y) = (retract ≫ f)(x)`. Notes the
  Stein/`f_*𝒪=𝒪` framing is the avoided gap.

### C. Forward `\uses` edges
- Added `\uses{lem:morphism_eq_of_eqAt_closedPoints, lem:rigidity_eqAt_closedPoint_of_proper_into_affine}`
  to the proof of `lem:rigidity_eqOn_saturated_open_to_affine`. The two new lemmas are leaves
  (no backward `\uses` from them up to `saturated_open`/`dense_open`). Existing forward chain edges
  (`thm:rigidity_lemma` → `dense_open` → `saturated_open`) left intact.

### D. "Lone residual sorry" prose refreshed
- All places that previously named `rigidity_eqOn_saturated_open_to_affine` as "the lone residual
  sorry of the whole chain" now state: Step 2 (`morphism_eq_of_eqAt_closedPoints`) is proven; the
  body of `saturated_open` is real assembly; the chain's single genuinely-deep residual is Step 1
  (`rigidity_eqAt_closedPoint_of_proper_into_affine`). Updated in the header NOTE, the decomposition
  remark, the dense_open proof note, and both Step-1 paragraphs.

## Cross-references introduced
- `\uses{lem:morphism_eq_of_eqAt_closedPoints}` — target defined in this chapter (line 431). OK.
- `\uses{lem:rigidity_eqAt_closedPoint_of_proper_into_affine}` — target defined in this chapter
  (line 469). OK.
- Multiple `\cref{...}` to both new labels in revised prose — all resolve within this chapter.

## References consulted
- `references/mumford-abelian-varieties.pdf` (cited; PDF page 54 / book p. 43) — the verbatim
  Mumford Rigidity-Lemma proof quote, REUSED from the existing chapter blocks for
  `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` (the "for each y ∈ V, the complete slice
  maps into the affine, hence to a single point" step). No new verbatim text was needed; no
  reference-retriever dispatched.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` (read, not a reference file) — to verify the exact
  Lean signatures of `morphism_eq_of_eqAt_closedPoints` (W reduced/Jacobson, Z separated; via
  `fromSpecResidueField` + `Sigma.desc` + `ext_of_isDominant`) and
  `rigidity_eqAt_closedPoint_of_proper_into_affine` (carries `[LocallyOfFiniteType (X ⊗ Y).hom]`,
  closed-point residue-field-probe equation), and to confirm `[LocallyOfFiniteType]` is now on all
  five chain lemmas.

## Macros needed (if any)
- None new. `\fatsemi` (already locally `\providecommand`'d at the chapter top) is reused.

## Reference-retriever dispatches (if any)
- None. The existing Mumford quote covers the slice step; per directive, no re-fetch.

## Notes for Plan Agent
- The `morphism_eq_of_eqAt_closedPoints` block omits SOURCE lines (project-bespoke, per directive).
  Its statement requires `[IsReduced W]` in Lean; the prose says "W reduced" — consistent.
- `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` statement says "geometrically irreducible,
  reduced, and locally of finite type" matching the Lean instance list
  (`GeometricallyIrreducible`, `IsReduced (X ⊗ Y).left`, `LocallyOfFiniteType (X ⊗ Y).hom`); the
  visible prose abbreviates "(X ⊗ Y) locally of finite type" as "X × Y ... locally of finite type".
- The `JacobsonSpace U` instance in the Lean body of `rigidity_eqOn_saturated_open_to_affine` is
  still an in-body `sorry` (a routine 3-lemma discharge per the Lean comment), distinct from the
  deep Step-1 `sorry`. The blueprint treats it as a routine instance discharge, not a deep residual,
  consistent with the Lean note. Worth a prover lane next iter to clear it.

## Strategy-modifying findings
None. The changes reflect a plan-authorized signature/decomposition already landed in the Lean; no
strategy-level contradiction surfaced.
