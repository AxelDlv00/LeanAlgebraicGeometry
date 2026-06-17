# Session 47 (iter-047) — Review Summary

## Metadata
- **Sorry count**: file-active unchanged. SectionGradedRing.lean (NEW) 0 sorry; FlatteningStratification.lean 1→1 (`genericFlatness` @L2360, pre-existing, downstream of G1+G3); AlgebraicJacobian.lean import only.
- **Net new decls**: **+13 axiom-clean** (`{propext, Classical.choice, Quot.sound}`, lean_verify confirmed) — 3 GF + 10 SNAP.
- **Build**: GREEN — `lake build SectionGradedRing FlatteningStratification` exit 0 (8319 jobs); only style/long-line warnings + the expected `genericFlatness` sorry warning.
- **Targets attempted**: 2 lanes — GF G1 base case (4 planned, 3 solved + 1 unplanned helper, 1 assembly blocked), SNAP layer 1 (4 planned, 3 solved + 7 helpers, `tensorPowAdd` deferred-absent).
- blueprint-doctor: **0 findings**. dag gaps=0. sync_leanok (iter 47, sha e3ff16f): **+5 / -0** (Flattening + SectionGradedRing).

## Lane 1 — GF G1 finite-type base case (FlatteningStratification.lean)

### `gf_affine_qcoh_Gamma_epi` (seam 2, the crux) — SOLVED, axiom-clean (~L2273)
Affine Γ-epi: for qcoh `G,F` over `Spec R`, `π : G ⟶ F` `[Epi π]`, `[IsIso G.fromTildeΓ] [IsIso F.fromTildeΓ]` ⟹ `(moduleSpecΓFunctor.map π).hom` surjective. Followed `analogies/gf-gamma-exact.md` (the iter-047 mathlib-analogist recipe — counit + faithful-reflects-epi, NO H¹-vanishing). Three glue fixes the recipe needed:
1. `fromTildeΓNatTrans.app M` is only **defeq** (not syntactic) to `M.fromTildeΓ`; `‹IsIso M.fromTildeΓ›`/`simp` do NOT discharge `IsIso (…app M)`. Fix: `change … at hnat` (defeq change works).
2. `Category.assoc`/`IsIso.hom_inv_id` `rw`/`simp only` silently fail on the `(Spec R).Modules` composition. Fix: iso-cancel as a TERM `(IsIso.eq_comp_inv F.fromTildeΓ).mpr hnat` (`eq_comp_inv` takes iso EXPLICIT).
3. `infer_instance` for `Epi (_≫_≫_)` TIMES OUT (20k hb). Fix: explicit `epi_comp (G.fromTildeΓ ≫ π) (inv F.fromTildeΓ)` + `haveI : Epi (inv F.fromTildeΓ) := inferInstance`.
Then `tilde.functor R` FullyFaithful ⟹ ReflectsEpimorphisms ⟹ `Functor.epi_of_epi_map` ⟹ `ModuleCat.epi_iff_surjective`.

### `gf_qcoh_finite_sections_globally_generated` (seam 3) — SOLVED, axiom-clean (~L2299)
One-liner `Module.Finite.of_surjective (moduleSpecΓFunctor.map π).hom (gf_affine_qcoh_Gamma_epi π)`. Hyp `[Module.Finite R (moduleSpecΓFunctor.obj G)]` is load-bearing. **Generality deviation**: Lean concludes from ANY qcoh epi with finite source sections; blueprint prose describes the free-epi case `O_V^{⊕I}↠F`. `% NOTE:` added (see Blueprint markers + recommendations §1).

### `gf_qcoh_finite_sections_of_free_epi` (seam-3 free-epi base case, UNPLANNED helper) — SOLVED, axiom-clean (~L2318)
Self-contained Stacks-01PB affine base case for `G = tilde N`, `N` finite. Discharges seam-3's source hyps:
- `IsIso (tilde N).fromTildeΓ` = counit of `tilde.adjunction` at `tilde N` (iso because `tilde.functor R` is a FF LEFT adjoint; `tilde.adjunction.counit = fromTildeΓNatTrans` by `rfl`).
- `Module.Finite R Γ(tilde N)` via the unit iso `N ≅ Γ(tilde N)`. Needed `haveI : Module.Finite R ((𝟭 _).obj N) := inferInstanceAs …` — `(𝟭).obj N` only defeq `N`.

