# Blueprint Writer Report

## Slug
scaling-primary

## Status
COMPLETE — the 𝔾_m-scaling shortcut is now the stated primary proof of the genus-0 base case;
the 𝔾_a-additive route (`lem:hom_from_Ga_trivial`, `lem:hom_Ga_to_av_trivial`) is demoted to a
retained off-critical-path alternative; σ_× is promoted to the primary first-class action.

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Changes Made
- **Rewrote the proof of `prop:morphism_P1_to_AV_constant`** (`\lean{morphism_P1_to_grpScheme_const}`)
  to be the 𝔾_m-scaling shortcut *directly* (one-shot constancy): normalise `f(0)=0_A`; form
  `h := σ_× ; f` total on `ℙ¹×𝔾_m`; apply Cor 1.5 (`lem:hom_additivity_over_product`) with `V=ℙ¹`
  proper, `W=𝔾_m`, base points `0,1`; the `W`-axis restriction collapses because `0` is a scaling
  fixed point, giving `f(λx)=f(x)`; specialise `x=1` ⟹ `f|_{𝔾_m}` constant; density + separatedness
  (`thm:GrpObj_eq_of_eqOnOpen`) ⟹ `f` constant. No `Hom(𝔾_a,A)=0`, no "image is a closed subgroup".
  - Updated **both** `\uses{}` (statement + proof) from `{lem:hom_from_Ga_trivial}` to
    `{lem:hom_additivity_over_product, def:gaTranslationP1, thm:GrpObj_eq_of_eqOnOpen}`.
- **Promoted σ_× to the primary first-class action in `def:gaTranslationP1`.** Reordered the block:
  the multiplicative scaling action σ_× (full chartwise spec, two fixed points `0,∞`) is now the
  lead/primary definition; the 𝔾_a-translation σ is retained as a clearly-labelled "demoted route
  only" companion. **Changed the block's `\lean{}` hint from `gaTranslationP1` to `gmScalingP1`**
  (the now-load-bearing target). Title updated to lead with the scaling action.
- **Demoted `lem:hom_Ga_to_av_trivial`** — added a bold "Off the genus-0 critical path (iter-164):
  superseded by the 𝔾_m-scaling shortcut; retained as the classical Milne Prop 3.9 argument" banner.
- **Demoted `lem:hom_from_Ga_trivial`** — added the same off-critical-path banner; rewrote its
  proof's scaling tail to point at `prop:morphism_P1_to_AV_constant` as the primary home.
- **Updated narrative blocks** to make the scaling shortcut primary: chapter intro paragraph,
  §I.3 section intro, `rmk:cube_not_needed`, `rmk:base_case_fourth_route` (restructured: scaling =
  primary route; 𝔾_a-additive = retained alternative), and the two `\section` headings for the
  genus-0 base objects / base case.
- `lem:rational_map_to_av_extends` left Route-A-only (unchanged, as the prior pass left it).

## Cross-references introduced
- `\uses{thm:GrpObj_eq_of_eqOnOpen}` (new) in `prop:morphism_P1_to_AV_constant` statement + proof —
  this label IS the real density/separatedness handle, in `chap:Rigidity`
  (`\lean{AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen}`, the `ext_of_isDominant_of_isSeparated'`
  wrapper `rigidity_core` uses). Verified present in `Rigidity.tex:12`.
- `\uses{lem:hom_additivity_over_product, def:gaTranslationP1}` (kept/added) — both present in this
  chapter.
- All demoted-lemma `\cref`s now appear only in off-path / "retained alternative" prose.

## Final genus-0 \uses chain (critical path)
```
thm:rigidity_genus0_curve_to_AV
  → prop:morphism_P1_to_AV_constant
      → lem:hom_additivity_over_product   (→ thm:rigidity_lemma, proven)
      → def:gaTranslationP1               (→ def:genus0_base_objects)   [σ_× = gmScalingP1]
      → thm:GrpObj_eq_of_eqOnOpen         (chap:Rigidity, proven)
  → prop:genusZero_curve_iso_P1           (→ def:genus)
```
`lem:hom_from_Ga_trivial` and `lem:hom_Ga_to_av_trivial` are **bypassed** (off-path). Forward-acyclic;
all labels resolve. begin/end balance 41/41; all environment counts paired.

