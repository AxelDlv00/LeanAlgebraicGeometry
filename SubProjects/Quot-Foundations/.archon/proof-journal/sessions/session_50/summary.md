# Session 50 (iter-050) — Review Summary

## Metadata
- **Sorry counts:** FlatteningStratification 1 → 1 (genericFlatness @L2668, gated); GrassmannianQuot 0 → 5 (NEW FILE, all 5 = planner-requested scaffold signatures). dag gaps = 0.
- **Axiom-clean decls added: +8** (3 FlatteningStratification GeneratingSections engine + 2 GF seam-1 lemmas + 3 GrassmannianQuot). lean_verify on `gf_localGenerators_restrict`, `gf_finiteType_affine_finite_cover_generated`, `chartQuotientMap`: all `{propext, Classical.choice, Quot.sound}`.
- **Build GREEN** (FlatteningStratification 94s; GrassmannianQuot 8319 jobs OK). blueprint-doctor: **0 findings**. sync_leanok (iter-050, sha 42ea31e): **+8 / -1**.
- **Targets:** 2 lanes — GF seam-1 (FlatteningStratification) + GR-quot scaffold (GrassmannianQuot, NEW).

## Lane 1 — GF seam-1 (FlatteningStratification) — CONVERGING
The iter-050 MAKE-OR-BREAK gate (seam-1a) is **CLEARED**. Seam-1 chain (1a/1b/1c + assembly) now COMPLETE + axiom-clean.

- **`SheafOfModules.GeneratingSections.map` / `map_I` / `map_isFiniteType`** (engine, ~L2433/2447/2459) — GeneratingSections analogue of Mathlib `Presentation.mapGenerators`. Generator map `(mapFree F η σ.I).inv ≫ F.map σ.π`, epi via `preservesColimitsOfSize_shrink` → `PreservesColimitsOfShape WalkingSpan` + `epi_comp`.
  - **Key fix:** `hF : PreservesColimitsOfSize.{u,u} F` passed **EXPLICIT, not instance** — instance search does not fire reliably through the `X.Modules := SheafOfModules.{u} X.ringCatSheaf` abbreviation (def, semireducible; registered under `Modules` form, search wants `SheafOfModules.{u}` form).
  - **Universe gotcha:** `leftAdjoint_preservesColimits` shape-universe metavars pin only when the term is an explicit arg (expected type drives unification), NOT in `haveI : T := term`. `map_isFiniteType` is a separate *theorem* (not instance) — anon `⟨…⟩` constructor for `IsFiniteType` defaults universes to 0; theorem return type pins `{u,u,u}`.

- **`gf_localGenerators_restrict`** (seam-1a, ~L2479) — `(F.over Y).GeneratingSections` finite + `V ≤ Y` ⟹ `∃ τ : ((pullback V.ι).obj F).GeneratingSections, τ.IsFiniteType`. Two `GeneratingSections.map` stages:
  - Stage A (slice→geometric on Y): `map` along `(overRestrictEquiv Y).functor` (unit-iso `overRestrictUnitIso Y`), then `equivOfIso (overRestrictPullbackIso Y F)`.
  - Stage B (geometric Y→V): `map` along `pullback (X.homOfLE hVY)` (open immersion `j`), unit-iso = `pullbackOpenImmersionUnitIso` (QuotScheme:2586, finality packaged); identify objects via `pullbackComp` + `pullbackCongr (X.homOfLE_ι hVY)`.
  - **Dead ends avoided:** slice `pushforward` (right adjoint) does NOT preserve epi; `freeFunctorCompPullbackIso`/`pullbackObjFreeIso` need a separate `F.Final`.

- **`gf_finiteType_affine_finite_cover_generated`** (assembly, ~L2526) — `IsFiniteType.exists_localGeneratorsData` → cover `{lgd.X i}`; `coversTop` + `Sieve.ofObjects`/`mem_ofObjects_iff` give `W ≤ ⨆ lgd.X i`; seam-1b `gf_affine_finite_standard_subcover` refines to finite standard subcover; seam-1a restricts; affineness from `hW.basicOpen g`.
  - **`[F.IsQuasicoherent]` DROPPED** from signature — genuinely unused at cover-extraction (only `GeneratingSections` objects produced); reintroduced in G1. Confirmed by lean-auditor + lvb-checker. Blueprint prose still over-qualifies → `% NOTE:` added (see markers).

- **`genericFlatness` (G1+G3) — BLOCKED, untouched.** G1 reduces EXACTLY to per-`g` base case `gf_qcoh_finite_sections_of_genSections` (the gap1-hard `X.Modules ↔ Spec` transport of a finite free epi across `IsAffineOpen.isoSpec`; sub-steps a/b/c each gap1/gap2-level). G3 = stalkwise flatness local-on-source build. Both Mathlib-absent multi-lemma builds.

## Lane 2 — GR-quot scaffold (GrassmannianQuot, NEW FILE) — UNCLEAR (fresh)
NEW file created + root-imported (acyclic: imports GrassmannianCells + QuotScheme).

