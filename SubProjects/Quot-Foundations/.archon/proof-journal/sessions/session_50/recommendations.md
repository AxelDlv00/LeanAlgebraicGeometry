# Recommendations — next plan iter (post iter-050)

## TOP — must-fix from subagents

1. **`Scheme.Modules.glue` signature is INCOMPLETE — fix before any body-fill** (lean-auditor MAJOR + lvb-checker `grquot` MAJOR). The `_g` transition-iso parameter lacks the module cocycle hypotheses (`g_ii = id`; triple-overlap multiplicative cocycle `g_{jk}∘g_{ij}=g_{ik}`). As written the scaffold would accept logically incoherent gluing data. Planner/refactor must ADD the cocycle hypotheses to the signature (an honest signature correction, not a proof) before scheduling a prover to fill the body. This decl is the bottleneck for `universalQuotient`/`tautologicalQuotient`/`represents` — 4 of the 5 GR-quot scaffolds ride on it.

2. **Blueprint prose fix — drop "quasi-coherent" from `lem:gf_finiteType_affine_finite_cover_generated`** (lvb `flat`). Lean signature dropped `[F.IsQuasicoherent]` (confirmed unused). `% NOTE:` added in chapter; planner blueprint-writer to rewrite the statement hypotheses to "finite-type sheaf of modules" (qcoh reintroduced in G1 downstream).

## Coverage debt (1-to-1) — `archon dag-query unmatched` = 15 lean_aux nodes

Planner must blueprint these (review agent does not write prose). This-iter additions:
- **`SheafOfModules.GeneratingSections.map`** (FlatteningStratification) — relies on Mathlib `mapFree`, `freeHomEquiv`, `preservesColimitsOfSize_shrink`, `epi_comp`. GeneratingSections analogue of `Presentation.map`.
- **`SheafOfModules.GeneratingSections.map_I`** — `rfl` (index type preserved).
- **`SheafOfModules.GeneratingSections.map_isFiniteType`** — finiteness survives `map`.
  → single short blueprint lemma "transport of generating sections along a colimit/unit-preserving functor" covers all three.
- **`Grassmannian.globalUnitSection`** (GrassmannianQuot) — `PresheafOfModules.sectionsMk` + `R.obj.map_comp` + `op ⊤` initial. Scalar-endomorphism plumbing.
- **`Grassmannian.scalarEnd`** (GrassmannianQuot) — `unitHomEquiv` + `globalUnitSection`. Used by `chartQuotientMap`.
  → short sub-section under `sec:grquot_chart` ("Infrastructure: scalar endomorphisms").

Carryover (SNAP, 10 nodes — already flagged prior iters, still unmatched): `Scheme.Modules.MonoidalPresheaf`, `moduleTensorPow_zero`, `sheafification`, `sheafificationCounitIso`, `tensorBraiding`, `tensorObjRightUnitor`, `tensorObjUnitIso`, `tensorPow_succ`, `tensorPow_zero`, `unitModule`.

## Closest-to-completion / proceed-now

- **GR-quot `Epi chartQuotientMap`** — fully specified ≥5-lemma chain (split epi `freeMap inclFn ≫ chartQuotientMap = 𝟙 (free (Fin d))`): (1) `scalarEnd` packaged as `R^I →+* End(unit R)`; (2) biproduct↔coproduct bridge `Sigma.ι _ k ≫ isoCoproduct.inv = biproduct.ι _ k`; (3) `biproduct.ι_matrix`/`matrix_π`; (4) minor identity `(universalMatrix) p (inclFn k) = if p=k then 1 else 0` (from `universalMatrix_submatrix_self`, GrassmannianCells:150); (5) `Cofan.IsColimit.hom_ext`. All primitives verified present. This is the FIRST GR-quot task next iter — feeds `tautologicalQuotient` surjectivity. glue-independent.
- **GR-quot `functor`** — glue-INDEPENDENT, could be built independently (obj = `Quotient` of a `Setoid` on `Σ F, {q // Epi q ∧ IsLFOR F d}`; map = `Scheme.Modules.pullback`; needs pullback-preserves-Epi + local freeness + setoid-respect + map_id/map_comp). Substantial but parallelizable with the glue track.

## Blocked — do NOT re-assign without structural change

- **`genericFlatness` (FlatteningStratification)** — gated on G1 + G3, neither built. Do NOT dispatch the close.
- **G1 `gf_qcoh_fintype_finite_sections`** — reduces EXACTLY to per-`g` base case **`gf_qcoh_finite_sections_of_genSections`** (`IsAffineOpen D → F.IsQuasicoherent → (σ : ((pullback D.ι).obj F).GeneratingSections) → [σ.IsFiniteType] → Module.Finite Γ(X,D) Γ(F,D)`). This is the gap1-hard `X.Modules ↔ Spec` transport across `IsAffineOpen.isoSpec`, sub-steps: (a) transport to `(Spec Γ).Modules` via `isoSpec.inv` + `IsIso fromTildeΓ`; (b) free epi `σ.π` → `tilde N` epi (`N = R^{σ.I}` finite, iso-pullback finality + tilde preserves coproducts); (c) `moduleSpecΓFunctor.obj F' ≅ Γ(F,D)` as `Γ(X,D)`-modules. Then `gf_qcoh_finite_sections_of_free_epi` (DONE) closes it. **Dedicate a full iter** (gap1/gap2-level, historically one iter per sub-step). Effort-break (a)/(b)/(c) into separate sub-lemmas first.
- **G3 `gf_flat_locality_assembly`** — stalkwise flatness local-on-source; anchors `Module.flat_of_localized_maximal`, `flat_iff_of_isLocalization`, `Flat.of_free`, `IsLocalization.flat`, `Flat.trans`. Gap1-independent but substantial. Separate iter from G1.
- **`Scheme.Modules.glue` body** — blocked on the signature fix (TOP item 1); no Mathlib turn-key module descent exists.

## Reusable patterns discovered (also in PROJECT_STATUS Knowledge Base)
- EXPLICIT `PreservesColimitsOfSize` arg beats instance search through `def`-backed `X.Modules`/`pullback`.
- `leftAdjoint_preservesColimits` universe metavars pin via explicit-arg expected type, not `haveI :=`.
- Sheaf-of-modules linear combinations go through **biproducts** (`(unit R).sections` has no module instance); `HasFiniteBiproducts` not global → `of_hasFiniteProducts`.
- `IsFiniteType` anon constructor defaults universes to 0 → state finiteness-transport as a *theorem* whose return type pins universes.