## \lean{} names a prover must scaffold for the scaling route
- `AlgebraicGeometry.gmScalingP1` — **NEW primary target**, the σ_× scaling action
  `ℙ¹ × 𝔾_m → ℙ¹`, `(x,λ) ↦ λx` (now the `\lean{}` of `def:gaTranslationP1`). Does not yet exist in
  `AlgebraicJacobian/AbelianVarietyRigidity.lean`.
- `AlgebraicGeometry.ProjectiveLineBar`, `Ga`, `Gm` — the ℙ¹/𝔾_a/𝔾_m objects (`def:genus0_base_objects`),
  none yet in Lean.
- `AlgebraicGeometry.morphism_P1_to_grpScheme_const` — the **live constancy target** (EXISTS as a
  `sorry` scaffold at `AbelianVarietyRigidity.lean:919`); its proof should now follow the scaling
  shortcut, consuming `hom_additive_decomp_of_rigidity` (Cor 1.5, proven) + `gmScalingP1` +
  `ext_of_eqOnOpen` (proven). Needs the `gmScalingP1` fixed-point fact `σ_×(0,λ)=0`.
- Off-path (only if the alternative route is pursued): `gaTranslationP1`, `morphism_Ga_to_av_const`
  (`lem:hom_from_Ga_trivial`), `hom_Ga_to_av_trivial`. None exist in Lean; no longer required for the
  genus-0 close.

## References consulted
- None opened this session. No new `% SOURCE`/`% SOURCE QUOTE` lines were written: this was a
  restructuring of math already in-tree. Existing verbatim Milne/Mumford/Hartshorne quotes were left
  untouched. (The scaling argument is the project's own realisation of Milne Prop 3.9; the existing
  Prop 3.9 verbatim quote on the demoted lemmas remains the underlying citation. Host still lacks a
  PDF renderer, per the in-tree iter-164 note — no quotes re-rendered.)

## Notes for Plan Agent
- **`\lean{}` hint redirect on `def:gaTranslationP1`** (gaTranslationP1 → gmScalingP1): justified
  because (i) σ_× is now the load-bearing primary action per the directive, (ii) neither name exists
  in Lean yet (both scaffold targets — verified by grep), so no existing declaration is renamed. If
  the plan agent prefers σ and σ_× to live in *separate* definition blocks (each with its own
  `\lean{}` and label), that is a cleaner long-term structure but conflicts with directive item 1's
  instruction to keep `prop:...` `\uses{def:gaTranslationP1}`; flagging for a possible future split.
- **Stale Lean docstring (out of my write-domain):** `morphism_P1_to_grpScheme_const`'s docstring
  (`AbelianVarietyRigidity.lean:910–912`) still says the single-curve base case "rests on the theorem
  of the cube … deferred deep input." This now contradicts the blueprint (cube excised iter-163;
  scaling shortcut needs only the proven Cor 1.5 + density). The prover/plan should refresh that
  docstring when the body is filled.
- The "single genuinely-deep residual sorry" wording in the Rigidity-Lemma helper blocks remains
  stale per the iter-162 review NOTE (chain closed iter-162) — unchanged by me (out of this
  directive's scope), still worth a cleanup pass.

## Strategy-modifying findings
None. The directive's strategy decision (scaling shortcut as primary) is fully consistent with the
math already in the chapter; installing it as the primary proof surfaced no new obstruction. The
scaling argument's two Cor 1.5 base-point conditions both hold (`f_0(0)=h(0,1)=0_A`, `g(1)=0_A`, and
`g≡0_A` by the fixed point), so the one-shot close is sound as written.