- **`globalUnitSection`** (~L38) — global section of `O_X` from `a ∈ Γ(X,⊤)` via `PresheafOfModules.sectionsMk` + `R.obj.map (homOfLE le_top).op`; compatibility via `rw [← comp_apply, ← R.obj.map_comp]; congr 1` (restriction maps from initial `op ⊤` equal by `congr`).
- **`scalarEnd`** (~L52) — scalar endomorphism of `O_X` via `unitHomEquiv` + `globalUnitSection`. `End(unit R)` IS a `Ring`.
- **`chartQuotientMap`** (~L73, **headline**) — `u^I : O^r → O^d` = left-mult by universal matrix `X^I`, via `biproduct.matrix`: `(biproduct.isoCoproduct _).symm.hom ≫ biproduct.matrix M ≫ (biproduct.isoCoproduct _).hom`. **Key:** `(unit R).sections` has NO `AddCommGroup`/`Module` instance → `freeHomEquiv` route NOT viable; use biproducts. `HasFiniteBiproducts(SheafOfModules R)` NOT a global instance → `haveI ... of_hasFiniteProducts`.

- **5 scaffolds (sorry):** `Scheme.Modules.glue`, `universalQuotient`, `tautologicalQuotient`, `functor`, `represents`. `represents` is `noncomputable def` (RepresentableBy = data, not Prop). `Scheme.Modules.glue` **MOST URGENT** — `_g` transition-iso param lacks module cocycle hypotheses (`g_ii=id`, triple-overlap multiplicative cocycle); signature MUST be fixed before body filled (lean-auditor MAJOR + lvb-checker MAJOR; in-file NOTE acknowledges).
- **Epi chartQuotientMap NOT added** — next GR-quot step; split epi via `freeMap inclFn ≫ chartQuotientMap = 𝟙`; needs ≥5-lemma chain (scalarEnd ring-hom packaging, biproduct↔coproduct bridge `Sigma.ι ≫ isoCoproduct.inv = biproduct.ι`, `biproduct.ι_matrix`/`matrix_π`, minor identity `universalMatrix_submatrix_self`, `Cofan.IsColimit.hom_ext`).

## Key findings / patterns
- **EXPLICIT `PreservesColimitsOfSize` arg** beats instance search through `def`-backed `X.Modules`/`pullback` (recurring reducibility trap; cf. `quot-gap1-closed-opaque-immersion`).
- **`leftAdjoint_preservesColimits` universe metavars** pin via explicit-arg expected-type, not `haveI :=`.
- **`(unit R).sections` has no module instance** — sheaf-of-modules linear combos go through **biproducts** (`biproduct.matrix`/`isoCoproduct`), not `freeHomEquiv`. `HasFiniteBiproducts` not global.
- **Scaffold-vs-no-sorry tension:** mathlib-build mode forbids sorry, but planner objective + blueprint gate require scaffold signatures for the new GR-quot leaf; prover resolved via "local takes precedence" (cf. existing `Scheme.Grassmannian.representable` sorry pattern).

## Subagent reports
- **lean-auditor `iter050`** (6 must-fix-sorries/1 major/2 minor): all 5 FlatteningStratification decls + 3 GrassmannianQuot decls genuine + axiom-clean; dropped `[F.IsQuasicoherent]` confirmed unused; `genericFlatness` sorry honest. `Scheme.Modules.glue` cocycle gap = most urgent (signature fix before body). → recommendations.md.
- **lvb-checker `flat-iter050`** (0 red flags / 2 major blueprint-side): GeneratingSections engine (`map`/`map_I`/`map_isFiniteType`) missing blueprint block; spurious `[F.IsQuasicoherent]` in `lem:gf_finiteType_affine_finite_cover_generated` prose. → recommendations.md.
- **lvb-checker `grquot-iter050`** (2 major / 0 must-fix): `glue` cocycle hypotheses absent; `globalUnitSection`/`scalarEnd` unblueprinted. `chartQuotientMap` + `represents` (noncomputable def) faithful. → recommendations.md.

## Blueprint markers updated (manual)
- `Picard_FlatteningStratification.tex`, `lem:gf_finiteType_affine_finite_cover_generated`: added `% NOTE:` (iter-050) — Lean dropped `[F.IsQuasicoherent]`; planner to drop "quasi-coherent" from the prose hypotheses to match the signature.

(No manual `\leanok` overrides — sync_leanok iter-050 sha 42ea31e applied +8/-1; markers trusted.)

## Recommendations (next iter) — see recommendations.md
1. Coverage debt: 15 unmatched `lean_aux` nodes (3 GF engine + 2 GR-quot helpers from this iter + 10 SNAP carryover). Planner to blueprint.
2. **`Scheme.Modules.glue` signature fix** (add cocycle hypotheses) before any body-fill attempt.
3. GF G1: dedicate one iter to `gf_qcoh_finite_sections_of_genSections` (Spec transport a/b/c). G3 separately.
4. GR-quot next: `Epi chartQuotientMap` (≥5-lemma chain, fully specified) feeds `tautologicalQuotient`.
