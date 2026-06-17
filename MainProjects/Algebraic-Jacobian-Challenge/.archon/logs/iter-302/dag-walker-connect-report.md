# DAG Walker Report

## Slug
connect

## Seed
def:Jacobian (project goal) — mission was CONNECTING the 18 detached clusters
into the goal's component, not walking its existing cone.

## Status
COMPLETE — graph is now a single connected component.

## Cone before → after
- **Connected components: 19 → 1** (giant 828 + 18 detached → one 931-node component).
- leandag edges: 1619 → 1648 (+29 statement-level `\uses` edges across 13 blocks).
- broken `\uses` introduced: 0 (`leandag build` reports `unknown_uses: []`).
- DAG remains **acyclic** (Kahn topo-sort: 931/931); no `thm↔lem` web cycle created.
- Goal **directed** ancestor cone: 277 → 341 (the engine consumers I wired are
  genuine goal-ancestors; a few honestly-consumer-less leaves join undirected only — noted below).

## \uses bridge edges added (per cluster)

### C1 — Cohomology R^i f_* engine (graph clusters 1 + 3)
- `thm:flat_base_change_cohomology` (Picard_QuotScheme, Stacks 02KH, giant cone)
  now `\uses{thm:flat_base_change_higher, thm:flat_base_change_pushforward,
  lem:higher_direct_image_quasi_coherent}` — this stub stated 02KH but declared no
  ancestry; the HigherDirectImage/FlatBaseChange engine *is* its proof. Merges the
  23-node HigherDirectImage+FlatBaseChange cluster.
- `thm:flat_base_change_higher` (Cohomology_HigherDirectImage) now also
  `\uses{lem:cech_computes_cohomology, lem:cech_flat_base_change}` — its written
  proof computes via Čech complexes (explicit "separated case via Čech complexes").
  Merges the 14-node CechHigherDirectImage cluster (Cech imports HigherDirectImage
  in Lean; Cech is the computational ingredient of the flat-base-change proof).

### C2 — Relative Spec (graph cluster 2, 16 nodes)
- `thm:grassmannian_representable` (Picard_QuotScheme) now
  `\uses{def:grassmannian_scheme, thm:relative_spec_exists, thm:relative_spec_univ}`.
  QuotScheme.tex's own dependency summary (L1574–1577) states the file "directly
  consumes Picard_RelativeSpec for relative-spectrum gluing infrastructure"; the
  Grassmannian is glued from relative-affine charts and its representability uses
  the same `RepresentableBy` pattern as relative Spec (L1540–1543).

### C3 — Sheaf-of-modules over-equivalence (graph clusters 6,10,14,15,16)
Internal wiring (confirmed against SheafOverEquivalence.lean):
- `def:sheafofmodules_over_equivalence` now `\uses{def:phi_over, def:psi_over,
  def:over_equiv_functor_is_continuous, def:over_equiv_inverse_is_continuous}`
  (`overEquivalence := pushforwardPushforwardEquivalence e (phiOver) (psiOver)` + the
  two continuity instances).
- `lem:sheafofmodules_restrict_over_iso` now also `\uses{def:phi_over,
  def:psi_restrict, def:over_forget_nat_iso}` (`restrictOverIso` = pushforwardComp
  (phiOver)(psiRestrict) ∘ pushforwardNatIso(overForgetNatIso)).
- `lem:sheafofmodules_unit_over_iso` now also `\uses{def:phi_over}` (unitOverIso is
  the inverse unit-comparison of `phiOver`).
Bridge into giant cone:
- `lem:lbc_chart_presentation` (Picard_LineBundleCoherence, giant) now
  `\uses{..., def:linebundle_chart_over_iso}` — its proof transports the unit
  presentation along the chart iso; the in-block NOTE already named
  `Scheme.Modules.chartOverIso` as the bridge. Now promoted to a real edge.

### C4 — Auslander–Buchsbaum / Krull-dim / regular-seq (graph clusters 4,7,9,17)
- `lem:smooth_algebra_krull_dim_formula` (Albanese_CodimOneExtension, giant)
  STATEMENT `\uses` now carries the set its **proof block** already declared:
  `lem:ringKrullDim_localization_atMaximal_mvPolynomial`,
  `lem:ringKrullDim_quotient_localization_mvPolynomial_regular` (cluster 4),
  `lem:matsumura_isRegular_of_linearIndependent_cotangent` (cluster 9),
  `lem:submersive_relation_cotangent_linearIndependent_localized` (cluster 17),
  plus the two already-giant ingredients. leandag counts statement-`\uses` only, so
  these were invisible edges — promotion merges clusters 4, 9, 17.
