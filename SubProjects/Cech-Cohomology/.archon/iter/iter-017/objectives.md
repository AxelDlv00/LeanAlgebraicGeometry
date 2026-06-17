# Iter-017 objectives (detail)

## Lane 1 — `FreePresheafComplex.lean` [mathlib-build] — P3b free side
Build bottom-up:
- `coverStructurePresheaf` (`def:cover_structure_presheaf`): `O_𝒰 : X.PresheafOfModules`, the image
  presheaf of the augmentation `∐_i freeYoneda(coverOpen 𝒰 i) → PresheafOfModules.unit X.ringCatSheaf.obj`
  (O_X as a presheaf of modules). `O_𝒰(W) = O_X(W)` if W ≤ some U_i, else 0. Plus the augmentation chain
  map `cechFreePresheafComplex 𝒰 → (single₀).obj O_𝒰` (or an augmented complex).
- `cechFreeComplex_quasiIso` (`lem:cech_free_complex_quasi_iso`): the augmentation is a quasi-iso
  (K_• resolves O_𝒰). Route: homology computed sectionwise (`PreservesHomology (evaluation … V)` =
  inferInstance, validated iter-016); sectionwise `freeYoneda(V)(W) = O_X(W)` if W ≤ V else 0; prepend-
  `i_fix` contracting homotopy on the I₁/I₂-split extended complex, `dh+hd=id` (same combinatorial
  content as `CombinatorialCech.*`); `HomologicalComplex.Homotopy` ⇒ `HomotopyEquiv` ⇒ `toQuasiIso`.
- DEAD END: `SimplicialObject.Augmented.ExtraDegeneracy`.
- Blueprint: `def:cover_structure_presheaf`, `lem:cech_free_complex_quasi_iso` (proof sketch present).

## Lane 2 — `CechBridge.lean` (NEW, imports FreePresheafComplex) [mathlib-build] — P3b bridge
Build:
- `cechComplex_hom_identification` (`lem:cech_complex_hom_identification`): isomorphism of cochain
  complexes **of abelian groups** `Hom_{PMod}(cechFreePresheafComplex 𝒰, F) ≅ sectionCechComplex 𝒰 F`.
  Per-degree `Ab`-iso `(K(𝒰)_p ⟶ F) ≅ ∏_σ F(⨅σ)` from `freeYonedaHomAddEquiv` + coproduct-hom-as-product
  (`Hom(∐_σ A_σ, F) ≅ ∏_σ Hom(A_σ, F)` via `preadditiveYoneda` limit-preservation or hand-rolled
  `Sigma.desc`/`Sigma.ι`), intertwine differentials, `HomologicalComplex.Hom.isoOfComponents`.
- Target category Ab (matches `sectionCechComplex : CochainComplex Ab ℕ`). The `/- Planner strategy -/`
  comment in the scaffolded file restates the recipe.
- Blueprint: `lem:cech_complex_hom_identification`, `def:section_cech_complex`, `def:cech_free_presheaf_complex`.

## NOT dispatched this iter (rationale in plan.md)
- `CechAcyclic.lean` (P3) — redesigned this iter (Q4 re-sign to section-complex form; L1 →
  `def:qcoh_sections_localized` + `lem:section_cech_homology_exact`). Needs fresh gate + Lean re-sign
  refactor next iter, THEN the two L1 sub-lanes become mathlib-build dispatches.
- P5a `higher_direct_image_presheaf` (01XJ) — feasible (`analogies/p5a.md`); opens as a new-file lane
  next iter.
- `CechHigherDirectImage.lean` P5b — FROZEN/protected, blocked on all inputs.

## Validation snapshot (this iter)
- `archon dag-query unmatched` → 0/0 (19 helpers bundled).
- blueprint-reviewer `iter017` → HARD GATE clears free + bridge lanes; 0 must-fix.
- `lake build` green, 8325 jobs (after CechBridge scaffold + barrel wiring).
- frontier: `def:qcoh_sections_localized`, `lem:cech_acyclic_affine` (re-stated), `def:cover_structure_presheaf`,
  `lem:ses_cech_h1`, `lem:higher_direct_image_presheaf`.
