# Blueprint Review Report

## Slug
iter137

## Iteration
137

## Top-level summaries

### Incomplete parts
*(none — every chapter has its strategy-mandated declarations stated and proofs sketched. `\notready` blocks correspond to deliberately deferred Lean bodies that the prose still pins precisely.)*

### Proofs lacking detail
- `Jacobian.tex` / C.2.d second bullet ("Via the cotangent bundle", L342–L347): condensed sketch; does not mention the `Differential.ContainConstants` step that converts `df = 0` to "factors through `Spec k`", nor the characteristic-$p$ Frobenius-iteration handling. Carry-over informational item from iter-136 reviewer — the *actual* formalised argument lives in `RigidityKbar.tex` §"shared pile" pieces (ii) + (iii), which spell both out explicitly. As a sketch in the rationale chapter this is acceptable; flagged informational, not must-fix.

### Lean difficulty quality
*(none — every `\lean{...}` hint on an active prover route names a target whose intended signature is pinned in the blueprint stub or in the `% NOTE iter-135/136` comment block, and the prover-lane target `relativeDifferentialsPresheaf_basechange_along_proj_two` is one such case.)*

### Multi-route coverage
The strategy splits along two axes:
- **Witness existence (M2 vs M3):** `\thm{thm:nonempty_jacobianWitness}` case-splits genus 0 (`\def{def:genusZeroWitness}`, M2.a → `\thm{thm:rigidity_over_kbar}` → shared pile) and positive genus (`\def{def:positiveGenusWitness}`, M3 → Route A or Route B). PASS — both arms are present, with `\notready` markers reflecting M3 off-critical-path status.
- **Genus-0 rigidity attack (cotangent vs Mumford vs Witt):** RigidityKbar.tex §`sec:RigidityKbar_shared_pile` (iii) names all three options and pins Option A (Frobenius iteration). PASS — the chosen route has explicit blueprint coverage (pieces (i), (ii), (iii)) and the two unchosen options are surveyed in one paragraph each.
- **Piece (i.b) RHS encoding (sheaf-level vs `ModuleCat k`-level):** the iter-133 mathlib-analogist Decision 4 is documented in both `RigidityKbar.tex` (`\lem{lem:GrpObj_mulRight_globalises}` stub + L420 envelope) and `AlgebraicJacobian_Cotangent_GrpObj.tex` (pointer-chapter bullet). PASS.
- **φ-compatibility morphism (`pullbackPushforwardAdjunction` vs `toRingCatSheafHom`):** `AlgebraicJacobian_Cotangent_GrpObj.tex` L34–L42 documents the split for `schemeHomRingCompatibility` (project-internal, `pullbackPushforwardAdjunction`) vs `(Scheme.Hom.toRingCatSheafHom _).hom` (iter-137 prover-lane route). PASS — directive flagged this as an optional preventive MED-C; the distinction is in fact already in the pointer chapter, not just the iter-136 inline NOTE block. See "Cross-chapter notes" for whether to also drop a one-line `% NOTE` at `RigidityKbar.tex:490`.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All three Layer-II results (`\def{def:ofCurve}`, `\lem{lem:comp_ofCurve}`, `\thm{thm:exists_unique_ofCurve_comp}`) are present, marked `\leanok`, and each closes by projection from the Albanese witness — exactly what the rigidity-driven Layer-I bundle supplies.
  - Classical Pic-scheme remarks document the not-taken route without polluting the Lean obligation.
  - `\uses{...}` cross-refs (`def:Jacobian`, `def:IsAlbanese`, `thm:nonempty_jacobianWitness`, `lem:comp_ofCurve`, `thm:rigidity_over_kbar`) all resolve.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pointer chapter for `AlgebraicJacobian/Cotangent/GrpObj.lean`; bullets enumerate the six declarations in the file with cross-refs to their authoritative blueprint statements in `RigidityKbar.tex` (`\lem{lem:GrpObj_cotangentSpace}`, `\lem{lem:GrpObj_cotangentSpace_extendScalars_witness}`, `\lem{lem:GrpObj_lieAlgebra_finrank}`, `\lem{lem:GrpObj_shearMulRight}`, `\lem{lem:GrpObj_omega_basechange_proj}`, `\lem{lem:GrpObj_omega_restrict_to_identity_section}`, `\lem{lem:GrpObj_mulRight_globalises}`).
  - **Iter-137 prover target** `relativeDifferentialsPresheaf_basechange_along_proj_two` (L43–L46) is correctly cross-referenced to `\lem{lem:GrpObj_omega_basechange_proj}` with the NEEDS_MATHLIB_GAP_FILL flag and ~150–300 LOC budget.
  - L34–L42 already documents the `schemeHomRingCompatibility` vs `(Scheme.Hom.toRingCatSheafHom _).hom` φ-compatibility split — iter-136 reviewer's optional preventive MED-C is materially addressed here, though only in the pointer chapter (see RigidityKbar entry).

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 947 lines, no `\notready` blocks, every declaration `\leanok`. Builds the Mayer–Vietoris LES, restriction/biproduct maps, short exact sequence of free sheaves, connecting map, sequence exactness, affine-cover MV-square specialisation, cover-totality identifications, and Čech-acyclicity carriers.
  - Label scheme is consistent (`def:` / `lem:` / `thm:` correctly applied).
  - Build-out completion remark at L419 documents the full landed pipeline.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single theorem `\thm{thm:HasSheafCompose_forget}` with adequate proof (two limit-preserving forgetful functors compose to a limit-preserving functor; the sheaf condition transports). `\lean{}` hint resolves.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three results — sheafification, Ext, and structure-sheaf-as-AbSheaf — each with a one-paragraph proof citing the right Mathlib pieces. `\uses{}` chain is `thm:HasSheafify_Opens_AddCommGrp` ← `thm:HasExt_Sheaf_Opens_AddCommGrp` and `thm:HasSheafCompose_forget` ← `def:Scheme_toAbSheaf`; both resolve.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 655 lines covering Phase A step 5 in full (sheafification, Ext, structure-sheaf-as-$k$-module, $H^0$ bridge, Čech carriers, affine-vanishing carriers, Stein finiteness, producer for wholespace Hom-finiteness).
  - **Carry-over label-prefix asymmetry** (informational, iter-135 + iter-136): L358 (`\label{thm:Scheme_IsAffineHModuleVanishing}` on `\begin{definition}`), L386 (`\label{thm:Scheme_IsAffineHModuleHomFinite}` on `\begin{definition}`), L440 (`\label{thm:Scheme_IsHModuleHomFinite}` on `\begin{definition}`) — three predicate definitions carry `thm:` label prefixes. No broken `\uses{...}` (the dependents at L367, L394, L449 cite the same `thm:` slugs, so the graph is consistent end-to-end); cosmetic. Iter-136 reviewer kept as-is per smaller-blast-radius option (b); **iter-137 verdict: keep informational** — no new evidence of downstream confusion or active-prover-route blast radius from iter-136 review.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\def{def:relative_kaehler_presheaf}` and `\lem{lem:relative_kaehler_presheaf_obj}` are the substrate that piece (i.b) Step 2 chains onto via `KaehlerDifferential.tensorKaehlerEquiv` (which `\lem{lem:GrpObj_omega_basechange_proj}` cites verbatim) — load-bearing for the iter-137 prover lane.
  - Forward smoothness criterion `\thm{thm:smooth_locally_free_omega}` (the existential consumed by `\lem{lem:GrpObj_lieAlgebra_finrank}`) and the post-iter-126 standalone K\"ahler-localisation utilities are documented; converse-out-of-scope rationale and counterexample are explicit.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\def{def:genus}` and Phase A mathlib-gap inventory (Serre finiteness, Čech path) are stated. `\uses{def:Scheme_HModule, def:Scheme_toModuleKSheaf}` cross-refs resolve into `Cohomology_StructureSheafModuleK.tex`.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **Carry-over stale citation (iter-135 MED-B, iter-136 informational; iter-137 verdict: keep informational)**: L400 cites `AlgebraicJacobian/Jacobian.lean:120}--\texttt{126` for `geometricallyIrreducible_id_Spec`; the declaration is actually at lines 134–140 (verified). The decl exists and is correctly named; only the line-range citation in prose is stale. No `\uses{}` graph impact, no downstream Lean prover blast radius. **No iter-137 evidence of new blast radius from `\leanok` marker churn** in iter-136 review.
  - **Iter-136 informational carry-over**: C.2.d second-bullet thinness (L342–L347) — discussed above under "Proofs lacking detail". Sketch is acceptable because the formalised argument is in `RigidityKbar.tex` §"shared pile" pieces (ii) + (iii). No promotion.
  - Definitions, theorems, and the iter-135 case-split body restructure (L376–L377) of `\thm{thm:nonempty_jacobianWitness}` are all coherent; `\def{def:genusZeroWitness}` and `\def{def:positiveGenusWitness}` package the two arms cleanly with explicit `\notready` markers on Lean bodies.
  - **`correct: partial`** is solely on account of the stale line-range citation; promoting to `correct: true` would be appropriate after a one-character fix.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Scheme-level rigidity theorem `\thm{thm:GrpObj_eq_of_eqOnOpen}` with full proof sketch citing the four Mathlib closure pieces. iter-125 refactor history (dropping group-object hypothesis, weakening to `IsSeparated`) is documented.
  - This is the rigidity lemma consumed by `\thm{thm:rigidity_over_kbar}` C.2.b and by `\thm{thm:exists_unique_ofCurve_comp}`.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **HARD GATE TARGET — `\lem{lem:GrpObj_omega_basechange_proj}` (L423–L481):** statement is precisely $\Omega_{(G\times_k G)/G} \cong \pr_2^*\Omega_{G/k}$, with proof sketch chaining `KaehlerDifferential.tensorKaehlerEquiv` (chart-level `B \otimes_{B_2} \Omega_{B_2/k} \xrightarrow{\sim} \Omega_{B/B_1}` for an `Algebra.IsPushout` square), `TopCat.Presheaf.pullback`, `PresheafOfModules.pullback`, plus the project-side `relativeDifferentialsPresheaf_obj_kaehler`. The Mathlib-name pile is enumerated in the closing "Mathlib name summary" paragraph (L480). **Verdict: adequate for the ~150–300 LOC prover lane.** Naturality and chart-by-chart-promotion are flagged but not spelled out at chart-cofinality level — that's appropriate for a NEEDS_MATHLIB_GAP_FILL piece where the prover is expected to invent the cofinal-system gluing as part of the contribution.
  - **`\notready` + iter-135 NOTE block (L452–L463)** accurately frames the iter-137 prover lane: sheaf-level RHS via `(Scheme.Hom.toRingCatSheafHom (snd G G).left).hom`, body shipped as honest sorry, `sync_leanok` removed the prior iter-134 `\leanok` from the proof block, body closure is iter-136+ work. Verified against the Lean file at `AlgebraicJacobian/Cotangent/GrpObj.lean:480`: signature shape matches verbatim.
  - **Optional preventive MED-C from iter-136 review (one-line `% NOTE` near L490 distinguishing `schemeHomRingCompatibility` vs `(Scheme.Hom.toRingCatSheafHom _).hom`):** the L505–L518 iter-136 NOTE block inside `\lem{lem:GrpObj_omega_restrict_to_identity_section}` already documents the `toRingCatSheafHom` route for the four compatibility morphisms; the pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex:34–42` explicitly contrasts `schemeHomRingCompatibility` with the `PresheafOfModules.pullback`-route. The cross-cutting distinction is therefore covered in two places already. Adding the proposed one-line `% NOTE` near L490 would be a localised redundancy with positive ergonomic value, **informational only** — does not block the iter-137 prover dispatch.
  - Pieces (i.a), (i.a-bridge `\notready`), (i.b-helper shear), (i.b main `\notready`), (i.b-helper proj-2 `\notready`), (i.b-helper section), (i.c free `\notready`), (i.c rank `\notready`) cleanly staged; iter-127 over-k commitment threaded uniformly.
  - Section "Iter-131 `Classical.choose`-chain body shape" + companion structural-shape lemma + downstream rewrite-pattern guidance is unusually thorough and helps the bridge from blueprint to existing closed iter-128/131/132 bodies.

## Cross-chapter notes

- The `(Scheme.Hom.toRingCatSheafHom _).hom` vs `pullbackPushforwardAdjunction` distinction surfaces in three places: the pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex:34–42` (explicit contrast), the iter-135 NOTE inside `RigidityKbar.tex:452–463` on `\lem{lem:GrpObj_omega_basechange_proj}`, and the iter-136 NOTE inside `RigidityKbar.tex:505–518` on `\lem{lem:GrpObj_omega_restrict_to_identity_section}`. These three references are mutually consistent. Iter-136 reviewer's proposal of an additional one-line `% NOTE` near `RigidityKbar.tex:490` (between `\lem{lem:GrpObj_omega_basechange_proj}`'s body close and `\lem{lem:GrpObj_omega_restrict_to_identity_section}`'s statement) is reasonable as a one-glance reminder for the iter-137 prover lane, but not gate-blocking; existing coverage is adequate.
- `\thm{thm:rigidity_over_kbar}`'s downstream consumer chain (`\def{def:genusZeroWitness}` → `\thm{thm:nonempty_jacobianWitness}` → `\def{def:Jacobian}` → AbelJacobi protected interface) is intact; no `\uses{}` link is broken by iter-136 marker churn.
- The protected blueprint declarations referenced in `Cohomology_*.tex` chapters are all `\leanok` (Phase A step 5 landed), and `\def{def:genus}` correctly consumes `def:Scheme_HModule` + `def:Scheme_toModuleKSheaf`.

