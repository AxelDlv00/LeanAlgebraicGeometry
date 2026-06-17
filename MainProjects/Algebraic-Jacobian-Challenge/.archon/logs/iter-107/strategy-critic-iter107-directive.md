# Strategy Critic Directive

## Slug
iter107

## Project goal

Formalize the Jacobian of a smooth proper geometrically irreducible curve
over a field, following Christian Merten's AI challenge in
`references/challenge.lean`. The nine protected declarations in
`archon-protected.yaml` are the deliverables: `Genus`, `Jacobian`,
`ofCurve`, four `Jacobian` instances (`grpObj`, `smooth_genus`, `proper`,
`geomIrred`), and `AbelJacobi`. Signatures are frozen by the
mathematician; the project must close all sorries (or surface them as
named Mathlib gaps in a soundness-rule-compliant manner) without
introducing new axioms.

## Strategy under review

[STRATEGY.md verbatim follows]

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
| A — Čech acyclicity (`BasicOpenCech.lean`) | ~5–9 | ~150–300 | **Iter-108 plan: SINGLE SUBSTANTIVE PROVER LANE on L1783 `h_loc_exact`** per strategy-critic-iter106 critical alternative + mathlib-analogist-iter106 Q1 ALIGN_WITH_MATHLIB verdict. Concrete ~80-120 LOC recipe: per-coord `IsAffineOpen.isLocalization_of_eq_basicOpen` + `IsLocalizedModule.pi` (Mathlib finite-product-localisation typeclass at `Mathlib.RingTheory.TensorProduct.IsBaseChangePi:93`) + `IsLocalizedModule.iso` + `LinearEquiv.exact_iff_exact` transporting `h_a₀_fun f` to localised exactness. **L1120 active-route status: PAUSED** (progress-critic-iter106 STUCK; 7 consecutive PARTIAL on same root cause; "refactor body" abort-policy option retired by strategy-critic-iter106 as sunk cost). L1120's iter-107 partial-proof scaffold (incl. `have h_iter104` at L1119) preserved as load-bearing infrastructure for a future re-attempt. **Iter-109 entry plan**: (a) if iter-108 closes L1783 → BasicOpenCech 6→5; iter-109 attempts mathlib-analogist Q2 Path B on L1120 (`set F := cechCofaceMap_summand_family s₀ n` at TOP of body, `change` pivot to named-family form, then `alternating_sum_pi_smul_aux`-based proof; ~30-50 LOC, structurally new attack not tried iter-099 through iter-107); (b) if iter-108 stalls on L1783 (Mathlib gap surfaces unexpectedly) → iter-109 fires C1 promotion. The `analogies/finite-product-localisation-and-cech-r-linearity.md` file documents both routes with full Mathlib citations. |
| B — Cotangent sheaves (`Differentials.lean`) | ~8–12 | ~250 | 5 sorries; `h_exact` deferred parallel to `instIsMonoidal_W`. Both Mathlib routes (stalkwise + section-wise) absent. Iter107-cleanup removed 238-line dead-code block (`ITER-076 disabled chain`); compile-clean. |
| C0 — Monoidal `X.Modules` | — | 0 | `instIsMonoidal_W` deferred (Mathlib gap `stalk_tensorObj` for varying-ring R₀). Not gating other phases. |
| C1 — Refined `LineBundle` | ~5–8 | ~200–300 | Strategy-critic-iter105 revised: estimate up from 3 iters / ~100 LOC (the comm-group structure on `Invertible (X.Modules)` may itself need new lemmas about tensor inverses being unique up to iso). lean-auditor-iter104 + blueprint-reviewer-iter105 flagged the CRITICAL `LineBundle X := CommRing.Pic Γ(X, ⊤)` excuse-comment (admitted-wrong on non-affine schemes by its own docstring; trivial for ℙⁿ vs true Pic ℤ). Iter105 blueprint-writer added Lean-state status note to `Picard_LineBundle.tex`. **Containment guard**: `PicardFunctor.representable` (`Picard/Functor.lean` L190) refuses closure on top of the approximation; no `theorem`/`lemma` is proved against the wrong def. **Promotion trigger for C1 ahead of A FIRED iter-107** (Phase A stalled 7 iters; iter-107 option 3 also failed). Iter-108 plan defers firing the trigger by one iter pending mathlib-analogist verdict on L1783 viability; iter-109 plan agent commits to firing if the analogist returns `MATHLIB_GAP_CONFIRMED` or `ALIGN_WITH_MATHLIB` on the Phase A re-architecture. Strategy-critic-iter106 critical alternative — "fire C1 promotion now" — accepted with one-iter deferral on the procedural condition (must have analogist's design rationale on disk before refactor dispatch). |
| C2 — `PicardFunctor` re-derivation | ~4–6 | ~150 | Strategy-critic-iter105 revised: estimate up from 2 iters / ~50 LOC. Full re-derivation including étale sheafification and abelian-group structure on top of new `LineBundle`. |
| C3 — Representability / `JacobianWitness` | **see "Phase C3 exit policy" below** | — | Strategy-critic-iter105 REJECT on original estimate (10–15 iters / ~1500 LOC wildly under-counted; realistic 50–150 iters / 5,000–15,000 LOC for either FGA-Hilbert or `Sym^g/S_g`). **Exit policy adopted iter-107**: defer C3 indefinitely via `JacobianWitness`-witness pattern (consistent with existing deferrals for `h_exact` and `instIsMonoidal_W`). The protected signatures compile against the `Nonempty (JacobianWitness C)` witness; the `nonempty_jacobianWitness` sorry at `Jacobian.lean:179` is the single named gap on a precise Mathlib gap (Hilbert/Quot schemes; finite-group quotients of schemes — both confirmed absent from Mathlib b80f227). **NOT scheduled for closure within this project's autonomous-loop scope.** Strategy-critic-suggested alternative "divisor-class-image Pic⁰" (avoids Hilbert + Sym^g via scheme-theoretic image of `C^g → Pic^g`) is documented as a future-work option but not selected — it still requires scheme-theoretic image API + Riemann–Roch effective theory that are themselves Mathlib gaps. |
| D — `genus`/`Jacobian`/instances | 0 (closed iter-073) | 0 | File-level closure (no inline `sorry`). **Content-level: BLOCKED-ON-C3-WITNESS** — all instance bodies route through `nonempty_jacobianWitness`. Strategy-critic-iter105 CHALLENGE accepted: the framing here reflects that file-level signatures are honored against the deferred witness, NOT that mathematical content is delivered. |
| E — Abel–Jacobi | 0 (closed iter-073) | 0 | Identical to D. **Content-level: BLOCKED-ON-C3-WITNESS.** |

**Aggregate (revised iter-107)**: ~21–33 prover iterations and ~480–630 LOC remain for **what the autonomous loop will deliver** (Phases A, B, C1, C2). Phase C3 is deferred via `JacobianWitness` pattern; the protected `Jacobian`/`ofCurve` signatures compile against a sorry-routed witness, mirroring `h_exact` and `instIsMonoidal_W`. The final project terminates with **exactly 4 named Mathlib-gap sorries** in scope: `instIsMonoidal_W` (varying-ring stalk), `h_exact` (sheaf-of-modules exactness criterion), `nonempty_jacobianWitness` (Hilbert/Quot schemes + finite-group quotients), and `PicardFunctor.representable` (gated on `JacobianWitness`). Plus `BasicOpenCech.lean`'s `h_loc_exact` (`IsLocalizedModule.Away f.1` on finite products, ~80 LOC Mathlib gap-fill — TRACTABLE within scope, will be closed during Phase A). All other sorries close within the autonomous loop.

## Phase C3 exit policy (adopted iter-107 in response to strategy-critic REJECT)

The strategy-critic-iter105 audit returned REJECT on Phase C3 with the argument that both proposed routes (FGA-via-Hilbert; `Sym^g C / S_g`) require constructing Mathlib infrastructure (Hilbert scheme; finite-group scheme quotient) that is a Hartshorne-chapter-sized undertaking (~5,000–10,000 LOC each), wildly exceeding the project's stated estimate.

**Adopted exit policy**: defer Phase C3 indefinitely via the `JacobianWitness`-witness pattern. The protected `Jacobian C`, `ofCurve P`, and downstream instances (`GrpObj`, `IsProper`, `GeometricallyIrreducible`, `SmoothOfRelativeDimension`) carry sorry-routed bodies that reduce to `Nonempty (JacobianWitness C)`, where `JacobianWitness C : Type` is a structure with a `sorry`-bodied existence at `Jacobian.lean:179`. This is **mathematically honest**: the project delivers a *framework* for the Jacobian (genus, Picard functor, all instance plumbing) that bottoms out in a single named Mathlib gap.

The strategy-critic's "divisor-class-image Pic⁰" alternative (avoiding both Hilbert and Sym^g via scheme-theoretic image of `C^g → Pic^g` + Riemann–Roch effective theory) is documented as a future-work option for whoever picks up the project after Mathlib's algebraic-geometry foundations are deeper. It is NOT selected as a within-scope route because the prerequisite infrastructure (scheme-theoretic image API in the relevant generality; Riemann–Roch effective theory at the curve level; the birational-image-is-group-scheme step) is itself missing from Mathlib b80f227.

**Status of Phases D and E**: re-classified from "closed iter-073" to "BLOCKED-ON-C3-WITNESS". The protected declarations compile with sorry-routed witnesses (file-level closure: no inline `sorry` in `Genus.lean`, `Jacobian.lean` (except the witness sorry), `AbelJacobi.lean`); the *mathematical content* of D and E depends on closure of `nonempty_jacobianWitness` (C3). This framing is the **honest accounting** of what the project delivers: signatures compile + sorries are named + the gap-fill is on the Mathlib side.

## End-state

`Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean` compile with **only the named Mathlib-gap sorries listed above** and **no new `axiom`**. The nine declarations in `archon-protected.yaml` carry the intended mathematical content **up to the JacobianWitness gap**, with all other infrastructure (Čech cohomology, cotangent sheaves, sheafified Picard functor) delivered.

**Plain-language disclosure of the End-state for the human reader** (strategy-critic-iter106 CHALLENGE accepted): the protected `Jacobian C`, `ofCurve`, and the four `Jacobian` instances (`grpObj`, `smooth_genus`, `proper`, `geomIrred`) compile against a `Nonempty (JacobianWitness C)` witness whose existence sorry is at `Jacobian.lean:179` (`nonempty_jacobianWitness`). **The project ships a Jacobian *framework*, conditional on the witness — it does NOT autonomously construct the Jacobian.** A fresh reader of the final project state should understand: "did you build the Jacobian of a smooth proper curve?" answers as "no, we built every Jacobian-derived instance + AbelJacobi morphism + downstream consequences AGAINST the named existence hypothesis `nonempty_jacobianWitness`, which itself rests on Mathlib gaps (Hilbert / Quot schemes; finite-group scheme quotients)". This is the soundness-rule-compliant treatment of an unbounded Mathlib gap, but it is *materially different* from a full construction. The autonomous loop terminates at this honest framing; the construction is left for whoever picks up the project once Mathlib's algebraic-geometry foundations are deeper. (Strategy-critic-iter106: "Jacobian framework conditional on `nonempty_jacobianWitness`" ≠ "Jacobian constructed".)

## Honest assessment of Phase A (iter-108 status)

Lane 1 target `cechCofaceMap_pi_smul` trailing sorry at L1120 (post iter-107 cleanup; was L1145/L1147/L1179 across earlier iter rewrites) has been the active prover lane since iter-099. **Progress-critic-iter106 STUCK verdict (re-confirmed)**: 7 consecutive PARTIAL iters on this slot. The iter-107 corrective (option 3, recommended by progress-critic-iter105) executed in 6 distinct attempts and ALL FAILED at the same root cause: discrim-tree pattern unification + whnf reduction on the anonymous-closure `Pi.lift` codomain. Recurring blockers across 7 iters: "anonymous-closure Pi.lift codomain" (6/7), "discrim-tree pattern-unification" (5/7), "whnf timeout" (4/7), "eqToHom-vs-Pi.π transport" (4/7), "Fin index mismatch" (4/7).

**Iter-108 acts on progress-critic-iter106 + strategy-critic-iter106 verdicts**:
- L1120 lane PAUSED. Iter-108 dispatches NO prover lane on this slot. The iter-107 partial-proof scaffold (incl. `have h_iter104` at L1119) is preserved as load-bearing partial progress for a future re-attempt.
- The iter-107 abort-policy option (a) "refactor `cechCofaceMap_pi_smul`'s body to use a different decomposition" is RETIRED as sunk-cost per strategy-critic-iter106 ("same lemma, same Pi.lift-codomain blocker, re-skinned"). Body-level inlining of the iter-104-style binder proof into `cechCofaceMap_pi_smul` (the iter-107 prover's iter-108 recommendation) is morally wrapper engineering by another name; not authorized.
- Iter-108 substantive action: mathlib-analogist dispatch on (Q1) the L1783 `h_loc_exact` product-localisation viability AND (Q2) the cechCofaceMap_pi_smul Pi.lift + Pi.π architecture question. **Iter-109 entry plan branches on the analogist's verdict**:
  - Analogist Q1 PROCEED → iter-109 dispatches prover on `h_loc_exact` (L1783).
  - Analogist Q2 ALIGN_WITH_MATHLIB → iter-109 dispatches refactor on cechCofaceMap_pi_smul to the Mathlib-aligned formulation, then prover.
  - Analogist Q1 MATHLIB_GAP_CONFIRMED AND Q2 MATHLIB_GAP_CONFIRMED → iter-109 fires C1 promotion trigger (LineBundle refactor begins).

**Wrapper engineering AND body-level inlining of the same Pi.lift compositional approach are both committed to NOT be repeated.** This is the binding policy entering iter-109.

## Mathlib gaps in scope

| Gap | Phase | Plan |
|---|---|---|
| Stalkwise criterion for `SheafOfModules` exactness | B | Both routes confirmed Mathlib-gap blocked (iter-086 audit). `h_exact` deferred parallel to `instIsMonoidal_W`. |
| `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗ N.stalk x` (varying-ring `R₀`) | C0 | Defer indefinitely; downstream not gated. |
| Sheaf cohomology `Hⁱ(X, F)` for quasi-coherent sheaves | A | Project-local `HModule`/`HModule'` via `Abelian.Ext` (built iter-003–008). |
| `IsLocalizedModule.Away f.1` on finite products | A | Needed for `h_loc_exact` (BasicOpenCech.lean L1808). Tractable iter-108+; ~80 LOC project-local gap-fill. |
| Hilbert / Quot schemes | C3-DEFERRED | Phase C3 deferred via JacobianWitness exit policy. |
| Finite-group quotients of schemes | C3-DEFERRED | Same. |
| Riemann–Roch effective theory + scheme-theoretic image (for divisor-class-image alternative) | C3-DEFERRED | Mathlib gap; the strategy-critic-suggested "divisor-class-image Pic⁰" route is documented but not selected. |

## Path from today to the end-state

### Iter-108 (this iter's plan)

**Single substantive prover lane on L1783 `h_loc_exact` of `BasicOpenCech.lean`** per mathlib-analogist-iter106 Q1 ALIGN_WITH_MATHLIB verdict. Bounded ~80–120 LOC closure using a concrete 4-step Mathlib recipe (see PROGRESS.md for the prover directive).

Confirmatory + investigatory dispatches landed pre-prover:
- **Refactor iter108-cleanup landed**: replaced 2 stale "iter-006/iter-002 scaffold" `## Status` blocks (`StructureSheafModuleK.lean:27-31`, `Rigidity.lean:19-23`) with current-state docstrings. Closes 2 of the 4 lean-auditor-iter105 must-fix items.
- **Blueprint-writer ssmk-typo landed**: fixed `\uses{thm:Scheme_toModuleKSheaf}` → `def:Scheme_toModuleKSheaf` at `Cohomology_StructureSheafModuleK.tex:474`. Resolves the lone blueprint-reviewer-iter106 must-fix.
- **Mathlib-analogist `finite-prod-loc` landed**: Q1 ALIGN_WITH_MATHLIB on `h_loc_exact` (clear recipe); Q2 MATHLIB_GAP_CONFIRMED on `cechCofaceMap_pi_smul` R-linearity post-hoc certification (self-imposed by choice of `ModuleCat k` vs `ModuleCat R`). Two paths for Q2 documented in `analogies/finite-product-localisation-and-cech-r-linearity.md`: Path B (tactical, ~30–50 LOC) at top of body via `set F := cechCofaceMap_summand_family s₀ n` + `change`; Path A (architectural refactor to `ModuleCat R`, ~150–250 LOC).

**Target net**: BasicOpenCech 6 → 5 (close L1783). Two lean-auditor stale-docstring must-fix items resolved. Blueprint typo resolved.

### Iter-109+

Branches on iter-108 outcome:

- **If iter-108 closes L1783**: BasicOpenCech 5; iter-109 dispatches mathlib-analogist Q2 Path B on L1120 (`set F := cechCofaceMap_summand_family s₀ n` at top of body before any unfolds, `change` to named-family form, then per-summand R-linearity via `cechCofaceMap_summand_family_R_linear`). Time-boxed at 1 iter; if Path B fails, iter-110 escalates to Q2 Path A architectural refactor OR fires C1 promotion.
- **If iter-108 stalls on L1783** (Mathlib gap surfaces unexpectedly despite Q1 ALIGN verdict): iter-109 fires C1 promotion trigger (LineBundle refactor begins). The strategy-critic-iter106 critical alternative #3 is then executed.

The user-escalation option remains in reserve for both branches.

### Mid-term — Phase B (~iter-110+)

Address `Differentials.lean` non-`h_exact` sorries (L113 `relativeDifferentialsPresheaf_isSheaf`, L711 `smooth_iff_locally_free_omega`, L727 `cotangent_at_section`, L871 `serre_duality_genus`). `h_exact` (L517) stays deferred parallel to `instIsMonoidal_W`.

### Mid-term — Phase C1 (`LineBundle` refactor)

Refactor subagent: rewrite `Picard/LineBundle.lean` body from `CommRing.Pic Γ(X, ⊤)` to `MonoidalCategory.Invertible (X.Modules)`. Protected signature stays. Re-establish `instCommGroupLineBundle` and `Pic.pullback`. Estimate 5–8 iters / 200–300 LOC (strategy-critic-iter105 revised). **Promotion trigger**: if iter-107 + iter-108 both stall on Phase A residuals, promote C1 ahead of further A work.

### Mid-term — Phase C2 (`PicardFunctor` re-derivation)

Re-derive `PicardFunctor`'s `quotMap`/`fiberMap`/etale-sheafification against the new `LineBundle`. Estimate 4–6 iters / ~150 LOC (strategy-critic-iter105 revised). Sequenced after C1.

### Phase C3 — DEFERRED via `JacobianWitness` exit policy

See "Phase C3 exit policy" section above. The protected `Jacobian`/`ofCurve` carry sorry-routed bodies; `nonempty_jacobianWitness` is the named Mathlib-gap sorry at `Jacobian.lean:179`.

## Soundness rule

**No helper lemma with a universally-false signature may be introduced**, even with
a `sorry` body. Such a helper is logically an axiom; combined with `exact ... _`
applications, it bypasses any subsequent goal.

When the genuine statement is impossible to prove because of a Mathlib gap, the
project's choice is between:
(a) Leave the inline `sorry` in place at the use site (preferred — surfaces honest
status).
(b) Define an iff-form helper as a `theorem ... : iff_statement := sorry` if the
statement is mathematically TRUE; the application then exposes the unprovable side
as a fresh, named goal rather than displacing it silently. Only do this when downstream
consumers can usefully assume the iff in `simp`/`rw`/`exact` chains.

Never replace an inline `sorry` with a `sorry`-bodied helper that strengthens the
claim or with one whose signature is mathematically wrong.

The **Phase C3 exit policy** above is the soundness-rule-compliant treatment of an
unbounded Mathlib gap: keep the inline `sorry` at the witness use-site
(`nonempty_jacobianWitness`); ship the downstream signatures against the `Nonempty`
witness; surface honest status to the end-user reader.
```

## References index

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |

## Blueprint summary

| File | Topic |
| ---- | ----- |
| `AbelJacobi.tex` | The Abel–Jacobi map |
| `Cohomology_MayerVietoris.tex` | Mayer–Vietoris long exact sequence for sheaf cohomology with $k$-module coefficients (contains the Čech-acyclicity work for Phase A) |
| `Cohomology_SheafCompose.tex` | Sheaf condition along the structure-sheaf forget composite |
| `Cohomology_StructureSheafAb.tex` | Structure sheaf as a sheaf of abelian groups, sheafification and Ext |
| `Cohomology_StructureSheafModuleK.tex` | Sheaves of $k$-modules: sheafification, Ext, and the structure sheaf as a sheaf of $k$-modules |
| `Differentials.tex` | The sheaf of relative differentials (Phase B) |
| `Genus.tex` | Genus of a smooth proper curve (Phase D) |
| `Jacobian.tex` | The Jacobian as an abelian variety (Phase D + Phase C3 exit) |
| `Modules_Monoidal.tex` | The symmetric monoidal category of $\mathcal O_X$-modules (Phase C0) |
| `Picard_Functor.tex` | The relative Picard functor (Phase C2) |
| `Picard_FunctorAb.tex` | The relative Picard functor as an abelian-group-valued presheaf |
| `Picard_LineBundle.tex` | Line bundles on schemes and the Picard group (Phase C1) |
| `Rigidity.tex` | Rigidity for morphisms of group schemes (Mumford §4) |

## Prior critique status

Strategy-critic-iter106 returned CHALLENGE × 3:

1. **Phase A option-3 continuation as sunk-cost** — ADDRESSED iter-108:
   L1120 lane PAUSED; iter-108 dispatched a single prover lane on L1783
   instead. Result: iter-108 prover committed Steps 1a + 1b of the
   analogist Q1 recipe (~19 LOC of geometric scaffolding) but deferred
   Steps 1c-4 to this iter (iter-107 Archon / iter-109 narrative).
2. **C1 promotion trigger** — ADDRESSED procedurally: deferred one iter
   pending mathlib-analogist verdict; analogist Q1 returned ALIGN with
   a bounded recipe. C1 still queued for iter-110+ if iter-107 stalls
   on L1802 closure.
3. **End-state Phase C3 communication** — ADDRESSED: STRATEGY.md now
   carries a "plain-language disclosure" paragraph stating the project
   ships a *framework* conditional on `nonempty_jacobianWitness`, not a
   construction.

Status entering this iter:
- L1802 (former L1783) `h_loc_exact` partial-proof scaffold committed
  (Steps 1a + 1b of analogist Q1, ~19 LOC). Trailing sorry preserved
  for Steps 1c-4 (~100-110 LOC, bounded recipe documented in PROGRESS.md
  and `analogies/finite-product-localisation-and-cech-r-linearity.md`).
- L1120 `cechCofaceMap_pi_smul` REMAINS PAUSED (no challenge to that
  decision this iter).

Re-verify whether the strategy still holds:
- Is the Phase A continuation (close L1802) sound now that 1 iter on
  this new lane has shown partial progress? Or is this a different
  kind of sunk-cost ("we already started, must finish")?
- Does the "iter-109 entry plan branches" language in STRATEGY.md need
  refreshing now that iter-108 went neither clean closure (Branch a)
  nor outright stall (Branch b) but partial — Steps 1a/1b landed,
  Steps 1c/4 deferred? The current strategy assumes binary outcomes;
  the actual outcome is "partial-progress within bounded recipe."
- Phase C3 exit policy stable; do not re-litigate.
- Phase C0 / B deferrals stable.
- C1 promotion trigger: still queued; revisit only if this iter stalls
  on L1802.
