# Strategy Critic Directive

## Slug
iter113

## Project goal

Formalize the Jacobian of a smooth proper geometrically irreducible curve over
a field, per Christian Merten's AI challenge (`references/challenge.lean`).
The 9 protected declarations in `archon-protected.yaml` are the contract:

```
AlgebraicJacobian/Genus.lean:
  - AlgebraicGeometry.genus
AlgebraicJacobian/Jacobian.lean:
  - AlgebraicGeometry.Jacobian
  - AlgebraicGeometry.Jacobian.instGrpObj
  - AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus
  - AlgebraicGeometry.Jacobian.instIsProper
  - AlgebraicGeometry.Jacobian.instGeometricallyIrreducible
AlgebraicJacobian/AbelJacobi.lean:
  - AlgebraicGeometry.Jacobian.ofCurve
  - AlgebraicGeometry.Jacobian.comp_ofCurve
  - AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp
```

The final theorem: these protected declarations carry the intended mathematical
content with the named-deferred Mathlib gaps disclosed honestly.

## Strategy under review

The strategy file `.archon/STRATEGY.md` is unchanged from iter-112 (when the
prior strategy-critic CHALLENGE landed and the planner addressed it via the
Phase B scope-rationale paragraph + load-bearing-vs-orphan split). For your
review, please read `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`
directly. The key content is:

- **Phases A–E** estimation table (top): Phase A DEFERRED (gated), Phase B
  ~4–8 iters / ~200 LOC remaining (3 prover-viable sorries), Phase C0/C3
  deferred, C1 DONE iter-109, C2 ~0–4 iters, D/E 0 LOC.
- **Scope rationale (iter-112)**: Phase B work is *blueprint-completeness
  commitment*, not protected-chain blocking; the alternative
  trim-to-protected-only was explicitly rejected.
- **7 named Mathlib-gap sorries + 1 budget-deferral**: enumerated under
  "Aggregate". The 7 named gaps split into 1 load-bearing on protected
  (`nonempty_jacobianWitness`) + 6 orphan disclosure + 1 budget-deferral
  (Option (i) on `BasicOpenCech.lean` L1846).
- **What's unconditional vs framework-conditional**: explicit enumeration
  added iter-109/iter-110 (Rigidity unconditional; Jacobian protected
  signatures framework-conditional on `nonempty_jacobianWitness`; Pic-and-
  down arc framework-conditional on `instIsMonoidal_W` + sister pair).
- **Phase A escape-valve menu**: RESOLVED iter-108 with Option (i).
- **Phase C3 exit policy**: adopted iter-107.
- **End-state**: 9 protected declarations compile against the named
  Mathlib-gap sorries + 1 budget-deferral.
- **Mathlib gaps in scope**: table at bottom.
- **Path from today**: Phase B prover work in dispatch order (L122 first;
  L735 second; L718 last); Phase C2 verification round.
- **Soundness rule**: no helper with universally-false signature, even
  with `sorry` body.

## References index

```
| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

## Blueprint summary

- `AbelJacobi.tex` — Abel–Jacobi morphism `ofCurve : C → Jac(C)` and its properties.
- `Cohomology_MayerVietoris.tex` — Mayer–Vietoris LES for Čech cohomology of basic-open covers.
- `Cohomology_SheafCompose.tex` — sheaf condition compatibility with forgetful functor composition.
- `Cohomology_StructureSheafAb.tex` — abelian-group sheaf structure on `O_X`.
- `Cohomology_StructureSheafModuleK.tex` — `k`-module sheaf structure on `O_C` over base field `k`.
- `Differentials.tex` — Kähler differentials `Ω_{X/S}`, cotangent exact sequence, smoothness criterion, Serre duality genus equality.
- `Genus.tex` — definition `g(C) = dim_k H^1(C, O_C)`.
- `Jacobian.tex` — Jacobian variety `Jac(C)` modulo `JacobianWitness` exit policy.
- `Modules_Monoidal.tex` — monoidal structure on `X.Modules` (post-C1 load-bearing).
- `Picard_Functor.tex` — Picard functor and representability.
- `Picard_FunctorAb.tex` — additive-group structure on Picard functor.
- `Picard_LineBundle.tex` — refined `LineBundle X := (Skeleton X.Modules)ˣ`.
- `Rigidity.tex` — Mumford rigidity for `Pic⁰`.

## Prior critique status

**Iter-112 strategy-critic returned SOUND-with-CHALLENGE**: 1 CHALLENGE on
Phase B scope rationale ("~4–8 iters of L122/L735/L718 work scheduled
without explicit goal-tie to the 9 protected declarations after the C3
exit policy decoupled the protected chain from Picard"). **Addressed in
iter-112 STRATEGY.md edits**: (a) added scope-rationale paragraph naming
Phase B as blueprint-completeness commitment; (b) added
load-bearing-vs-orphan split of the 7 named gaps. Two alternatives
raised: trim-to-protected-only (major; explicitly rejected with
rationale) and tighten "7 named gaps" disclosure (minor; addressed via
the split). Prerequisite spot-checks: `IsLocalizedModule.{Away, pi}`,
`isSheafOpensLeCover`, `Skeleton`-monoidal all VERIFIED; no phantoms.

**Strategy unchanged iter-112 → iter-113.** Re-verify: are the iter-112
strategy edits adequate, or is there a residual challenge the planner
should address this iter?

Pay particular attention to:

- **Whether the Phase B scope (3 prover-viable sorries shipping
  blueprint-completeness, not protected-chain blocking) remains
  justifiable** when the next iter is closing a 100–200 LOC sub-lemma
  pair on a single L122 helper. Is this the right slice of work given
  the protected chain only requires `nonempty_jacobianWitness`?
- **Whether the load-bearing-vs-orphan disclosure framing remains
  honest**: with the iter-112 review's pre-existing signature
  mismatches (smooth_iff/cotangent_at_section/serre_duality_genus)
  surfaced, is the protected-chain story still 1 load-bearing + 6
  orphan, or does the mismatch on `serre_duality_genus` (the equation
  is `H^0 = H^0` not `H^0 = H^1`) suggest the named-deferred status of
  gap #7 was masking a Lean-side soundness issue that should be
  flagged?
- **Alternative routes you may have rejected** that a fresh
  mathematician would surface — e.g., a different decomposition for
  helper #1's basis-to-opens descent, or a shorter route through
  `SheafOfModules.IsQuasicoherent` that the project has already
  dismissed.