### `gf_finiteType_affine_finite_cover_generated` (seam 1) — BLOCKED, left ABSENT (Mathlib gap)
Refine `SheafOfModules.IsFiniteType`'s abstract open cover (`σ.X : σ.I → X.Opens`, arbitrary opens) to a FINITE BASIC-OPEN cover of an affine `W`, preserving finite generation. 3 missing primitives: (i) `GeneratingSections`/`LocalGeneratorsData` restriction along `D(g)↪σ.X i`; (ii) topological refinement of an arbitrary open cover of affine `W` to a finite standard-basic-open subfamily (`PrimeSpectrum.isBasis_basic_opens` + quasi-compactness); (iii) finite-generation-on-D(g) as free epi `O_{D(g)}^{⊕I}↠F|`. `leansearch`/`loogle` confirm no Mathlib bridge at this pin. Left ABSENT (no typed sorry) — the WATCH STOP-and-flag the objective anticipated.

### `gf_qcoh_fintype_finite_sections` (G1 assembly) — BLOCKED, left ABSENT
Path otherwise complete (locality half `gf_finite_sections_of_basicOpen_finite_cover` iter-045 + per-D(g) base case). Two missing links: seam 1 (above) + **transport** `X.Modules|_{D(g)} ↝ (Spec Γ(X,D(g))).Modules` (QUOT `overRestrictEquiv`/opaque-immersion plumbing) to feed the Spec-level base case into the X.Modules locality half. The seam-2/3 decls are stated over `(Spec R).Modules` precisely because seam 2's proof IS the affine `tilde.adjunction`; transport is the price of moving to `X.Modules`.

## Lane 2 — SNAP layer 1 (NEW FILE SectionGradedRing.lean)

NEW leaf file created + root import added (Mathlib-only deps → acyclic, whole project GREEN). **File fully sorry-free**, every decl axiom-clean.

### `tensorObj` / `tensorPow` / `moduleTensorPow` — SOLVED (the 3 planned defs)
- `tensorObj F G := sheafification.obj (MonoidalCategory.tensorObj (C := MonoidalPresheaf X) F.toPsh G.toPsh)`. **Key wiring insight**: Mathlib's `PresheafOfModules.monoidalCategory` is stated for `PresheafOfModules (R ⋙ forget₂ CommRingCat RingCat)`; instance resolution on `X.PresheafOfModules` FAILS (HO: can't solve `X.ringCatSheaf.obj =?= ?R ⋙ forget₂ _ _`). Fix: `abbrev MonoidalPresheaf X := _root_.PresheafOfModules (X.sheaf.obj ⋙ forget₂ CommRingCat RingCat)` (defeq `X.PresheafOfModules` but exact `_⋙forget₂_` form so the instance fires first-order). **TRAP**: unqualified `PresheafOfModules` inside namespace `…Scheme.Modules` resolves to the SCHEME abbrev (takes a `Scheme`!) — use `_root_.PresheafOfModules`.
- `sheafification := PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)`.
- `tensorPow`/`moduleTensorPow` ℕ-recursion + defeq simp unfolders.

### 7 launching-pad helpers — SOLVED
- `sheafificationCounitIso (G) : sheafification.obj G.toPsh ≅ G`. First attempt `asIso (counit.app G)` FAILED (per-component `IsIso (adj.counit.app G)` from `Adjunction/FullyFaithful.lean:90` does NOT synthesize — `?h.counit.app ?X` unification fails). Working route: whole-NatTrans iso `counit_isIso_of_R_fully_faithful` then `.app G` (`restrictScalars (𝟙)` defeq `𝟭` ⟹ right adjoint FF).
- `tensorObjUnitIso`/`tensorObjRightUnitor` = `sheafification.mapIso (λ_/ρ_ (C := MonoidalPresheaf X) …) ≪≫ sheafificationCounitIso` (`(C := …)` ascription required; `unitModule` defeq `𝟙_(MonoidalPresheaf X)` by rfl).
- `tensorBraiding (F G) : tensorObj F G ≅ tensorObj G F` = `sheafification.mapIso (β_ …)`; needs NO strong-monoidality (does not nest sheafification in a tensor factor).

