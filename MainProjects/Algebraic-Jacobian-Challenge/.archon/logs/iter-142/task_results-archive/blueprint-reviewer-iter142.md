# Blueprint Review Report

## Slug
iter142

## Iteration
142

## Top-level summaries

### Incomplete parts

- None blocking for iter-142. The iter-141 Wave 3 +125 LOC expansion of `RigidityKbar.tex` landed all four planned updates (d_app `ModuleCat.Derivation.d_map` Implementation note; d_map named-lemma + `whnf`-disabled advisory + three-step chase; IsIso gap-items framing repair; iter-139 NOTE staleness annotation) and the iter-142 prover-lane target sub-pieces have prover-ready closure recipes.
- Downstream piece (i.c) `lem:GrpObj_omega_free` and `lem:GrpObj_omega_rank_eq_dim` remain `\notready` (their Lean targets `AlgebraicGeometry.GrpObj.omega_free` / `omega_rank_eq_dim` are not yet declared in `Cotangent/GrpObj.lean`). This is honest and on-schedule per the iter-129+ piece-(i) build order; not iter-142 work.

### Proofs lacking detail

- None. The three iter-142 sub-sorry closure recipes in `RigidityKbar.tex` § proof of `lem:GrpObj_omega_basechange_proj` are prover-ready:
  - d_app at `Cotangent/GrpObj.lean:624` — the iter-141 `ModuleCat.Derivation.d_map`-via-categorical-witness recipe (RigidityKbar.tex L672–L703) names the canonical Mathlib closer, gives the streamlined `lean_run_code`-validated four-line closure shape verbatim, and quotes the LOC envelope ($\sim$ 50–90 LOC).
  - d_map at `Cotangent/GrpObj.lean:643` — the iter-141 three-step ALIGN_WITH_MATHLIB chase (RigidityKbar.tex L767–L781) names `PresheafOfModules.pushforward_obj_map_apply'` + `NatTrans.naturality` for ψ + `relativeDifferentials'_map_d` with exact Mathlib file/line citations, plus a negative-lesson note (L784–L801) explicitly warning the prover off the d_add/d_mul-style `change`-first approach that deterministically times out under `pushforward₀`'s transparency annotation.
  - IsIso L689 inside `isIso_of_app_iso_module ... (fun _ => sorry)` — the iter-139 Route (b'2) sub-paragraph (RigidityKbar.tex L943–L1073) gives the four enumerated iter-141+ items in build order, with item 1 confirmed closed iter-140 and items 2–4 sized at $\sim$ 195–365 LOC bundled per `analogies/isiso-basechange-along-proj-two-inv.md`.

### Lean difficulty quality

- All active `\lean{...}` hints in `RigidityKbar.tex` for iter-142 targets are well-formed. Each carries an explicit Lean signature stub in a `%` comment with the noncomputable/theorem keyword, full binder list, and intended return type. Specifically: `basechange_along_proj_two_inv_derivation` (RigidityKbar.tex:1086–1098), `basechange_along_proj_two_inv` (RigidityKbar.tex:1171–1185), and `relativeDifferentialsPresheaf_basechange_along_proj_two` (RigidityKbar.tex:447–472) all show the full signature including the iter-135 `Scheme.Hom.toRingCatSheafHom` idiom for the compatibility morphisms — no signature ambiguity for the iter-142 prover lane.

### Multi-route coverage

- **Primary route (over-k cotangent vanishing pile on `Cotangent/GrpObj.lean`)**: PASS. Covered in `RigidityKbar.tex` § "Piece (i)" with sub-pieces (i.a) closed iter-128 → iter-132, (i.b) in-flight iter-134 → iter-142+ with Step 1 + Step 3 closed and Step 2 sub-sorries the iter-142 target, (i.c) staged iter-143+. The pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` cleanly redirects to the substantive content (its post-iter-139 2-bullet plan-agent update is reflected in the bullet list at lines 50–73).
- **Revert to over-`k̄` + M2.c restore** (trigger-gated, currently inactive): NOT covered. The chapter introduction explicitly documents this as documented-not-active per STRATEGY.md § Sequencing triggers (a')/(b)/(c). Since the route is trigger-gated and no trigger has fired, blueprint coverage is not required this iter. Informational only.
- **Chart-algebra-vs-bundled re-evaluation gate iter-144** (gate-pending, currently inactive): NOT covered. The gate is iter-144; no coverage required for iter-142. Informational only.
- **Fibre-free piece (i) reformulation** (trigger-gated, currently inactive): NOT covered. Trigger renormalised to 1000 LOC cumulative iter-138 and has not fired. Informational only.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three declarations (def:ofCurve, lem:comp_ofCurve, thm:exists_unique_ofCurve_comp) all carry `\leanok` and project from the Albanese witness via the extraction trio of `def:IsAlbanese_ofCurve` / `lem:IsAlbanese_comp_ofCurve` / `lem:IsAlbanese_exists_unique_ofCurve_comp`. Cross-references to `thm:rigidity_over_kbar` (genus-0 sub-case) and `thm:nonempty_jacobianWitness` (existence) are explicit. No findings.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Pointer-only chapter (82 LOC) for `Cotangent/GrpObj.lean`. Bullet list at lines 13–78 enumerates all ten Lean declarations in the file with statement label cross-references to `RigidityKbar.tex` § "Piece (i)". The iter-138 helpers `basechange_along_proj_two_inv_derivation` and `basechange_along_proj_two_inv` are explicitly listed (lines 50–69) with their iter-138 closure-status notes, and the iter-139 Route (b'2) verdict is cited at line 67–68. Pointer mechanics are clean; the chapter satisfies the per-Lean-file blueprint convention without duplicating mathematical content.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 947 LOC, 144 marker/label/uses occurrences, all `\leanok`'d throughout. Phase-A step-6 infrastructure (Mayer–Vietoris LES, two-affine cover bridges, Čech-acyclicity carrier, top-supremum transport) supports `Genus.tex` via the `\Module.\Finite\,k\,H^1(C, \mathcal O_C)` chain. Off the iter-142 critical path; no findings.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 40 LOC, one statement closed end-to-end. No findings.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 78 LOC; sheafification, $\Ext$, and structure-sheaf-as-Ab promotion all `\leanok`'d. No findings.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 655 LOC; covers Phase-A step-5 (k-module sheaf cohomology + structure-sheaf $k$-module promotion + Stein finiteness producer chain). All declarations `\leanok`'d. No findings.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 209 LOC; covers `def:relative_kaehler_presheaf` (line 14), `lem:relative_kaehler_presheaf_obj` (line 23), `thm:smooth_locally_free_omega` (line 50) — the three labels `RigidityKbar.tex` § "Piece (i)" depends on via `\uses{...}`. All formalized and `\leanok`'d. The post-iter-126 M1 excise + the M4 converse-out-of-scope framing are cleanly documented. Standalone K\"ahler-localization utilities (`lem:kaehler_localization_subsingleton`, `lem:kaehler_quotient_localization_iso`) survive as PR-candidate material.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 69 LOC; `def:genus` is fully formalized and `\leanok`'d. Off the iter-142 critical path. No findings.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 450 LOC; covers `def:JacobianWitness`, `thm:nonempty_jacobianWitness`, `def:genusZeroWitness`, `def:positiveGenusWitness` plus the four protected-instance projections. Iter-127 over-k commitment is properly threaded through C.2.f (DROPPED) / C.2.g (over-k inventory) and the proof body restructure to a `by_cases` delegating to `def:genusZeroWitness` / `def:positiveGenusWitness` is documented at line 376–377 (Iter-135 body restructure paragraph). Off the iter-142 critical path.
  - Informational: `def:genusZeroWitness` (line 389) and `def:positiveGenusWitness` (line 424) carry `\notready` while their Lean targets `AlgebraicGeometry.genusZeroWitness` / `AlgebraicGeometry.positiveGenusWitness` are formalized as sorry-bodied scaffolds in `Jacobian.lean`. Per CLAUDE.md § "Blueprint Marker Vocabulary" the two active markers are `\leanok` and `\mathlibok`; `\notready` is a legacy marker and on a formalized (sorry-bodied) statement is stale (parallels the iter-140 stripping of `\notready` from `mulRight_globalises_cotangent` etc. in `RigidityKbar.tex`). Not iter-142 work but a cleanup candidate for a future blueprint-writer pass.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 71 LOC; `thm:GrpObj_eq_of_eqOnOpen` (the iter-125 refactored scheme-level form `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen`) is closed end-to-end with `\leanok`. Consumed by `RigidityKbar.tex` C.2.b reduction and by uniqueness in `thm:exists_unique_ofCurve_comp`.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 1349 LOC, +125 LOC iter-141 Wave 3 expansion confirmed present:
    - d_app Implementation note `ModuleCat.Derivation.d_map` (vs `Derivation.map_algebraMap`) at lines 672–703 with verbatim 4-line Lean snippet validated standalone via `lean_run_code`.
    - d_map three-step ALIGN_WITH_MATHLIB chase at lines 767–781 with named-lemma `pushforward_obj_map_apply'` + `whnf`-disabled advisory at lines 747–765 + negative-lesson note (don't replay d_add/d_mul `change`-first) at lines 784–801.
    - IsIso L689 Route (b'2) sub-paragraph at lines 943–1073 with 4 enumerated build items (item 1 closed iter-140; items 2–4 iter-141+ targets, LOC envelopes pinned).
    - Iter-139 NOTE block (lines 499–523) on the `\leanok` mis-mark concern updated iter-141 with pattern-citation-only annotation (lines 514–523) acknowledging iter-140 line/pattern drift to `(fun _ => sorry)`.
  - iter-142 prover-lane target sub-pieces (d_app L624, d_map L643, IsIso L689 inside `isIso_of_app_iso_module ... (fun _ => sorry)`) all have prover-ready closure recipes. Lean target line citations match the on-disk file (`Cotangent/GrpObj.lean:573` for the helper definition, L624/L643/L689 for the three sub-sorries; verified via grep).
  - **Informational carry-over (iter-141 known)**: `\leanok` on the proof block of `lem:GrpObj_omega_basechange_proj` at line 524 while `Cotangent/GrpObj.lean` retains the iter-140-narrowed per-open `(fun _ => sorry)` at L689. The iter-139 NOTE block (lines 499–523) flags this as a sync_leanok mis-mark candidate; iter-141 update note (lines 514–523) records that the mis-mark concern persists until iter-142+ closes the per-open IsIso sub-sorry. Not blocking for iter-142 prover dispatch — the `\leanok` does not corrupt the blueprint, only mis-advertises status, and `sync_leanok` is autonomous so agents are not expected to edit it.
  - **Informational extension**: The same sync_leanok mis-mark concern extends to the proof block of `lem:GrpObj_omega_basechange_proj_inv_derivation` at line 1152 (`\leanok` is present while `Cotangent/GrpObj.lean:573`'s body has nested sorries at L624 / L643 inside `Derivation'.mk`). The iter-138 NOTE blocks in the surrounding proof prose (RigidityKbar.tex:564–593) document the d_add/d_mul closure vs d_app/d_map sub-sorry split honestly; only the proof-block `\leanok` marker may be mis-set. Same iter-142+ resolution path as the outer iso lemma; iter-141 NOTE block does not separately flag this inner case but it will resolve together with the outer one once the three sub-sorries close.
  - **Informational (other `\notready` items)**: `lem:GrpObj_cotangent_bridge` (line 183) carries `\notready` and is vestigial-on-live-path under Replacement (B) per the rank-lemma proof's footer paragraph (lines 269–280); no Lean body exists. `lem:GrpObj_omega_free` (line 1291) and `lem:GrpObj_omega_rank_eq_dim` (line 1304) carry `\notready` and their Lean targets are not yet declared. All three are downstream of iter-142 and on-schedule.

## Cross-chapter notes

- `Jacobian.tex` § C.2.f explicitly DROPS Galois descent of morphism equality per the iter-127 over-k commitment, and `RigidityKbar.tex` § "Iter-127 over-k commitment" paragraph at line 14 mirrors the same commitment with the same wording ("M2.c and its companion M2.c.aux are DROPPED"). Consistent.
- `RigidityKbar.tex`'s `\uses{thm:smooth_locally_free_omega}` (Differentials.tex), `\uses{def:relative_kaehler_presheaf}` (Differentials.tex), `\uses{lem:relative_kaehler_presheaf_obj}` (Differentials.tex), and `\uses{thm:GrpObj_eq_of_eqOnOpen}` (Rigidity.tex) all resolve to live labels. No broken cross-refs.
- `RigidityKbar.tex` § Step 2 of the bridge lemma `lem:GrpObj_cotangent_bridge` proof cites `lem:kaehler_localization_subsingleton` (Differentials.tex line 117); the citation is correct and the cited declaration is closed in Mathlib via `Algebra.FormallyUnramified.subsingleton_kaehlerDifferential`.

## Strategy-modifying findings (if any)

None. The iter-127 over-k commitment is uniformly threaded through all relevant chapters (`RigidityKbar.tex` intro, `Jacobian.tex` § C.2.f/C.2.g, `AbelJacobi.tex` § rem:ofCurve_classical and § "Implementation route"). No strategy revisit required.

## Severity summary

- **must-fix-this-iter**: none.
- **soon**:
  - The sync_leanok mis-mark concern at `RigidityKbar.tex:524` (proof block of `lem:GrpObj_omega_basechange_proj`) and its parallel at `RigidityKbar.tex:1152` (proof block of `lem:GrpObj_omega_basechange_proj_inv_derivation`) — `\leanok` is on a proof block whose Lean target has nested sorries inside `(fun _ => sorry)` / `Derivation'.mk`. Not blueprint-author work (per CLAUDE.md `\leanok` is sync_leanok's domain); the mis-mark resolves naturally once iter-142+ closes the three sub-sorries. Surfacing here so the plan agent can decide whether to escalate the `sync_leanok`-handles-nested-sorry concern to a `doctor`-skill consult (already suggested in the iter-139 NOTE block at RigidityKbar.tex:510). Iter-141 carry-over.
- **informational**:
  - Stale `\notready` on `def:genusZeroWitness` / `def:positiveGenusWitness` in `Jacobian.tex` (legacy marker on formalized sorry-bodied scaffolds; iter-140 stripped the same kind in `RigidityKbar.tex`). Not iter-142 work; cleanup candidate for a future blueprint-writer pass on `Jacobian.tex`.

Overall verdict: **PASS** — `RigidityKbar.tex` is iter-142-prover-ready for the three sub-sorries at `Cotangent/GrpObj.lean:624` (d_app), `:643` (d_map), and `:689` (per-open IsIso); HARD GATE green-lights the iter-142 prover-lane dispatch on `AlgebraicJacobian/Cotangent/GrpObj.lean`.
