# Strategy Critic Directive

## Slug
iter110

## Project goal
Formalize the Jacobian of a smooth proper geometrically irreducible curve over a field, following Christian Merten's challenge (`references/challenge.lean`). The nine declarations in `archon-protected.yaml` are the deliverables:

- `AlgebraicGeometry.Curve.genus` (the genus as `Module.finrank k (Scheme.HModule k _ 1)`).
- `AlgebraicGeometry.Curve.Jacobian` (the Jacobian abelian variety).
- `AlgebraicGeometry.Curve.Jacobian.{instGrpObj, smoothOfRelativeDimension_genus, instIsProper, instGeometricallyIrreducible}` (the four instance fields).
- `AlgebraicGeometry.Curve.AbelJacobi.{ofCurve, comp_ofCurve, exists_unique_ofCurve_comp}` (Abel--Jacobi map + uniqueness).

These signatures are frozen.

## Strategy under review

(verbatim from `.archon/STRATEGY.md` — full text below, identical to what you would read if you opened the file directly.)

```
# Strategy

## How to read this file

Forward-looking only. The mathematician should be able to see, at a glance, **what
remains** between today and the end-state and **in what order** the remaining work
must happen. History lives in `task_done.md`; per-iteration recipes live in
`PROGRESS.md`. This file is the arc.

## Estimations (auto-maintained)

| Phase | Iterations remaining | LOC remaining | Status |
|---|---:|---:|---|
| A — Čech acyclicity (`BasicOpenCech.lean`) | ~2–4 | ~30–80 | **Iter-110 (narrative) / Archon iter-108 plan: Phase A escape-valve fired with Option (i)** — defer L1846 `h_loc_exact` with `-- DEFERRED (budget): ...` annotation per strategy-critic-iter108 CHALLENGE. L1846 is **NOT a Mathlib gap**: Mathlib has the building blocks. **L1120 active-route status: PAUSED** (7 PARTIAL + 2+ PAUSED iters). **Phase A residual prover work** (~2–4 iters / ~30–80 LOC): the deferred substep sorries at L1212, L1536, L1564 are tractable Mathlib-infrastructure-blocked items the project flagged for future closure but did NOT mark as named Mathlib gaps. L1754 `g_R.map_smul'` is gated on L1120 closure. |
| B — Cotangent sheaves (`Differentials.lean`) | ~8–12 | ~250 | 5 sorries; `h_exact` (L636) deferred parallel to `instIsMonoidal_W`. Variance flag (carried iter-107+): `serre_duality_genus` at L877 has the highest LOC variance; dispatch `mathlib-analogist` on Serre-duality coverage for `Module.finrank`-style consumers BEFORE scheduling Phase B. |
| C0 — Monoidal `X.Modules` | — | 0 | `instIsMonoidal_W` deferred (Mathlib gap `stalk_tensorObj` for varying-ring R₀). **Load-bearing post-C1**: post-C1 promotion, the protected `Pic`, `Pic.pullback`, `PicardFunctor`, `PicardFunctorAb`, the C2 étale-sheafified Picard functor, and downstream consumers in `Jacobian.lean` / `AbelJacobi.lean` will type-check against `BraidedCategory (X.Modules)`. |
| C1 — Refined `LineBundle` | DONE (iter-109) — verify | ~0 (closures) | C1 promotion COMPLETE iter-109. Pic-and-down ARC now type-checks against named-deferred Mathlib gaps `SheafOfModules.pullback_tensorObj` (L82) AND `SheafOfModules.pullback_oneIso` (L96 NEW iter-109 sister gap). |
| C2 — `PicardFunctor` re-derivation | ~4–6 | ~150 | Largely absorbed by iter-109 universe bumps (codomain Type u → Type (u+1)); only `representable` (L181) remains as Phase C3-deferred. Re-derivation of `quotMap`/`fiberMap` content may or may not be required against the new LineBundle — needs verification. |
| C3 — Representability / `JacobianWitness` | DEFERRED via JacobianWitness exit policy | — | `nonempty_jacobianWitness` sorry at `Jacobian.lean:179`. Hilbert/Quot schemes + finite-group quotients absent from Mathlib b80f227. |
| D, E — `genus`/`Jacobian`/instances + Abel–Jacobi | 0 | 0 | File-level closure (no inline `sorry`); content-level BLOCKED-ON-C3-WITNESS. |

