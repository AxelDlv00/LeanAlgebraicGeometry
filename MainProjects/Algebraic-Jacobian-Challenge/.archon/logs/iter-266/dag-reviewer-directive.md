# Blueprint-reviewer directive — whole-blueprint audit (DAG iter-266)

Audit the WHOLE blueprint as usual (per-chapter checklist + dependency &
isolation findings). This DAG iteration eliminated all blueprint-labelled
leandag ∞-nodes by adding/redistributing informal proof blocks. Pay particular
attention to the correctness and `\uses{}` completeness of the newly added proofs
in these chapters:

- `Picard_IdentityComponent.tex` — the two combined proofs were SPLIT into
  per-theorem `\begin{proof}` blocks for `thm:identity_component_is_subgroup_homomorphism`,
  `thm:identity_component_finite_type_geom_irreducible`,
  `thm:identity_component_base_change_commutes`, `thm:pic_zero_is_abelian_variety`,
  `thm:pic_zero_dimension_equals_genus`. Confirm no mathematical content was lost
  in the split and each proof's `\uses{}` is accurate. Also confirm the
  `\lean{}` fix for `lem:geometricallyConnected_of_connected_of_section`
  (namespace corrected to `AlgebraicGeometry.GroupScheme.…`).
- `RigidityKbar.tex` — new assembled proof of `thm:rigidity_over_kbar`.
- `Picard_FlatteningStratification.tex` — new assembled proof of
  `thm:flattening_stratification_exists`.
- `Albanese_CodimOneExtension.tex` — new proof of
  `lem:smooth_algebra_krull_dim_formula` (Stacks 00OE).
- `Cohomology_StructureSheafModuleK.tex` — short specialisation proof added to
  `thm:Scheme_module_finite_HModule_prime_of_affine_curve`.
- `Cohomology_MayerVietoris.tex` — the vestigial umbrella lemma
  `lem:Scheme_AffineCoverMVSquare_corners` (no `\lean{}`, no consumers,
  duplicated the four `…_X1…X4` corner lemmas) was REMOVED. Confirm this removal
  is sound and nothing references the deleted label.

Report your standard per-chapter `complete`/`correct` verdicts, any must-fix
findings, and the `### Dependency & isolation findings` section.