## Strategy-modifying findings

*(none — no chapter contains a definition that conflicts with the strategy in a way requiring `STRATEGY.md` modification.)*

## Severity summary

- **must-fix-this-iter**: *(none)*. Per the gate rule:
  - No "Strategy-modifying findings".
  - No route under "Multi-route coverage" is MISSING.
  - **Both HARD GATE chapters** (`RigidityKbar.tex` and `AlgebraicJacobian_Cotangent_GrpObj.tex`) have `complete: true` AND `correct: true`, with no must-fix finding naming either.
  - `Jacobian.tex` `correct: partial` is on a non-load-bearing prose citation (`Jacobian.lean:120–126` vs actual `134–140`) that does not touch any active prover route this iter and corresponds to a 2-character fix. Per iter-136 reviewer it was kept informational; iter-137 has no new evidence to promote.
  - No `\lean{...}` hint on an active prover route is poor-quality (the iter-137 prover-lane target's signature stub in the blueprint matches the Lean file exactly).
  - No broken `\uses{...}` cross-references.

- **soon**:
  - Optional preventive `% NOTE iter-137:` near `RigidityKbar.tex:490` distinguishing `schemeHomRingCompatibility` (`pullbackPushforwardAdjunction`) vs `(Scheme.Hom.toRingCatSheafHom _).hom` for the iter-137 prover lane working between `\lem{lem:GrpObj_omega_basechange_proj}` and `\lem{lem:GrpObj_omega_restrict_to_identity_section}`. Already covered in two adjacent NOTEs and the pointer chapter; adding a third would be ergonomic, not load-bearing.

- **informational**:
  - `Jacobian.tex:400` stale citation (iter-135/136 carry-over; 2-character fix when convenient).
  - `Cohomology_StructureSheafModuleK.tex` L358/L386/L440 label-prefix asymmetry (`thm:` on `definition` envs; cosmetic; no graph impact). Iter-136 reviewer kept under option (b) smaller-blast-radius; iter-137 confirms.
  - `Jacobian.tex` C.2.d second-bullet prose thinness on "via the cotangent bundle" (does not surface piece (ii)'s `Differential.ContainConstants` or piece (iii)'s Frobenius iteration). The formalised argument is in `RigidityKbar.tex` pieces (i)+(ii)+(iii); the sketch in `Jacobian.tex` is acceptable as motivation.

## HARD GATE verdict

**HARD GATE CLEAR** for `AlgebraicJacobian/Cotangent/GrpObj.lean` (iter-137 prover lane target `relativeDifferentialsPresheaf_basechange_along_proj_two` at L480).

- Math chapter `RigidityKbar.tex`: `complete: true`, `correct: true`. The `\lem{lem:GrpObj_omega_basechange_proj}` block (L423–L481) supplies an adequate proof sketch with named Mathlib lemmas (`KaehlerDifferential.tensorKaehlerEquiv`, `TopCat.Presheaf.pullback`, `PresheafOfModules.pullback`, `Algebra.IsPushout`) sufficient for the ~150–300 LOC NEEDS_MATHLIB_GAP_FILL.
- Pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex`: `complete: true`, `correct: true`.
- No must-fix-this-iter finding names either chapter.

Overall verdict: HARD GATE CLEAR — 11 chapters audited, 0 must-fix, 1 soon (optional preventive MED-C), 3 informational (all iter-136 carry-overs unchanged); the iter-137 prover lane on `Cotangent/GrpObj.lean` may fire.