- `lem:auslander_buchsbaum_formula_succ_pd` (Albanese_AuslanderBuchsbaum, giant)
  STATEMENT now also `\uses{lem:projectiveDimension_ker_eq_of_surjection}` — the
  syzygy/exact-pd input its proof block lists ("the exact-pd input that licenses the
  inductive hypothesis on ker f"). Merges cluster 7 (projective-dimension substrate).
  (Did NOT re-add `thm:auslander_buchsbaum` — that was the iter-283 cycle.)

### C5 — Rigidity chart lemmas (graph clusters 5,8,12,13)
- `lem:kbarChart1Ring_specMap_fac` (AbelianVarietyRigidity) now also
  `\uses{lem:awayi_appIso_top_inv_apply_isLocElem}` — its Lean rewrites by
  `Proj.awayι_appIso_top_inv` (AbelianVarietyRigidity.lean:437). Merges cluster 5.
- `lem:mvPolynomialFin_isStandardSmoothOfRelativeDimension` now
  `\uses{def:mvpoly_submersive}` — built from `mvPolySubmersivePresentation`
  (BareScheme.lean:207). Merges cluster 8.
- `lem:gm_geomIrred` now also `\uses{lem:affineLine_geomIrred}` — instance
  `gm_geomIrred` applies `affineLine_geomIrred` (GmScaling.lean:1041). Merges cluster 12.
- `lem:constants_integral_over_base_field` (RigidityKbar) now
  `\uses{lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper}` — its proof uses flat
  base change of Γ (Γ(X)⊗_k k̄ ≅ Γ(X_k̄)); RigidityKbar.tex L2362 explicitly says the
  S3 dependence "is supplied in the proof of constants_integral_over_base_field".
  Merges cluster 13.

### C6 — Cotangent-localization + RR local-unit pairs (graph clusters 11,18)
- `lem:GrpObj_cotangent_bridge` (RigidityKbar, giant) now also
  `\uses{lem:kaehler_localization_subsingleton}` — its proof Step 1 (L419)
  "Localisation kills relative differentials … used already as
  lem:kaehler_localization_subsingleton". Merges cluster 11.
- `lem:lineBundleAtClosedPoint_functionField_const_of_complete_curve_of_orderZero`
  (RiemannRoch_OCofP, giant) now also
  `\uses{lem:lineBundleAtClosedPoint_functionField_localUnit_of_orderZero_at_primeDivisor}`
  — `functionField_const_…` calls `functionField_localUnit_…` (OCofP.lean:1509).
  Merges cluster 18.

## Could not complete (genuine gaps — strategy items)
None blocking connectivity. Two honestly-consumer-less nodes joined the component
**undirectedly only** (they are leaves, not goal-ancestors), which is correct and not
something to force:
- `lem:kaehler_quotient_localization_iso` — Differentials.tex L150 explicitly records
  it as standalone Mathlib-PR material with "zero in-tree consumers" (the bridge that
  would consume it was excised iter-126). It connects via its intra-cluster edge to
  `lem:kaehler_localization_subsingleton`. No honest goal-ancestor edge exists; not forced.
- `lem:S3_sep_1_smooth_geometrically_reduced_Gamma` — connects via the
  `S3_sep_1 → S3_pi_1` edge. Its "Γ geometrically *reduced*" content is not used by
  the geometrically-*irreducible* `constants_integral` proof, so no further honest
  ancestor edge was added.

## Verification
- `leandag build`: blueprint_nodes 932, edges 1648, isolated 0, `unknown_uses: []`.
- Connected components: **1** (was 19). All 18 detached clusters merged.
- Acyclic: Kahn topo-sort 931/931. No web-crash cycle (avoided thm↔lem back-edges).

## Notes for dispatcher
- All bridges are genuine consumer→provider edges confirmed against the consumer's
  `.lean` (call sites cited above) or the consumer block's own dependency-summary
  prose. No protected chapter (Jacobian/AbelJacobi/Genus) was edited.
- The directive guessed cluster-11's consumer would be a same-chapter sibling in
  "AlgebraicJacobian_Cotangent_GrpObj"; the genuine consumer is
  `lem:GrpObj_cotangent_bridge` in RigidityKbar.tex (its proof uses the lemma).
  Note that block is `\notready` / vestigial on the live path — the edge is honest
  but the consumer itself is a leaf, so cluster-11 joins undirected only.
- C4's fix is a pure statement-`\uses` promotion of facts the proof blocks already
  listed — a recurring pattern (see [[ts302-leandag-statement-uses-only]]); other
  ∞/under-wired nodes likely have the same latent edges in their proof blocks.
