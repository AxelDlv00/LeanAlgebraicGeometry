# Strategy Critic Directive

## Slug
ftthree-derisk

## What to read (and ONLY this)

Read **only** the following. Do NOT read iter sidecars, task_results, prover
reports, review reports, or session journals — your value is a fresh view of
the strategy, uncontaminated by the project's recent momentum.

1. `.archon/STRATEGY.md` — the current strategy, verbatim from disk (just
   edited this iter). This is your primary object of critique.
2. The reference index and blueprint summary inlined below.
3. The project goal, inlined below.

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge
(`references/challenge.lean.ref`): nine protected declarations, headlined by
`AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` — the
existence of an Albanese/Jacobian object uniform over the `k`-rational
pointing of a smooth proper geometrically irreducible curve `C/k`, with NO
`C(k) ≠ ∅` hypothesis on the protected signature. End-state: zero inline
`sorry`, kernel-only axioms.

## Reference index (references/summary.md)

| File | Description |
| ---- | ----------- |
| `challenge.lean.ref` | Merten's formal challenge file; authoritative signatures. |
| `stacks-varieties.md` | Stacks ch.33 "Varieties" — tags 035U, 04QM/056T, 0BUG. Backs (S3.sep.*). |
| `stacks-fields.md` | Stacks ch.9 "Fields" — 09HD, 030K. Backs (S3.pi.2). |
| `stacks-algebra.md` | Stacks ch.10 "Commutative Algebra" — 00T7 (standard smooth ⇒ Ω free). |
| `stacks-coherent.md` | Stacks ch.30 "Cohomology of Schemes" — 02KH (flat base change of R^i f_*). |
| `kleiman-picard.md` | Kleiman, "The Picard scheme" (FGA Explained). Route A source. |
| `nitsure-hilbert-quot.md` | Nitsure, "Construction of Hilbert and Quot Schemes". Route A engine. |

## Blueprint summary (chapter : one-line topic)

- `AbelJacobi.tex` : The Abel–Jacobi map.
- `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` : Chart-algebra (S3) sub-claims (descoped off-path).
- `AlgebraicJacobian_Cotangent_GrpObj.tex` : Cotangent space at the identity (piece (i)).
- `Cohomology_MayerVietoris.tex` : Mayer–Vietoris LES for sheaf cohomology with k-module coefficients.
- `Cohomology_SheafCompose.tex` : Sheaf condition along the structure-sheaf forget composite.
- `Cohomology_StructureSheafAb.tex` : Structure sheaf as a sheaf of abelian groups.
- `Cohomology_StructureSheafModuleK.tex` : Sheaves of k-modules; structure sheaf as a sheaf of k-modules.
- `Differentials.tex` : The relative cotangent presheaf.
- `Genus.tex` : Genus of a smooth proper curve.
- `Jacobian.tex` : The Jacobian as an abelian variety.
- `Rigidity.tex` : Rigidity for morphisms of schemes (scheme-level form).
- `RigidityKbar.tex` : Rigidity over a base field; genus-0 curve → group scheme is constant (Route C critical path; holds the KDM ring-side lemma).

## What changed this iter (so you can focus your critique)

STRATEGY.md was edited this iter to record a single de-risking finding: the
chart-algebra critical-path lemma KDM
(`mem_range_algebraMap_of_D_eq_zero`), whose residual step FT.3 had been
treated since iter-149 as a research-grade **Mathlib gap** behind a
bright-line, was found by a `mathlib-analogist` consult to be fully
assemblable from existing Mathlib via a compilation-verified single-element /
`H1Cotangent` / perfect-field route (~100–150 LOC). Consequently: the
bright-line was lifted, the phase estimate revised from "3–5 iters /
150–350 LOC" to "1–2 iters / ~100–150 LOC", and the gap was reclassified
from "Mathlib gap" to "project assembly".

## Your task

Give STRATEGY.md a fresh-eyes critique. In particular:

- Is the route structure still sound (pointed-vs-unpointed spine; Route C
  critical path over `[IsAlgClosed k̄]` with `k̄→k` descent; Route A
  off-critical-path)? Is anything inconsistent after this iter's edits?
- Is the revised "1–2 iters / ~100–150 LOC" estimate honest, or is it
  optimistic given the route is verified only at the `example`-skeleton level
  (not yet assembled into the single lemma with all scalar-tower instances)?
- Are there sunk-cost or framing problems anywhere in the strategy you would
  challenge as a fresh mathematician?
- Format/consistency: is the file within the ~250-line / ~12 KB bound, free
  of per-iter narrative creep, and internally consistent (phases table vs
  Routes vs gaps section)?

Render SOUND / CHALLENGE / REJECT per the usual rules, with explicit,
actionable findings.