**Aggregate (revised iter-109 with C1 closed)**: ~12-22 prover iterations and ~280–500 LOC remain for what the autonomous loop will deliver (Phase A residual + Phase B + Phase C2). Phase C3 deferred. The final project terminates with:

- **6 named Mathlib-gap sorries** (post-iter-109 split of pullback_tensorObj into a pair):
  1. `instIsMonoidal_W` (`Modules/Monoidal.lean` L173)
  2. `cotangentExactSeq_structure.h_exact` (`Differentials.lean` L636)
  3. `nonempty_jacobianWitness` (`Jacobian.lean` L179)
  4. `PicardFunctor.representable` (`Picard/Functor.lean` L181)
  5. `SheafOfModules.pullback_tensorObj` (`Picard/LineBundle.lean` L82)
  6. `SheafOfModules.pullback_oneIso` (`Picard/LineBundle.lean` L96) — NEW iter-109; sister to (5), collapses to `Monoidal.εIso` when (5) does.
- **1 budget-deferred sorry**: `BasicOpenCech.lean` L1846 `h_loc_exact` — `-- DEFERRED (budget): ...` annotation. NOT a Mathlib gap.

## Phase A escape-valve menu — RESOLVED iter-108 with Option (i)

(unchanged)

## Phase C3 exit policy (adopted iter-107)

(unchanged)

## End-state

`Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean` compile with **only the named Mathlib-gap sorries listed above + 1 budget-deferral** and **no new `axiom`**. The nine declarations in `archon-protected.yaml` carry the intended mathematical content **up to the JacobianWitness gap and the post-C1 load-bearing `instIsMonoidal_W` gap**.

The project ships a Jacobian framework conditional on `nonempty_jacobianWitness`, AND a Picard framework conditional on `instIsMonoidal_W` + the pair (`pullback_tensorObj`, `pullback_oneIso`). The autonomous loop terminates at this honest framing.

## Honest assessment of Phase A status (unchanged)

The `cechCofaceMap_pi_smul` lane (L1120) is **PAUSED** per progress-critic-iter106/107/108 STUCK verdicts. The L1846 `h_loc_exact` lane is **closed-out as budget-deferred** per iter-108 Option (i) execution.

## Path from today to the end-state

### Next iter (iter-110 — about to plan)

C1 fired iter-109 and landed cleanly (3 transient sorries closed; 1 new sister-gap helper added). Iter-110 candidates:

1. **Open Phase B on a non-L877 Differentials sorry** (L122, L718, or L735) concurrent with dispatching mathlib-analogist on Serre-duality (for L877 variance flag preparation).
2. **Defer Phase B to iter-111**; iter-110 dispatches only the Serre-duality consult + cleanup (e.g. the deferred Cohomology_MayerVietoris substep-numbering blueprint-writer).
3. **Open Phase C2 verification round** on `Picard/Functor.lean` — verify whether `fiberMap` / `quotMap` content needs re-derivation against the iter-109 LineBundle, OR whether the iter-109 universe bumps already absorb the necessary changes.

### Mid-term — Phase B (~iter-110/111+)

Address `Differentials.lean` non-`h_exact` sorries (L122, L718, L735, L877). `h_exact` (L636) stays deferred parallel to `instIsMonoidal_W`. **Variance flag**: Serre-duality coverage for L877 — dispatch `mathlib-analogist` BEFORE scheduling Phase B work on L877.

### Mid-term — Phase C2 (~iter-115+ or earlier)

Re-derive `PicardFunctor` content against new `LineBundle`. May be largely absorbed by iter-109 universe bumps.