### `tensorPowAdd` (`lem:sheafTensorPow_add`) — DEFERRED, left ABSENT (no decl, no sorry)
Induction on `m`: base `m=0` fully available (`tensorObjUnitIso (tensorPow L m') ≪≫ eqToIso (Nat.zero_add)`); step `m=k+1` needs the **sheaf-level associator** = strong-monoidality of `sheafification`: the maps `sheafification.obj (P⊗Q) ⟶ sheafification.obj ((sheafification.obj P).val⊗Q)` (= sheafification applied to `η_P ⊗ 𝟙_Q`) must be iso. True (`η_P⊗𝟙_Q` is a stalkwise iso even though not locally injective — tensor only right-exact) but Mathlib (pinned) lacks the localizer instantiation AND a stalkwise-iso⟹iso criterion for `SheafOfModules` morphisms. **DO-NOT-RETRY**: hand-rolling the associator alone without the stalkwise criterion.

## Reviewer dispositions (this phase)
- **lean-auditor `iter047`** (0 must-fix / 0 critical / 0 major / 1 minor): all 13 new decls genuine, non-vacuous, axiom-clean; `tensorPowAdd` cleanly ABSENT (no sorry stub); no excuse-comments, no parallel-Mathlib APIs. Minor = `hN` named-`haveI` reads like a debug artifact (cosmetic, technically necessary). Report: `logs/iter-047/lean-auditor-iter047-report.md`.
- **lean-vs-blueprint-checker `sectiongradedring-iter047`** (0 must-fix / 1 minor): 3 planned defs match blueprint; `tensorPowAdd` correctly absent (no `\leanok`); 10 helpers = coverage debt (acceptable launching pad). Report: `logs/iter-047/lean-vs-blueprint-checker-sectiongradedring-iter047-report.md`.
- **lean-vs-blueprint-checker `flatteningstratification-iter047`** (0 must-fix / 1 major partial / coverage): 3 GF decls axiom-clean + correct; **major** = prose-vs-Lean generality mismatch on `lem:gf_qcoh_finite_sections_globally_generated` (blueprint=free epi, Lean=any qcoh epi; the free-epi-matching `gf_qcoh_finite_sections_of_free_epi` is unpinned). seam 1 + G1 assembly correctly unformalized. Report: `logs/iter-047/lean-vs-blueprint-checker-flatteningstratification-iter047-report.md`.

## Blueprint markers updated (manual)
- `Picard_FlatteningStratification.tex`, `lem:gf_qcoh_finite_sections_globally_generated`: added `% NOTE:` (iter-047) on the prose-vs-Lean generality mismatch (pinned Lean is the general "any qcoh epi" form; free-epi prose matches the unpinned `gf_qcoh_finite_sections_of_free_epi`). Planner to reconcile (recommendations §1). No `\leanok` override (sync correct).

## Key findings / patterns
- Affine Γ-epi is the `tilde.adjunction` counit, not a stalkwise H¹ argument — closes the iter-045 "no Γ-level corollary" worry for the affine case. The remaining GF blocker shifted to seam 1 (topological cover refinement) + the X.Modules↔Spec transport.
- The SNAP sheaf tensor reuses Mathlib's `PresheafOfModules.monoidalCategory` + sheafification; the only real obstruction in the layer is the associator (strong-monoidality of sheafification).
- New KB patterns added: "Affine Γ-epi from the tilde.adjunction counit" and "Sheaf-of-modules tensor = sheafify objectwise presheaf tensor". GF-G1 blocker entry updated.

## Recommendations
See `recommendations.md`. Headline: decompose seam 1 into 3 sub-lemmas (effort-break, start with the topological refinement); build the X.Modules affine-local restatement of the free-epi base case via the gap1 opaque-immersion recipe; for SNAP, build the stalkwise-iso⟹IsIso criterion before the associator. 11 unmatched coverage-debt nodes to blueprint.
