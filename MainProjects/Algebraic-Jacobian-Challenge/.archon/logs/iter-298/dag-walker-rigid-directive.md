# DAG Walker Directive

## Slug
rigid-cluster

## Seed
chap:AbelianVarietyRigidity (and chap:Rigidity). The AbelianVarietyRigidity chapter has 113
nodes in the goal cone but 11 of its own helpers form 3 disconnected sub-clusters; the Rigidity
chapter has 23 in-cone nodes but 2 disconnected helpers. Wire all of them into their chapters.

## Strategy context
AbelianVarietyRigidity proves that a morphism from a genus-0 curve (P¹-bar) into an abelian
variety is constant (Milne Thm 3.2 / Prop 3.10, via bare rigidity, no Serre duality). It rests on
a `MvPolynomial`/Spec chart computation of the projective-line-bar charts and a geometric-irreducibility
input. Rigidity (over a base field k) is the group-scheme analogue (S3.pi / S3.sep cohomology and
separability inputs). The clusters below are the chart-affine and submersive-presentation engine
and the cohomology/separability inputs these theorems consume.

## Depth / scope
Read each chapter; for each cluster find the consuming theorem (the chart computations feed the
P¹-bar chart isomorphisms and the constancy theorem; the S3 lemmas feed the rigidity-over-k proof)
and add the missing `\uses{}` edges. Complete each helper's own `\uses{}`. Statements unchanged;
add `\uses{}` only (plus a missing block only if a `\uses` target has none).

### Clusters (Lean basenames; find blueprint labels)
AbelianVarietyRigidity:
- Chart-affine (5): awayi_appIso_top_inv_apply_isLocElem, awayi_app_basicOpen,
  awayi_eq_specMap_fromSpec, awayi_preimage_basicOpen_self, basicOpenIsoSpec_inv_app_top
- Submersive presentation (4): mvpoly_generators, mvpoly_presentation, mvpoly_presubmersive,
  mvpoly_submersive
- Geom-irred input (2): affineLine_geomIrred, isDomain_mvPolyUnit_tensor
Rigidity:
- S3 inputs (2): S3_pi_1_Gamma_baseChange_iso_tensor_of_proper,
  S3_sep_1_smooth_geometrically_reduced_Gamma

## References
- `references/abelian-varieties.md` (Milne, Thm 3.2 / Prop 3.10), `references/stacks-varieties.md`
  (035U geom-reduced, 0BUG H^0), `references/stacks-coherent.md` (02KH flat base change) — only if a
  statement needs a source. Prefer `\uses{}` wiring over rewrites.

## Out of scope
- Edit ONLY `blueprint/src/chapters/AbelianVarietyRigidity.tex` and
  `blueprint/src/chapters/Rigidity.tex`.
- No `\leanok`. Wiring (`\uses{}`) only, plus missing blocks if a `\uses` target is undefined.
