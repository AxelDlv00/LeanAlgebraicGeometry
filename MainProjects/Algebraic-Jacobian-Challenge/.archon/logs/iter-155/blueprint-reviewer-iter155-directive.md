# Blueprint Reviewer Directive

## Slug
iter155

## Strategy snapshot

Goal: formalize Christian Merten's Jacobian challenge — existence of an
Albanese/Jacobian object uniform over the k-rational pointing of a smooth
proper geometrically irreducible curve C/k, **no** `C(k) ≠ ∅` hypothesis on
the protected signature (`AlgebraicGeometry.Jacobian`,
`Jacobian.nonempty_jacobianWitness`). End-state: zero `sorry`, kernel-only axioms.

Spine = pointed-vs-unpointed. The genus-0 universal property is the non-vacuous
**Route C rigidity** content, proved over an algebraically closed base `k̄` then
descended to a general base `k`.

**Iter-154 milestone:** the chart-algebra ring/chart envelope is now CLOSED.
`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (KDM) closed axiom-clean
(project 8→7), joining `constants_integral_over_base_field` (closed iter-153) and
the sorry-free delegate `df_zero_factors_through_constant_on_chart`. So all the
RING/CHART-LEVEL pieces of "df=0 ⟹ f factors through Spec k" are done.

**This iter's transition:** the critical path moves to the SCHEME-LEVEL rigidity
assembly. Two candidate prover targets, both in `ChartAlgebra.lean` /
`RigidityKbar.lean`, both backed by `RigidityKbar.tex`:

  (T1) `Scheme.Over.ext_of_diff_zero` β-chain refinement — currently a THIN
       renaming of `ext_of_eqOnOpen` (consumes `eqOnOpen` directly). The
       blueprint's `lem:Scheme_Over_ext_of_diff_zero` proof block (Steps 1–3,
       around L2521–2547 of RigidityKbar.tex) is the substantive recipe:
       define `h := μ ∘ ⟨f, ι∘g⟩`, show `dh = 0`, apply `df_zero_factors`
       chart-by-chart, conclude `h` factors through `Spec k`. Was gated on KDM,
       now unblocked.

  (T2) `rigidity_over_kbar` (RigidityKbar.lean:88) full body — the M2.a keystone.
       Proof decomposition C.2.b–C.2.e in RigidityKbar.tex § "Proof decomposition".

## Routes

- **Route C (M2 critical path)** — chart-algebra piece (ii) over `[IsAlgClosed kbar]`.
  Chapters: `RigidityKbar.tex` (the consolidated chart-algebra + rigidity chapter),
  `AlgebraicJacobian_Cotangent_GrpObj.tex`, `Rigidity.tex`,
  `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` (DESCOPED/orphaned).
- **Route A (M3 off-critical-path)** — Picard scheme via FGA. Chapter: `Jacobian.tex`
  § "Route A". Not active this iter.

## References
- `references/challenge.lean.ref`: authoritative signatures for the 9 protected decls.
- `references/stacks-*.md`: Stacks tags backing the chart/separability lemmas.
- `references/kleiman-picard.pdf`, `references/nitsure-hilbert-quot.pdf`: Route A.

## Focus areas (extra attention this iter — do NOT skip the others)

1. **`RigidityKbar.tex` — is the SCHEME-LEVEL rigidity content prover-ready?**
   This is the decisive question for this iter's prover dispatch. Specifically:
   - (T1) Is the `lem:Scheme_Over_ext_of_diff_zero` proof (Steps 1–3) detailed
     enough for a prover to formalize the substantive β-chain refinement?
     I am specifically worried that **Step 2's chart-by-chart sheaf-assembly
     globalisation is hand-waved** ("such chart pairs exist by quasi-compactness…
     chart-uniform existence is automatic from the smoothness of A.hom") and that
     **Step 1's lift of Kähler-additivity to the scheme level** cites
     `lem:GrpObj_mulRight_globalises` which (per the iter-144 pivot prose) was
     DESCOPED. Are these load-bearing steps actually backed by present, named
     Mathlib/project lemmas, or are they prose hand-waves a prover cannot close?
   - (T2) Does the C.2.b–C.2.e decomposition of `thm:rigidity_over_kbar` give a
     prover a concrete path? In particular: **how is `df = 0` (equivalently the
     `df = dg` hypothesis fed to `ext_of_diff_zero`) ESTABLISHED for a morphism
     `f : C → A`?** Classically this needs `Ω_{A/k}` cotangent-triviality — the
     "piece (i)" of the shared cotangent-vanishing pile, which the iter-144 chart-
     algebra pivot DESCOPED. If the blueprint does not supply df=0 from present
     material, T2 is NOT prover-ready and needs a writer round; please say so
     explicitly and name what is missing. Also: the C.2.c image-dimension
     dichotomy (irreducible image of a proper map, scheme dimension) — is the
     Mathlib infrastructure named and present?
   - Verify the `\lean{...}` targets in this chapter resolve to real decls with
     matching signatures (KDM, `constants_integral_over_base_field`,
     `df_zero_factors_through_constant_on_chart`, `ext_of_diff_zero`,
     `rigidity_over_kbar`, `ext_of_eqOnOpen`).

2. **`AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex`** — its `.lean` file is fully
   orphaned (imported only by `ChartAlgebra.lean`, which consumes NONE of it; 4
   off-path sorries). The iter-154 review recommends DELETING `ChartAlgebraS3.lean`.
   Please report whether this chapter is safe to remove / demote: does any OTHER
   chapter `\cref` or `\uses` a label defined in it (a cref cascade that would break
   on deletion)? List any inbound cross-references so I can plan the refactor.

## Known issues (do not re-report)
- KDM and `constants_integral_over_base_field` are CLOSED and axiom-clean — no need
  to re-audit their proof blocks for soundness.
- STRATEGY.md format drift (per-iter narrative) is the plan agent's concern, not yours.
- Stale `\uses{}` at the KDM statement block (L2340-ish, `lem:chart_algebra_isPushout…`
  + `lem:KaehlerDifferential_constants_in_chart…`) is already flagged SOON for a
  writer prune — note it if you wish but it is known.
