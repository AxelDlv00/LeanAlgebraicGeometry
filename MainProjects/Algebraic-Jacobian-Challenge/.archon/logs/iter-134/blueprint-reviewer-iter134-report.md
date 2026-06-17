# Blueprint Review Report

## Slug
iter134

## Iteration
134

## Top-level summaries

### Incomplete parts

- `RigidityKbar.tex` / `lem:GrpObj_omega_free` (piece i.c): proof sketch is a 3-line invocation of `lem:GrpObj_mulRight_globalises` + `lem:GrpObj_cotangentSpace`; the chart-localisation identification step (sheaf-promotion of `cotangentSpaceAtIdentity G` ↔ `η_G^* relativeDifferentialsPresheaf G.hom`, ~100–200 LOC per `analogies/mulright-globalises-cotangent.md` Decision 4 step 4) is named in the analogist's verdict but is not lifted into the chapter as a standalone sub-lemma. Acceptable for iter-134 (the directive flags this as iter-137+ pre-prover hardening); recorded here so the iter-137+ writer pass picks it up.
- `RigidityKbar.tex` / `lem:GrpObj_omega_rank_eq_dim` (piece i.c): identical situation — 2-line "rank of pulled-back bundle equals dimension of fibre" proof, no Mathlib names. iter-137+ pre-prover hardening target. NOT iter-134 must-fix per directive.
- `Jacobian.tex` § C.2.a–C.2.e: still narrates the over-`\bar k` historical scaffolding (statement of rigidity over `\bar k`, image-dimension over `\bar k`, both proof routes for the keystone over `\bar k`, set→scheme promotion over `\bar k`). The drift is contained because § C.2.f is the explicit DROP marker (the Galois descent step is no longer needed under iter-127 over-k) and § C.2.g re-states the gap inventory over `k`. C.2.f and C.2.g remain in place verbatim (lines 352 and 354 of the chapter). The local prose is internally consistent but verbose; not iter-134 must-fix per directive's Known-Issues clause.

### Proofs lacking detail

- `RigidityKbar.tex` / `lem:GrpObj_omega_free` (piece i.c): see above.
- `RigidityKbar.tex` / `lem:GrpObj_omega_rank_eq_dim` (piece i.c): see above.
- `Jacobian.tex` / `thm:Jacobian_grpObj`, `thm:Jacobian_smooth_genus`, `thm:Jacobian_proper`, `thm:Jacobian_geomIrred`: proofs project a field of the witness from `thm:nonempty_jacobianWitness`. Already `\leanok`-marked; the prose adequately documents the projection. No actionable issue.

### Lean difficulty quality

- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent}`: signature stub is fully written out in the chapter's comment block (lines 298–321), pinning the RHS at the **sheaf level** with `η_G^* (relativeDifferentialsPresheaf G.hom)` per the iter-133 analogist's recommendation (`analogies/mulright-globalises-cotangent.md` Decisions 3+4). This is the recommended form. The lemma is **prover-ready**: a prover working from this stub has the construction (`Hom_inv_id`/`Inv_hom_id` for the shear iso), the natural iso pattern (chains `KaehlerDifferential.tensorKaehlerEquiv` and `TopCat.Presheaf.pullback`), and the section restriction step (uses `PresheafOfModules.pullbackComp` and `PresheafOfModules.pullbackId`) all named with Mathlib references.
- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two}` (helper sub-lemma): signature stub correctly specifies the LHS `pr_1`-vs.-`pr_2` asymmetry per the binary-product universal property in `Over (Spec k)`. NEEDS_MATHLIB_GAP_FILL flagged honestly. Adequate for prover dispatch.
- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section}` (helper sub-lemma): signature stub correctly chains `φ_section`, `φ_pr_two`, `φ_str`, `φ_η` compatibility morphisms. Estimated ~30–80 LOC. Adequate for prover dispatch.
- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars}`: declaration exists at `AlgebraicJacobian/Cotangent/GrpObj.lean:210–231` (line numbers in the blueprint and in the Lean file's own docstring are stale: blueprint comments lines 129 and 159 cite `198–219`, off by ~12 lines). Cosmetic only.
- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq}`: declaration exists at `AlgebraicJacobian/Cotangent/GrpObj.lean:256–294` (blueprint line 493 cites `276–282`, off by ~13 lines). Cosmetic only.

### Multi-route coverage

- Route "Direct over-k rigidity via shared cotangent-vanishing pile (i)+(ii)+(iii)": **PASS** — covered in `RigidityKbar.tex` (statement + proof decomposition + § Piece (i) decomposition with sub-lemmas i.a, i.b, i.c, and the structural-shape witness lemma) and consumed by `Jacobian.tex` § C.2.g and `def:genusZeroWitness`. Single critical-path route. Piece (i.a) DONE (closed iter-132); piece (i.b) prover-ready for iter-134+; pieces (i.c) blueprint-hardened iter-137+ target (3 NEEDS_MATHLIB_GAP_FILL sub-lemmas documented); pieces (ii)+(iii) staged for iter-145+ but blueprint-described.
- Route "M2.d Riemann–Roch alternative" (M2.d-alt of STRATEGY.md): documented but explicitly DEFERRED in `RigidityKbar.tex` § "(iv) Serre duality on a smooth proper curve --- DEFERRED as named gap" (3000–8000 LOC, not on iter-134 critical path; informational).
- Route "M3 Picard / Sym^n+Stein" (Route A / Route B of `Jacobian.tex` § C.2): documented in `Jacobian.tex` § "Route A" and § "Route B" with full Mathlib-status decompositions. User-escalation-pending. NOT iter-134 critical path.

## Per-chapter

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - PASSES the HARD GATE for the iter-134 piece (i.b) prover dispatch. Specifically:
    - `lem:GrpObj_mulRight_globalises` (target `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent`) is fully hardened: signature stub written in the Lean-comment block (lines 298–321 of the chapter), 3-step proof prose with Mathlib name summary, sheaf-level RHS adopted per iter-133 analogist verdict (Decision 4 ALIGN_WITH_MATHLIB), 2 sub-lemmas factored out (`lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_omega_restrict_to_identity_section`), 210–440 LOC envelope explicit.
    - `lem:GrpObj_omega_basechange_proj` (load-bearing helper, ~150–300 LOC NEEDS_MATHLIB_GAP_FILL) is well-formulated: chains `KaehlerDifferential.tensorKaehlerEquiv` (algebra-side) with `TopCat.Presheaf.pullback` (presheaf-side) via the project's `relativeDifferentialsPresheaf_obj_kaehler`. Signature stub names `(G ⊗ G).left` and the `pr_1`-vs.-`pr_2` asymmetry correctly.
    - `lem:GrpObj_omega_restrict_to_identity_section` (~30–80 LOC) is well-formulated: applies `PresheafOfModules.pullbackComp` + `PresheafOfModules.pullbackId` to the categorical identity `pr_2 ∘ s = η_G ∘ π_G` in `Over (Spec k)`.
    - MED-B `lem:GrpObj_cotangentSpace_extendScalars_witness` block (added iter-133) correctly first-classifies the iter-131 in-tree theorem `cotangentSpaceAtIdentity_eq_extendScalars` (statement matches `AlgebraicJacobian/Cotangent/GrpObj.lean:210–222`), `\uses` graph cleanly cites `lem:GrpObj_cotangentSpace` + `thm:smooth_locally_free_omega`.
    - MED-C "Iter-131 `Classical.choose`-chain body shape" paragraph (lines 484–497) correctly describes the direct `change`-based route as primary (the iter-132 in-tree closure pattern at `Cotangent/GrpObj.lean:288–294`) and the `obtain`+`rw [heq]` route as the alternative for consumers whose goal does not unify with the underlying `TensorProduct` carrier.
  - **Minor blueprint-side line drifts (informational, NOT must-fix; flagged but tolerable)**:
    - Line 159 cites `AlgebraicJacobian/Cotangent/GrpObj.lean:198--219` for the `cotangentSpaceAtIdentity_eq_extendScalars` proof; actual location is **210–231** (off by ~12 lines).
    - Line 493 cites `AlgebraicJacobian/Cotangent/GrpObj.lean:276--282` for the iter-132 `cotangentSpaceAtIdentity_finrank_eq` close; actual location is **288–294** (the `change` + `rw [Module.finrank_baseChange]` + `exact Module.finrank_eq_of_rank_eq hrank` block; the theorem block as a whole runs **256–294**).
    - The Lean file's own docstring (lines 28, 30, 31–32) carries the same stale line numbers (`149`, `198`, `244` for the three declarations; actual: 161, 210, 256). The drift sources to a pre-iter-133-docstring-refresh delta in line counts; harmless.
    - These do not break any `\uses{...}` graph, do not affect prover work, and the corrected references are obvious from a grep. Per the directive's "Known issues" clause, they remain informational; a follow-up sync pass (line-number refresh in both the chapter and the Lean docstring) is the natural iter-135 cleanup.
  - Piece (i.c) lemmas `lem:GrpObj_omega_free` and `lem:GrpObj_omega_rank_eq_dim` are correctly `\notready` and have placeholder proof sketches; iter-137+ pre-prover hardening target per directive Focus Area 5.
  - The chapter's "Honest pile cost" footer (line 499) summary `1350–2600 LOC over 7–14 iters` is consistent with the iter-126 analogist's revision and the iter-127 over-k re-scoping.
  - `\uses{...}` graph is internally clean: every `\uses{lem:GrpObj_cotangentSpace, ...}`, `\uses{thm:smooth_locally_free_omega}`, etc. references a label that exists in either this chapter or `Differentials.tex`.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - C.2.a–C.2.e narration (lines 322–351) remains over-`\bar k` historical scaffolding. § C.2.f (line 352) is the explicit `[DROPPED iter-127]` safety guard, which keeps the chapter internally consistent: the Galois descent step is annotated as no-longer-needed in light of the iter-127 over-k commitment. § C.2.g (line 354) re-establishes the gap inventory over `k` and routes the keystone to `\cref{thm:rigidity_over_kbar}` via the shared cotangent-vanishing pile pieces (i)+(ii)+(iii). The "Mathlib infrastructure summary" paragraph (line 372 § ($\gamma$)) and the "Implementation route via the Albanese functor" paragraph (line 418) both cleanly state the over-k version.
  - The directive explicitly classifies C.2.a–C.2.e soft drift as `correct: partial` informational (not must-fix) as long as the C.2.f safety guard is in place. **Confirmed: C.2.f is in place verbatim**. Therefore `correct: partial` here is informational only — no prover route consumes the sub-step prose directly, the consumer (`def:genusZeroWitness` body) routes via `\cref{thm:rigidity_over_kbar}` directly with the supplied `P : 𝟙 ⟶ C`, sidestepping the over-`\bar k` narration. No blueprint-writer dispatch is needed this iter on this drift.
  - One small consistency item: `thm:exists_unique_ofCurve_comp` is referenced from `Rigidity.tex` line 58 (`\ref{thm:exists_unique_ofCurve_comp}`) but lives in `AbelJacobi.tex` (label exists there as the Albanese property theorem). The `\ref` works because `\ref` is global; no breakage. Note: `Rigidity.tex` line 61 uses `\ref` instead of `\cref` — purely stylistic.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three protected declarations + universal property all `\leanok`-marked.
  - Closure prose for `thm:exists_unique_ofCurve_comp` correctly routes to `def:IsAlbanese` projection (Layer-I Lean) and references the iter-127 over-k commitment for the genus-0 sub-case (line 82 with explicit DROPPED-C.2.f note).
  - Cross-references to `Jacobian.tex` chapter labels resolve cleanly.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:GrpObj_eq_of_eqOnOpen` statement + proof + Mathlib ingredients fully written; declaration is `\leanok`-marked.
  - Iter-125 refactor note (line 24) explains the source-side group-object drop and the `IsProper Y.hom → IsSeparated Y.hom` weakening.
  - "Use in the project" cites `M2.a` consumer via `\cref{thm:rigidity_over_kbar}`.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:genus` is well-formulated, links to the `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)` Lean realisation, `\leanok`-marked, and grounded in `def:Scheme_HModule` + `def:Scheme_toModuleKSheaf`. No issues.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:relative_kaehler_presheaf`, `lem:relative_kaehler_presheaf_obj`, `thm:smooth_locally_free_omega`, `lem:kaehler_localization_subsingleton`, `lem:kaehler_quotient_localization_iso` all well-stated, `\leanok`-marked, and Mathlib-name-augmented.
  - The off-loop Mathlib-PR candidate `KaehlerDifferential.equivOfFormallyUnramified` (lem:kaehler_quotient_localization_iso) is documented but not iter-134 critical path; informational only.
  - The converse-direction roadmap (M4) and the M5–M8 milestone list are out of iter-134 scope and correctly flagged.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single theorem `thm:HasSheafCompose_forget` with adequate proof; `\leanok`-marked.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three declarations (`thm:HasSheafify_Opens_AddCommGrp`, `thm:HasExt_Sheaf_Opens_AddCommGrp`, `def:Scheme_toAbSheaf`) all `\leanok`-marked. No issues.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **Label-prefix asymmetry (carried over from iter-133 reviewer; still present)**: line 358's `\label{thm:Scheme_IsAffineHModuleVanishing}` sits inside a `\begin{definition}` block (label prefix would normally be `def:`). `Cohomology_MayerVietoris.tex` line 917 dereferences this label via `Definition~\ref{def:Scheme_IsAffineHModuleVanishing}` — note the `def:` prefix in the `\ref`, which does NOT match the actual label. The result is a "??"-rendered broken `\ref` in the compiled blueprint.
  - The `\uses{...}` graph is unaffected: every `\uses{thm:Scheme_IsAffineHModuleVanishing}` (line 368, 373 in this chapter; line 931 in Cohomology_MayerVietoris.tex) uses the `thm:` prefix correctly. Only the in-prose `\ref` at Cohomology_MayerVietoris.tex line 917 is broken.
  - Per directive's Known-Issues clause: do not re-classify as must-fix; cleanup soon. Mark `correct: partial` to record the surface-rendering bug; informational severity. No prover route consumes the `\ref`-rendered output directly.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **3 broken `\ref{...}` cross-refs (carried over from iter-133 reviewer; still present)**:
    1. Line 769: `Sections~\ref{sec:basic_open_infrastructure}--\ref{sec:basic_open_acyclicity}`. Neither label exists in any chapter (grep-confirmed: no `\label{sec:basic_open_infrastructure}` and no `\label{sec:basic_open_acyclicity}` anywhere in `blueprint/src/chapters/`).
    2. Line 917: `Definition~\ref{def:Scheme_IsAffineHModuleVanishing}`. The actual label is `thm:Scheme_IsAffineHModuleVanishing` in `Cohomology_StructureSheafModuleK.tex` line 358 (the `def:` prefix in the `\ref` is wrong; the label asymmetry is the upstream cause).
  - All three are surface-rendering bugs: the rendered blueprint shows "??" at these sites. NONE of them corrupt the `\uses{...}` dependency graph — the actual `\uses{...}` arcs around these sections use the correctly-prefixed labels (e.g., line 931 uses `\uses{... thm:Scheme_subsingleton_HModule_prime_of_hasCechToHModuleIso}`, line 943 uses no `\uses` since it's a "Use in project" prose section).
  - Per directive's Known-Issues clause: do not re-classify as must-fix; cleanup soon. Mark `correct: partial` to record the surface-rendering bugs; informational severity. No prover route this iter consumes this chapter's prose.

## Cross-chapter notes

- The `def:` vs `thm:` label-prefix asymmetry on `Scheme_IsAffineHModuleVanishing` is the upstream cause of one of the three broken `\ref{...}` in `Cohomology_MayerVietoris.tex`. The chosen fix has two acceptable shapes: (a) rename the label in `Cohomology_StructureSheafModuleK.tex:358` from `thm:` to `def:` and update its 3 `\uses` consumers (this chapter lines 368, 373; `Cohomology_MayerVietoris.tex:923, 931`), or (b) fix the in-prose `\ref` on `Cohomology_MayerVietoris.tex:917` from `def:` to `thm:`. Option (b) is one-line; option (a) is consistent with the `\begin{definition}` block but requires updating 3 sites in 2 chapters.
- The `RigidityKbar.tex` stale Lean-file line numbers at lines 159 and 493 mirror the same stale numbers carried in the Lean docstring at `AlgebraicJacobian/Cotangent/GrpObj.lean:28, 30, 31–32`. A coordinated refresh of both the chapter and the Lean docstring would fix all 5 sites with a single line-number sync.

## Strategy-modifying findings

None this iter. The iter-127 over-k commitment continues to be the single critical-path route; the M2.d Riemann–Roch alternative (`lem:GrpObj_omega` piece iv) is correctly DEFERRED as a named gap; M3 (positive genus) routes A/B remain user-escalation-pending. No definition encountered in this audit conflicts with the strategy.

## Severity summary

- **must-fix-this-iter**: NONE.
  - No "Strategy-modifying findings" section.
  - No route under "Multi-route coverage" is MISSING (the single critical-path route is well-covered; the M2.d-alt and M3 routes are correctly deferred per strategy).
  - No `\uses{...}` cross-reference is broken (the 3 broken `\ref{...}` in `Cohomology_MayerVietoris.tex` and the label-prefix asymmetry in `Cohomology_StructureSheafModuleK.tex` are in-prose `\ref` sites only and do not corrupt the dependency graph).
  - No Lean-difficulty-quality finding sits on an active iter-134 prover route (the iter-134 piece-(i.b) target `mulRight_globalises_cotangent` is well-formulated; the iter-137+ piece-(i.c) targets `omega_free`/`omega_rank_eq_dim` are correctly `\notready` and out of scope).
- **soon** (cross-cutting items that don't block iter-134 prover work):
  - `Cohomology_MayerVietoris.tex:769` — broken `\ref{sec:basic_open_infrastructure}` and `\ref{sec:basic_open_acyclicity}` (labels do not exist).
  - `Cohomology_MayerVietoris.tex:917` — broken `\ref{def:Scheme_IsAffineHModuleVanishing}`; should be `thm:`.
  - `Cohomology_StructureSheafModuleK.tex:358` — label-prefix asymmetry (`thm:` prefix on a `\begin{definition}` block); causes the `Cohomology_MayerVietoris.tex:917` broken `\ref`.
  - `RigidityKbar.tex:159, 493` — stale Lean-file line numbers (cite `198–219` / `276–282`; actual are `210–231` / `288–294`).
  - `AlgebraicJacobian/Cotangent/GrpObj.lean:28, 30, 31–32` (docstring, not blueprint, but mirrored content) — same stale line numbers as `RigidityKbar.tex` above.
- **informational**:
  - `RigidityKbar.tex` piece (i.c) lemmas (`lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`) carry minimal proof sketches; per directive Focus Area 5, iter-137+ pre-prover hardening target. The lemmas are correctly `\notready` (sync_leanok will remove `\notready` only when the body lands).
  - `Jacobian.tex` § C.2.a–C.2.e over-`\bar k` historical scaffolding; safely guarded by the explicit § C.2.f DROP marker and § C.2.g over-k inventory.

**Overall verdict**: The iter-134 piece (i.b) prover dispatch on `AlgebraicJacobian/Cotangent/GrpObj.lean` (target `mulRight_globalises_cotangent`) is **CLEARED**: `RigidityKbar.tex` PASSES the HARD GATE (`complete: true` / `correct: true`, no must-fix finding names the chapter); the iter-133 blueprint-writer's MED-A/B/C edits successfully prepared the chapter for prover dispatch with the sheaf-level RHS, the 2 helper sub-lemmas, the MED-B companion lemma first-classification, and the MED-C rewrite-pattern paragraph all in place.
