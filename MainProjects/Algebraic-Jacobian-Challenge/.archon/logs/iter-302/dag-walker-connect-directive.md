# DAG Walker Directive

## Slug
connect

## Seed
def:Jacobian  (`AlgebraicGeometry.Jacobian`, the project goal). You are NOT walking
its existing cone — you are CONNECTING detached clusters INTO it. Treat the goal's
ancestor cone as the target the clusters below must join.

## Mission (USER directive: "all nodes should be connected through dependencies")
After this iteration's helper-wiring, the blueprint graph has **19 connected
components**: one giant 828-node cone rooted at the goal, plus **18 detached
clusters** that are internally connected but never `\uses{}`-linked UP into the
goal cone. These are genuine *untranscribed dependencies* (criterion 8): the
mathematics/Lean depends on them but no consumer block declares the edge. Your job:
for each cluster below, add the **REAL statement-level `\uses{}` bridge** from its
true consumer (identified below from the Lean import graph + STRATEGY) so the
cluster joins the goal's ancestor cone. leandag counts **statement-level `\uses`
only** (a `\uses` inside `\begin{proof}` is ignored as a graph edge) — put bridge
edges in the consumer's STATEMENT block.

**Hard rule — no fabricated ancestry.** Add an edge only where the consumer
genuinely depends on the cluster (confirm by reading the consumer's `.lean` and/or
the STRATEGY slice given per cluster). If a cluster's only honest consumer is a
PROTECTED chapter (`Jacobian.tex`, `AbelJacobi.tex`, `Genus.tex` — you may NOT edit
these), do NOT force an edge: record the needed edge under "Notes for dispatcher"
for routing to the mathematician. Prefer wiring to the most specific non-protected
consumer.

## Clusters and their intended consumers (add the bridge `\uses{}` edge)

1. **Cohomology `R^i f_*` engine** — clusters:
   `Cohomology_HigherDirectImage` (tops `thm:flat_base_change_higher`,
   `thm:flat_base_change_pushforward`, `lem:higher_direct_image_quasi_coherent`),
   `Cohomology_FlatBaseChange`, `Cohomology_CechHigherDirectImage`
   (tops `lem:cech_computes_cohomology`, `def:cech_higher_direct_image`,
   `lem:cech_flat_base_change`).
   STRATEGY: this is the A.2.c engine — `R^i f_*` computes the cohomology the Quot/
   Hilbert boundedness and flattening consume. Consumer chapter: `Picard_QuotScheme`
   (`lem:quot_boundedness` L555, `lem:quot_reduction_to_pi_star_W` L477,
   `def:hilbert_polynomial` L62) and/or `Picard_FlatteningStratification`
   (`thm:generic_flatness` L162, `lem:flat_locus_open` L357). Read those Lean files
   to confirm which invokes higher direct images / flat base change, and add the
   bridge there. Also wire the three cohomology clusters to EACH OTHER where Lean
   shows it (`CechHigherDirectImage` imports `HigherDirectImage`).

2. **Relative Spec** (`Picard_RelativeSpec`, tops `thm:relative_spec_exists`,
   `thm:relative_spec_univ`, `thm:relative_spec_base_change`). STRATEGY: relative
   Spec underlies the relative-affine constructions in the Picard/Quot engine and
   `Picard_LineBundlePullback`/`Picard_RelPicFunctor`. Find the consumer block whose
   Lean uses `relativeSpec`/`RelativeSpec` and add the bridge; if none consumes it
   yet in a non-protected chapter, note it.

3. **Sheaf-of-modules over-equivalence** (`Picard_SheafOverEquivalence`) — currently
   FOUR sub-clusters (`def:sheafofmodules_over_equivalence`+`lem:chart_over_iso`;
   `def:phi_over`/`def:over_forget_nat_iso`; `def:psi_over`; `def:psi_restrict`;
   continuity defs). First wire these INTERNALLY: `def:sheafofmodules_over_equivalence`
   / `def:linebundle_chart_over_iso` should `\uses{}` their building blocks
   (`def:phi_over`, `def:psi_over`, `def:psi_restrict`, the continuity defs,
   `lem:sheafofmodules_restrict_over_iso`, `lem:sheafofmodules_unit_over_iso`).
   Then bridge to the consumer: `Picard_LineBundleCoherence` (Lean-confirmed importer;
   block near L209/L265 already *comments* `Scheme.Modules.chartOverIso` /
   `lem:chart_over_iso` — promote that to a statement-level `\uses{lem:chart_over_iso}`).

4. **Auslander–Buchsbaum / projective dimension** (`Albanese_AuslanderBuchsbaum`,
   `def:projective_dimension` + the `hasProjectiveDimensionLT_*` lemmas) AND the
   **Krull-dimension / regular-sequence cluster** (`Albanese_CodimOneExtension`
   `lem:ringKrullDim_*`, `lem:mvPolynomial_maximalIdeal_height_*`,
   `lem:matsumura_*`, `lem:isRegular_cons_*`, `lem:quotSMulTop_*`,
   `lem:submersive_relation_cotangent_*`). Consumer (Lean-confirmed: CodimOneExtension
   imports AuslanderBuchsbaum): `lem:smooth_algebra_krull_dim_formula`
   (`Albanese_CodimOneExtension` L384) and the cotangent/codim-1 lemmas around it.
   Add statement-level `\uses{}` from that formula (and the codim-1 extension theorem)
   to the cluster tops it actually invokes.

5. **Rigidity chart lemmas** (`AbelianVarietyRigidity` `lem:awayi_*`,
   `def:mvpoly_*`, `lem:affineLine_geomIrred`, `lem:isDomain_mvPolyUnit_tensor`) and
   the Rigidity-over-`k` pair (`lem:S3_pi_1_*`, `lem:S3_sep_1_*`). These support the
   genus-0 / rigidity arm (Milne 3.2/3.10). Find the rigidity theorem in
   `Rigidity.tex`/`RigidityKbar.tex`/`AbelianVarietyRigidity.tex` that consumes the
   `awayi`/`mvpoly`/`S3` lemmas and add the bridge `\uses{}` at its statement.

6. **Cotangent localization pair** (`AlgebraicJacobian_Cotangent_GrpObj`
   `lem:kaehler_localization_subsingleton`, `lem:kaehler_quotient_localization_iso`)
   and **RR line-bundle local-unit lemma** (`RiemannRoch_OCofP`
   `lem:lineBundleAtClosedPoint_functionField_localUnit_of_orderZero_at_primeDivisor`):
   wire each to the block in its own chapter that uses it (these are likely
   one-edge fixes to a sibling lemma in the same chapter).

## Workflow
For each cluster: `archon dag-query node`/`ancestors` to see the sub-DAG, read the
named consumer block's `.lean` to CONFIRM the dependency, then add the
statement-level `\uses{<cluster-top-label>}` to the consumer's declaration block.
Re-query at the end; the component count must DROP materially. Report per-cluster:
edge added (and to which block) OR "no non-protected consumer — routed to notes".

## Scope
Add ONLY real statement-level `\uses` bridges (and the internal over-equivalence
wiring). Do not rewrite existing prose, do not edit protected chapters, do not
invent new lemmas. Wide write domain: `blueprint/src/chapters/*.tex`.

## References
- `.archon/STRATEGY.md` is summarized per-cluster above; the A.2.c engine row and the
  Routes section give the planned consumer chains. The clusters' own blocks already
  carry their source citations (Stacks/Nitsure/Kleiman/Milne) — you are adding edges,
  not re-deriving statements, so no new sources are required.
