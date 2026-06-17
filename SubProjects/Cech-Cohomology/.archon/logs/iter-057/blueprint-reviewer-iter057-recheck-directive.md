# Blueprint-reviewer directive — iter-057 SCOPED RE-REVIEW (fast path)

This is a SCOPED re-review to clear the HARD GATE for `CechSectionIdentification.lean`,
`AffineSerreVanishing.lean`, and `CechAcyclic.lean` (all covered by the consolidated chapter
`Cohomology_CechHigherDirectImage.tex`). Focus on that ONE chapter and confirm whether the four
must-fix findings from your iter-057 full review are now resolved.

Since your prior full audit (slug `iter057`), a blueprint-writer + an effort-breaker + a blueprint-clean
edited `Cohomology_CechHigherDirectImage.tex`. Verify each must-fix is resolved:

1. **`lem:cechSection_complex_iso`** — should now state `D ≅ D'_aug` (augmented complex
   `(sectionCechComplex U'·).augment ε hε`), NOT the false `D ≅ D'`. The mis-spec `% NOTE:` should be
   gone, proof sketch should cover the degree-(−1) augmentation identity + augmentation-map correspondence.

2. **`lem:cechSection_contractible`** — should now state `Homotopy (𝟙 D'_aug) 0` (augmented), with an
   EXPLICIT degree-0 augmentation-node argument (h⁻¹ = π_{i_fix} projection; the `ε∘π_{i_fix} + engine
   deg-0 = id` sheaf-equalizer computation), not delegated to the degrees-≥1 `depHomotopy` engine.

3. **`lem:affine_serre_vanishing_general_open`** — its proof's condition (3) should no longer claim "the
   same quasi-coherent seed"; it should route through the NEW `lem:affine_cech_vanishing_general_seed`
   (change-of-ring to `S=Γ(V)` via `M⊗_R S`, route B1), which should be a complete new block with a
   formalizable proof sketch.

4. **Coverage debt** — the 7 isolated helpers should now have blueprint blocks
   (`def:affine_cover_system_general`, `lem:standard_cover_cofinal_affine`,
   `lem:affine_surj_of_vanishing_affine`, `lem:isAffineOpen_specBasicOpen`,
   `lem:affine_cech_vanishing_general_of_tildeVanishing`, `lem:affine_serre_vanishing_general_of_seed`,
   `lem:affine_serre_vanishing_general_of_tildeVanishing`), `jShriekOU_homEquiv_nat` wired into
   `lem:absolute_cohomology_zero_natural`, and the dead `CechAcyclic.affine` documented by a `% NOTE`.
   Also confirm the effort-breaker's Stub-1 split is coherent (`lem:cechBackbone_obj_widePullback`,
   `lem:coproduct_distrib_fibrePower`, `lem:widePullback_openImm_inter` + the re-pointed
   `lem:cech_backbone_left_sigma`), with valid `\uses{}` and at least one-line proof sketches.

Report a single `complete:`/`correct:` verdict for `Cohomology_CechHigherDirectImage.tex` and an explicit
must-fix list (empty if the gate is clear). Build-target `% NOTE:` lines on not-yet-existing Lean decls
(`cechSection_complex_iso`/`cechSection_contractible` re-signed forms,
`sectionCech_homology_exact_of_affineOpen`, the Stub-1 sub-lemmas) are EXPECTED and are NOT must-fix items
— they are legitimate prover build targets. You may read the whole blueprint for cross-chapter consistency,
but the verdict that matters this round is for this one chapter.
