# Lean ↔ Blueprint Check Report

## Slug
avr-iter162

## Iteration
162

## Files audited
- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Headline

The directive's two explicit concerns both come back **clean**:

1. **`isIntegral_of_retract` `\lean{}` hint** — RESOLVED. The node
   `lem:isIntegral_of_retract_of_integral` now carries
   `\lean{AlgebraicGeometry.isIntegral_of_retract}` (tex line 520) and it matches the actual
   declaration (`AlgebraicGeometry.isIntegral_of_retract`, lean line 200). Not blank.
2. **Chain sorry-free + axiom-clean** — VERIFIED via `lean_verify`. `rigidity_lemma`,
   `isIntegral_of_retract`, and `rigidity_eqAt_closedPoint_of_proper_into_affine` each report
   axioms `{propext, Classical.choice, Quot.sound}` only — **no `sorryAx`**. So the chain
   `\leanok` markers are legitimate; there is **no laundering of the now-closed chain**.

The remaining findings are (a) stale "residual sorry" prose in both the Lean docstrings and the
blueprint (the chain closed but the narrative wasn't refreshed), and (b) a pre-existing,
sync-owned proof-`\leanok` laundering on the three *downstream* scaffold nodes (cube / RR /
headline), which are honestly `:= sorry` in Lean.

> Note on line numbers: the paginated `Read` views were offset from true file lines; **Grep line
> numbers (used throughout this report) are authoritative**. I re-read the disputed region to
> confirm.

## Per-declaration

### `\lean{AlgebraicGeometry.rigidity_lemma}` (thm:rigidity_lemma)
- **Lean target exists**: yes (lean 760).
- **Signature matches**: yes. Conclusion `∃ g : Y ⟶ Z, f = snd X Y ≫ g` = prose "there is
  `g : Y → Z` with `f = g ∘ p₂`" (diagrammatic order). Instances `[IsAlgClosed]`, `[IsProper
  X.hom]`, `[GeometricallyIrreducible (X⊗Y).hom]`, `[LocallyOfFiniteType (X⊗Y).hom]`, `[IsReduced
  (X⊗Y).left]`, `[IsSeparated Z.hom]` + collapse hyp `_hf` all match the chapter prose & the
  iter-161 signature-change note.
- **Proof follows sketch**: yes (witness `g(y)=f(x₀,y)`; `rigidity_snd_lift` reduction; then
  `rigidity_core`). Axiom-clean.

### `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}` (lem:rigidity_eqOn_dense_open)
- **Lean target exists**: yes (lean 502).
- **Signature matches**: yes — collapse hyp `_hf`, the saturated-open existential conclusion, and
  the full instance set match the prose (including the "collapse hypothesis is load-bearing"
  counterexample discussion).
- **Proof follows sketch**: yes (Mumford `U = X×V`, `G = p₂(f⁻¹(Z∖U₀))`, bridge-1 closed map,
  `hfib`/`_hf` ⟹ `y₀ ∉ G`, delegate slice-constancy to the saturated-open helper).

### `\lean{AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine}` (lem:rigidity_eqOn_saturated_open_to_affine)
- **Lean target exists**: yes (lean 426).
- **Signature matches**: yes. Saturated open (`_hUV : U = p₂⁻¹ Vset`), affine `U₀`, `f(U)⊆U₀`
  (`_hfU`), and both `[IsAlgClosed]` + `[LocallyOfFiniteType (X⊗Y).hom]` carried as the prose's
  Jacobson-density requirement spells out.
- **Proof follows sketch**: yes — body wires Step 2 (`morphism_eq_of_eqAt_closedPoints`) over
  Step 1 (`rigidity_eqAt_closedPoint_of_proper_into_affine`); `JacobsonSpace U` discharged via
  `LocallyOfFiniteType.jacobsonSpace` + `JacobsonSpace.of_isOpenEmbedding` exactly as the iter-161
  note describes.

### `\lean{AlgebraicGeometry.morphism_eq_of_eqAt_closedPoints}` (lem:morphism_eq_of_eqAt_closedPoints)
- **Lean target exists**: yes (lean 112).
- **Signature matches**: yes. `[IsReduced W] [JacobsonSpace W] [Z.IsSeparated]`, per-closed-point
  residue-field hypothesis ⟹ `g₁ = g₂`. Faithful to prose.
- **Proof follows sketch**: yes — coproduct probe `∐ Spec κ(x)`, `Sigma.desc`, density via
  `closure_closedPoints`, `ext_of_isDominant`. Axiom-clean.

### `\lean{AlgebraicGeometry.eq_comp_of_isAffine_of_properIntegral}` (lem:eq_comp_of_isAffine_of_properIntegral)
- **Lean target exists**: yes (lean 153).
- **Signature matches**: yes. `[IsAlgClosed] {W}[IsIntegral W] (wk)[UniversallyClosed][LocallyOfFiniteType]
  {V}[IsAffine V] (g) (a b sections) ⟹ a≫g = b≫g`. Matches prose verbatim, including the
  excellent "every hypothesis is load-bearing" counterexample remark.
- **Proof follows sketch**: yes (`isField_of_universallyClosed` → `finite_appTop…` →
  `IsAlgClosed.ringHom_bijective_of_isIntegral` → `ext_of_isAffine`). Axiom-clean.

### `\lean{AlgebraicGeometry.isIntegral_of_retract}` (lem:isIntegral_of_retract_of_integral) — THE iter-162 ADDITION
- **Lean target exists**: yes (lean 200).
- **Signature matches**: yes, and **the `\lean{}` hint is correct** (tex 520). Lean is stated
  *more generally* than the prose: `{S T}[IsIntegral T](r:S⟶T)(pr:T⟶S)(hrp:r≫pr=𝟙 S):IsIntegral S`,
  whereas the prose specializes to `X` as a retract of integral `X×Y` via the section of `p₁`. The
  general lemma subsumes the prose instance — not a mismatch. The chapter NOTE (tex 522–523) already
  documents the generality.
- **Proof follows sketch**: **partial — documented divergence (safe direction).** The Lean proves
  *reducedness per-stalk* (`pr.stalkMap` split-injective into the reduced `T`-stalk →
  `isReduced_of_isReduced_stalk`). The blueprint prose (tex 537–541) instead argues reducedness via
  the *global-sections* split injection `O_X(X) ↪ O_{X×Y}(X×Y)`. That global-sections argument is
  **mathematically insufficient** (reducedness is local: reduced global sections do not imply a
  reduced scheme), so a prover following only the prose would not have closed the lemma. The Lean
  did the correct (stalk) thing, and the chapter NOTE (tex 524–527) already flags this exact
  divergence and proposes aligning the prose. Axiom-clean. Classified **minor** below (Lean correct,
  divergence documented), but the prose half should be repaired so the chapter is not silently wrong.
- **`\leanok`**: not yet present on this node (tex 517/534). Since `\lean{}` is now wired and the
  decl is axiom-clean, the deterministic `sync_leanok` should add it (statement + proof). Absence is
  fine if sync runs after this checker; informational.

### `\lean{AlgebraicGeometry.rigidity_eqAt_closedPoint_of_proper_into_affine}` (lem:rigidity_eqAt_closedPoint_of_proper_into_affine) — body filled this iter
- **Lean target exists**: yes (lean 258).
- **Signature matches**: yes — full instance set + saturated-open data + closed point `x`,
  concluding the residue-field-probe equality. Matches the chapter statement (tex 553–569).
- **Proof follows sketch**: yes. The filled body realizes the prose route exactly:
  `pointOfClosedPoint` packages `x` as a `k̄`-point; the slice section `sec = (x↦(x,ŷ))` exhibits
  `X.left` as a retract (consumes `isIntegral_of_retract`); `eq_comp_of_isAffine_of_properIntegral`
  supplies the two-`k̄`-points-agree core; `IsOpenImmersion.lift` corestricts into the affine `U₀`.
  No relative Stein / `f_*𝒪=𝒪`. Axiom-clean.

### `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const}` (prop:morphism_P1_to_AV_constant)
- **Lean target exists**: yes (lean 795), body `:= sorry` (sorryAx-confirmed). Documented iter-157
  scaffold; `\uses{thm:rigidity_lemma, thm:theorem_of_the_cube}` (cube deferred). Statement faithful.
- **Proof follows sketch**: N/A (sorry). **But proof block carries `\leanok` (tex 660) — see Red flags.**

### `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` (prop:genusZero_curve_iso_P1)
- **Lean target exists**: yes (lean 819), body `:= sorry` (RR sub-build, documented). Statement faithful.
- **Proof follows sketch**: N/A (sorry). **Proof block carries `\leanok` (tex 736) — see Red flags.**

### `\lean{AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme}` (thm:rigidity_genus0_curve_to_AV)
- **Lean target exists**: yes (lean 844), body `:= sorry` (headline scaffold). Signature mirrors
  `rigidity_over_kbar` minus `[CharZero]`, as prose claims. Faithful.
- **Proof follows sketch**: N/A (sorry). **Proof block carries `\leanok` (tex 796) — see Red flags.**

## Red flags

### Marker laundering: proof-`\leanok` on `:= sorry` declarations (major)
Three downstream scaffold nodes carry **proof-block `\leanok`** while their Lean targets are
`:= sorry` (sorryAx confirmed for `morphism_P1_to_grpScheme_const`; the other two are `sorry` by
inspection at lean 828 / 857):

- `prop:morphism_P1_to_AV_constant` — proof `\leanok` at tex 660; Lean sorry (lean 804).
  Its proof `\uses{thm:theorem_of_the_cube}` (an explicitly **deferred, un-built** input), so this
  `\leanok` launders the theorem of the cube as proven in the dependency graph.
- `prop:genusZero_curve_iso_P1` — proof `\leanok` at tex 736; Lean sorry (lean 828).
- `thm:rigidity_genus0_curve_to_AV` — proof `\leanok` at tex 796; Lean sorry (lean 857).

Statement-level `\leanok` on these three is **correct** (declarations are formalized with full
signatures). Only the **proof-level** `\leanok` is wrong (proof block `\leanok` means "no sorry").
`\leanok` is owned by the deterministic `sync_leanok` phase, not by any writer — so the fix routes
through `sync_leanok` / review, not the blueprint-writer. If `sync_leanok` has not yet run for
iter-162 at the time of this check, it should strip these automatically; if it has run and they
survived, that is a `sync_leanok` defect worth surfacing. This is **not** the now-closed chain (which
is clean), but it is genuine marker-graph laundering of the deferred deep inputs, so flagged.

### Stale "residual sorry" prose now that the chain is closed (minor)
The chain is sorry-free + axiom-clean, but multiple narrative spots still describe Step 1 as the
"single genuinely-deep residual `sorry`", contradicting the `\leanok` markers now on those proofs:
- Blueprint: tex 176 (`rmk:rigidity_lemma_decomposition`), tex 338
  (`lem:rigidity_eqOn_dense_open` proof), tex 410 + 592
  (`…saturated…` / `…eqAt_closedPoint…` proofs).
- Lean docstrings: module docstring (lean 29), and decl docstrings at lean 255, 478, 485, 644, 670,
  757 ("the lone residual `sorry`" / "Status (iter-160): `sorry`").
Harmless to the build, but misleading to a reader. Blueprint prose is in the writer/review domain;
Lean docstrings are prover-owned. Recommend a narrative refresh ("Step 1 now proven; chain closed").

## Unreferenced declarations (informational)

Three substantive helpers have no `\lean{}` block (acceptable — each is described in chapter prose):
- `rigidity_snd_lift` (lean 71) — cartesian-monoidal collapse identity; described in
  `rmk:rigidity_lemma_decomposition` + `rigidity_lemma` docstring.
- `snd_left_isClosedMap` (lean 90) — bridge 1; described in the "Bridge 1 — BUILT" prose.
- `rigidity_core` (lean 674) — scheme-level gluing; named & described in
  `rmk:rigidity_lemma_decomposition`. This is the most substantive of the three; the blueprint
  collapses the `rigidity_lemma → rigidity_core → rigidity_eqOn_dense_open` Lean chain into a direct
  `thm:rigidity_lemma —uses→ lem:rigidity_eqOn_dense_open` edge, which is fine since `rigidity_core`
  has no node. Could optionally be promoted to its own block; not required.

## Blueprint adequacy for this file

- **Coverage**: 10/13 Lean declarations have a `\lean{...}` block. Unreferenced: 3 helpers
  (`rigidity_snd_lift`, `snd_left_isClosedMap`, `rigidity_core`), all adequately prose-described —
  0 substantive declarations unaccounted-for.
- **Proof-sketch depth**: **adequate**, with one defect. The chain nodes are sketched in enough
  detail to have guided the formalization (the iter-162 fill of
  `rigidity_eqAt_closedPoint_of_proper_into_affine` clearly tracks the chapter's Step-1 prose, and
  `eq_comp_of_isAffine_of_properIntegral` even ships load-bearing counterexamples). The one defect is
  the **reduced-half of `lem:isIntegral_of_retract_of_integral`'s proof** (global-sections argument,
  mathematically insufficient — reducedness is local); the Lean correctly uses stalks and the chapter
  NOTE already flags the divergence.
- **Hint precision**: **precise**. Every `\lean{}` resolves to the right declaration with a faithful
  signature; the iter-162 addition `\lean{AlgebraicGeometry.isIntegral_of_retract}` is correct.
- **Generality**: **matches need**. `isIntegral_of_retract` is stated more generally in Lean than the
  prose instance (a strict improvement, documented in-chapter); no parallel API was forced.
- **Recommended chapter-side actions** (for a blueprint-writing subagent):
  1. Align the reduced-half prose of `lem:isIntegral_of_retract_of_integral` (tex 537–541) to the
     per-stalk route the Lean actually uses (or note the global-sections argument is insufficient).
  2. Refresh the "single genuinely-deep residual `sorry`" prose (tex 176, 338, 410, 592) to "Step 1
     proven; Rigidity-Lemma chain closed & axiom-clean (iter-162)".
- **Recommended review/sync action** (not blueprint-writer):
  3. Confirm `sync_leanok` strips the three proof-`\leanok` markers on `:= sorry` nodes (tex 660,
     736, 796), and adds `\leanok` to the now-wired `lem:isIntegral_of_retract_of_integral`.

## Severity summary

- **must-fix-this-iter**: none on the iter-162 changed scope. The directive's `\lean{}` concern is
  resolved and the now-closed chain is verified sorry-free + axiom-clean (no laundering of the chain).
- **major**:
  - Proof-`\leanok` laundering on the three downstream scaffold nodes (`prop:morphism_P1_to_AV_constant`,
    `prop:genusZero_curve_iso_P1`, `thm:rigidity_genus0_curve_to_AV`) whose Lean bodies are `:= sorry`
    — claims the deferred cube/RR base cases as proven in the dep graph. `sync_leanok`-owned; route to
    review/sync.
- **minor**:
  - Documented reduced-half proof divergence in `lem:isIntegral_of_retract_of_integral` (prose
    global-sections argument insufficient; Lean uses stalks; already NOTE'd).
  - Stale "residual sorry" prose across blueprint proofs and Lean docstrings now that the chain is
    closed.
- **informational**: `rigidity_core` substantive helper without a `\lean{}` block (prose-described);
  `lem:isIntegral_of_retract_of_integral` not yet `\leanok` (expect sync to add).

**Overall verdict**: The Lean faithfully follows the blueprint on the iter-162 changes — the
`isIntegral_of_retract` `\lean{}` hint is correct and the whole Rigidity-Lemma chain is verified
sorry-free and axiom-clean — with the only blocking-adjacent issue being a pre-existing,
sync-owned proof-`\leanok` laundering on the *deferred downstream* scaffold nodes, plus cosmetic
stale-prose cleanup.