### Phase C3 — DEFERRED via `JacobianWitness` exit policy

(unchanged)

## Soundness rule

(unchanged: no helper lemma with universally-false signature; iff-form helpers only for true statements; named-deferral and JacobianWitness exit policy are the soundness-rule-compliant treatments of unbounded gaps; Option (i) budget-deferral is a distinct category.)
```

## References index

- `references/summary.md`: high-level reference index (currently 1 entry).
- `references/challenge.lean`: upstream challenge spec (signatures authoritative).

## Blueprint summary (chapter titles + one-line topic per chapter)

- `AbelJacobi.tex` — The Abel--Jacobi map (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`; projects from `(jacobianWitness C).isAlbaneseFor P`).
- `Cohomology_MayerVietoris.tex` — Mayer-Vietoris LES for sheaf cohomology with `k`-module coefficients; substep-numbering cleanup deferred from iter-109.
- `Cohomology_SheafCompose.tex` — Sheaf condition along the structure-sheaf forget composite.
- `Cohomology_StructureSheafAb.tex` — Structure sheaf as a sheaf of abelian groups (sheafification + Ext).
- `Cohomology_StructureSheafModuleK.tex` — Sheaves of `k`-modules: sheafification, Ext, structure sheaf as a sheaf of `k`-modules.
- `Differentials.tex` — Sheaf of relative differentials; cotangent exact sequence; smoothness criterion.
- `Genus.tex` — Genus of a smooth proper curve as `finrank k (H¹(X, O_X))`.
- `Jacobian.tex` — Jacobian as abelian variety (JacobianWitness exit policy applies).
- `Modules_Monoidal.tex` — Symmetric monoidal `O_X`-modules; `instIsMonoidal_W` named-deferred.
- `Picard_Functor.tex` — Relative Picard functor `S ↦ Pic(X ×_k S) / Pic(S)`; `representable` deferred (C3-gated).
- `Picard_FunctorAb.tex` — Picard functor as abelian-group-valued presheaf.
- `Picard_LineBundle.tex` — Line bundles + Picard group; `Pic.pullback` closed iter-109 against named-deferred pair (pullback_tensorObj, pullback_oneIso).
- `Rigidity.tex` — Mumford rigidity for morphisms of group schemes.

## Re-verification request

Strategy was challenged extensively in iter-109 with 3 CHALLENGEs (Q1 split-C1 rebuttal; Q2 option (b) vs (c) labelling honesty; Q3 unconditional-core enumeration) and the **carried variance flag on `serre_duality_genus` (L877)**.

For iter-110, please re-verify:

1. **End-state framing** is unchanged on the named-gap count: 6 named gaps + 1 budget-deferral (was 5+1 pre-iter-109; the new `pullback_oneIso` adds one). Does the labelling-honesty principle (Q2) survive — i.e. is the new `pullback_oneIso` honestly a named-deferred Mathlib gap (sibling to `pullback_tensorObj`) and not a project-introduced ancillary?
2. **The iter-110 candidate ordering** above (open Phase B / defer Phase B to iter-111 / Phase C2 verification). Which of the three matches your independent strategic read? In particular, is the variance flag's "dispatch mathlib-analogist BEFORE scheduling Phase B" prescription binding for ALL Phase B sorries (including L122, L718, L735), or only specifically for L877?
3. **The unconditional-core enumeration** (Q3 from iter-109): is it still accurate given the iter-109 LineBundle promotion? Specifically: pre-iter-109, `Picard/LineBundle.lean`'s ALGORITHMIC content (the `CommGroup` instance) was framework-conditional on `instIsMonoidal_W`. Post-iter-109, the same is true plus the `Pic.pullback` arc now adds the named-deferred pair. Is the enumeration in STRATEGY.md "What's unconditional vs framework-conditional" accurate, or does the new `pullback_oneIso` require re-classification of any chapter?

Provide a SOUND / SOUND-WITH-CHALLENGE / CHALLENGE / REJECT verdict on the strategy as a whole, plus per-question answers.
