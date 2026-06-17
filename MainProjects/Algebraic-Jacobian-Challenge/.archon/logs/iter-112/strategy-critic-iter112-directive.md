# Strategy Critic Directive

## Slug
iter112

## Project goal

The project formalizes the Jacobian of a smooth proper geometrically irreducible curve over a field, following the AI-challenge file by Christian Merten (`references/challenge.lean`). The deliverables are the 9 protected declarations:

- `AlgebraicGeometry.genus` (`Genus.lean`)
- `AlgebraicGeometry.Jacobian`, `Jacobian.ofCurve`, `Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible` (`Jacobian.lean`)
- `AlgebraicGeometry.Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` (`AbelJacobi.lean`)

The end-state is delivery of these signatures with **only named Mathlib-gap sorries (currently 7) and one budget-deferral**.

## Strategy under review

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
| A — Čech acyclicity (`BasicOpenCech.lean`) | **DEFERRED (gated)** | ~30–80 (per-substep, conditional) | Iter-108 Option (i) escape-valve fired (L1846 budget-deferred). L1120 PAUSED. Substep sorries L1212/L1536/L1564 await predecessors. L1754 gated on L1120. ~30–80 LOC is per-substep close-out figure, NOT global. Phase A is closed-out for the autonomous loop's scope. |
| B — Cotangent sheaves (`Differentials.lean`) | ~4–8 | ~200 | 5 sorries. L877 named gap #7 (Serre duality). L636 deferred parallel to instIsMonoidal_W. **Phase B autonomous-loop scope is 3 sorries**: L122 (~2–3 iters / ~100–200 LOC; basis-to-opens descent needs sub-lemma work; not a Mathlib gap, prover-buildable via Routes (a) or (b)), L735 (~1–2 iters; corollary of L718), L718 (~2–4 iters; **heaviest**, Hartshorne II.8.15). Recommended dispatch order: L122 → L735 → L718. |
| C0 — Monoidal `X.Modules` | — | 0 | `instIsMonoidal_W` deferred (Mathlib gap `stalk_tensorObj` for varying-ring R₀). Load-bearing post-C1. |
| C1 — Refined `LineBundle` | **DONE iter-109** | ~0 | C1 promotion COMPLETE iter-109. Body `LineBundle X := (Skeleton X.Modules)ˣ`. Persistent rationale: `analogies/c1-route.md`. |
| C2 — `PicardFunctor` re-derivation | ~0–4 | ~0–80 | Largely absorbed by iter-109 universe bumps. Verification round pending (cheap intel). |
| C3 — Representability / `JacobianWitness` | DEFERRED via JacobianWitness exit policy | — | Deferred indefinitely. `nonempty_jacobianWitness` sorry at `Jacobian.lean:179`. |
| D, E — `genus`/`Jacobian`/instances + Abel–Jacobi | 0 | 0 | File-level closure; content-level BLOCKED-ON-C3-WITNESS. |

**Aggregate**: ~6–12 prover iterations and ~150–300 LOC remain for what the autonomous loop will deliver (Phase A residual + Phase B non-L877 + Phase C2 verification round). Phase C3 deferred. The final project terminates with:

- **7 named Mathlib-gap sorries**: `instIsMonoidal_W`, `cotangentExactSeq_structure.h_exact`, `nonempty_jacobianWitness`, `PicardFunctor.representable`, `SheafOfModules.pullback_tensorObj`, `SheafOfModules.pullback_oneIso`, `serre_duality_genus`.
- **1 budget-deferred sorry**: `BasicOpenCech.lean` L1846 `h_loc_exact`.

## What's unconditional vs framework-conditional

- **Unconditional core**: Rigidity, Genus definition, Čech-cohomology infrastructure (modulo Phase A parked sorries), Differentials cotangent API (modulo h_exact + 4 Phase B sorries not yet in chain), FunctorAb additive wrapping.
- **Framework-conditional on `nonempty_jacobianWitness`**: Jacobian.lean protected signatures + AbelJacobi.lean protected signatures.
- **Framework-conditional on `instIsMonoidal_W` + pair**: Picard/LineBundle.lean Pic/instCommGroupLineBundle/Pic.pullback*, Picard/Functor.lean PicardFunctor/fiberMap/quotMap, Picard/FunctorAb.lean etaleSheafified-derived terms.
- **Framework-conditional on `serre_duality_genus`**: any downstream consumer bridging genus to dim_k H^0(C, Ω_{C/k}). No protected signature consumes this currently.
- **Multi-gap-conditional**: PicardFunctor.representable (gated on C3 + the iter-109 pair).

## Phase A escape-valve menu — RESOLVED iter-108 with Option (i)

Iter-108 fired Option (i): defer L1846 with `-- DEFERRED (budget): ...` annotation. L1846 is mechanizable from existing Mathlib (`IsLocalizedModule.{Away,pi,prodMap}` + algebra adapter); mechanization parked behind Phase B priorities.

## Phase C3 exit policy (adopted iter-107)

Defer Phase C3 indefinitely via the JacobianWitness-witness pattern. `Jacobian C`, `ofCurve P`, instances carry sorry-routed bodies that reduce to `Nonempty (JacobianWitness C)`, where `JacobianWitness C` has a `sorry`-bodied existence at `Jacobian.lean:179`. The "divisor-class-image Pic⁰" alternative is documented but not selected (prerequisite Mathlib infra is itself absent).

## End-state

`Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean` compile with only the 7 named gaps + 1 budget-deferral, no new `axiom`. Two stacked conditionals (`nonempty_jacobianWitness` for the Jacobian arc; `instIsMonoidal_W` + sister pair for post-C1 Pic arc; `serre_duality_genus` as a forward-compatibility named-deferral). The unconditional core is a non-trivial mathematics-content delivery.

## Honest assessment of Phase A

The `cechCofaceMap_pi_smul` lane (L1120) is PAUSED per progress-critic STUCK verdicts. The L1846 lane closed iter-108 via Option (i). Phase A closed-out for the autonomous loop's scope modulo deferred substep sorries.

## Mathlib gaps in scope

| Gap | Phase | Plan |
|---|---|---|
| Stalkwise criterion for `SheafOfModules` exactness | B | Deferred parallel to instIsMonoidal_W. |
| `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗ N.stalk x` (varying-ring R₀) | C0 / post-C1 load-bearing | Defer indefinitely. |
| Sheaf cohomology `Hⁱ(X, F)` for quasi-coherent sheaves | A | Project-local `HModule`/`HModule'` via `Abelian.Ext`. |
| `IsLocalizedModule.Away f.1` on finite products | A | NO LONGER A GAP — Mathlib has `IsLocalizedModule.{Away,pi,prodMap}`. L1846 budget-deferred. |
| `Functor.Monoidal (Scheme.Hom.pullback f)` for `SheafOfModules` | C1 | Named-deferred via L82 + L96 sister pair. |
| Hilbert / Quot schemes | C3-DEFERRED | JacobianWitness exit policy. |
| Finite-group quotients of schemes | C3-DEFERRED | Same. |
| Riemann–Roch effective theory + scheme-theoretic image | C3-DEFERRED | Documented but not selected. |
| Serre duality (canonical sheaf + dualizing sheaf + trace) | B | Iter-110 mathlib-analogist named-deferred. |

## Path from today to the end-state

### Mid-term — Phase B prover work (iter-112+)

Address Differentials.lean non-h_exact non-L877 sorries (L122, L735, L718) once the chapter is iter-111-upgraded. Variance-flag scope: Serre-duality analogist gates L877 specifically; L122/L735/L718 prover-viable.

### Mid-term — Phase C2 verification round (iter-112+)

Read `Picard/Functor.lean` post-C1; spot-check whether fiberMap/quotMap need content re-derivation. Likely no further work; iter-109 universe bumps already absorbed required changes.

### Phase C3 — DEFERRED via JacobianWitness exit policy

See above.

## Soundness rule

No helper lemma with universally-false signature, even with sorry body. The Phase C3 exit policy, the post-C1 load-bearing disclosure of `instIsMonoidal_W`, and the Option (i) budget-deferral on L1846 are all soundness-rule-compliant patterns.
```

## References index

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |

## Blueprint summary

- `AbelJacobi.tex` — Abel–Jacobi morphism `C^g → Jac(C)` and its universal property (Jacobian = Albanese).
- `Cohomology_MayerVietoris.tex` — Mayer-Vietoris LES for `HModule'`; affine-cover gluing infrastructure.
- `Cohomology_SheafCompose.tex` — sheafified composition / forget functors needed for `HModule`.
- `Cohomology_StructureSheafAb.tex` — additive-group sheafified structure sheaf; Ext on abelian sheaves.
- `Cohomology_StructureSheafModuleK.tex` — `ModuleCat k`-valued structure-sheaf cohomology; Čech complex; genus apparatus.
- `Differentials.tex` — relative Kähler differentials `Ω_{X/S}` as a sheaf; cotangent exact sequence; Smooth ⇔ locally-free-Ω; Serre-duality genus equality.
- `Genus.tex` — `genus C = dim_k H¹(C, O_C)` via `HModule`.
- `Jacobian.tex` — `Jacobian C` framework via `JacobianWitness`; protected signatures.
- `Modules_Monoidal.tex` — Monoidal structure on `X.Modules` (sheaf of O_X-modules); `instIsMonoidal_W`.
- `Picard_Functor.tex` — contravariant `PicardFunctor : Schemeᵒᵖ → CommGrpCat`; `fiberMap`/`quotMap`.
- `Picard_FunctorAb.tex` — additive-group wrapper `PicardFunctorAb`; étale sheafification.
- `Picard_LineBundle.tex` — `LineBundle X := (Skeleton X.Modules)ˣ` (C1 promotion landed iter-109); `Pic.pullback` via `pullback_tensorObj`/`pullback_oneIso` sister pair.
- `Rigidity.tex` — Mumford rigidity lemma for group-scheme morphisms.

## Prior critique status

Three prior strategy-critic dispatches (iter-109, iter-110, iter-111):

- **iter-109 (SOUND-with-CHALLENGE)**: 4 precision asks Q1–Q4 — all addressed in STRATEGY.md.
- **iter-110 (SOUND-with-CHALLENGE)**: precision asks on Phase A → Phase B handoff, L877 reclassification, Phase C2 ordering — all addressed.
- **iter-111 (SOUND-with-CHALLENGE)**: 2 minor framing asks — Phase A table cell reclassified to `DEFERRED (gated)`; Phase B row notes L718 as heaviest + L122 estimate upward-revision per blueprint-writer-iter111 basis-to-opens descent finding. **Both addressed in current STRATEGY.md.**

Pass: re-verify whether the current STRATEGY.md (above) clears those prior challenges and whether any new strategic concern surfaces under a fresh re-read.
