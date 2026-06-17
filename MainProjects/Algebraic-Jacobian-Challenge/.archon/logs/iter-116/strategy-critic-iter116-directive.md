# Strategy Critic Directive

## Slug
iter116

## Project goal

Formalize the Jacobian of a smooth proper geometrically irreducible curve over a field, following Christian Merten's challenge file (`references/challenge.lean`). The deliverables are the 9 declarations enumerated in `archon-protected.yaml` (root of repo), spanning `Jacobian C`, `Jacobian.ofCurve`, four `Jacobian` instances (`grpObj`, `smooth_genus`, `proper`, `geomIrred`), and the Abel–Jacobi morphism + its uniqueness. The Lean skeleton is in `AlgebraicJacobian/`; signatures from `references/challenge.lean` are authoritative.

## Strategy under review

```markdown
$(no separator — paste below verbatim)
```

[BEGIN VERBATIM STRATEGY.md]

# Strategy

## How to read this file

Forward-looking only. The mathematician should be able to see, at a glance, **what
remains** between today and the end-state and **in what order** the remaining work
must happen. History lives in `task_done.md`; per-iteration recipes live in
`PROGRESS.md`. This file is the arc.

## Estimations (auto-maintained)

| Phase | Iterations remaining | LOC remaining | Status |
|---|---:|---:|---|
| A — Čech acyclicity (`BasicOpenCech.lean`) | **DEFERRED (gated)** | ~30–80 (per-substep, conditional) | **Iter-110 (narrative) / Archon iter-108 plan: Phase A escape-valve fired with Option (i) — defer L1846 `h_loc_exact` with `-- DEFERRED (budget): ...` annotation per strategy-critic-iter108 CHALLENGE.** Per strategy-critic-iter111 framing precision: the ~30–80 LOC figure is the **per-substep** close-out cost *conditional on the predecessor substep landing*; both predecessors (L1846 deferred, L1120 PAUSED) are themselves off-path, so this work is NOT on the iter-111+ schedule. The "Path from today" section does not schedule Phase A work. L1846 is **NOT a Mathlib gap**: Mathlib b80f227 has `IsLocalizedModule.Away`, `IsLocalizedModule.pi`, `IsLocalizedModule.prodMap`, and the algebra adapter `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid` (verified via `lean_leansearch`). The lemma is mechanizable; mechanization deferred at iter-108 due to `letI ... in <goal-type>` propagation friction (per-x algebra threading). The inline iter-108 + iter-109 narrative scaffolding at L1786–L1834 (~50 LOC: `h_V_le_U`, `h_slice_eq`, `h_pi_eq_inf'`, `h_V_affine`, `h_isLoc`) is preserved as inert infrastructure for future re-attempt. **L1120 active-route status: PAUSED** (progress-critic-iter106/107/108 STUCK; 7 consecutive PARTIAL + 2 PAUSED iters). **Phase A residual prover work** (~2–4 iters / ~30–80 LOC, refined iter-110 per strategy-critic-iter110 CHALLENGE on the "tractable-but-blocked" framing): the deferred substep sorries at L1212, L1536, L1564 each have a *named substep dependency* — L1212 awaits the substep (a) augmented-Čech complex; L1536 awaits the `K → K₀` transport; L1564 awaits the substep (a) for `s₀` — these are project-local substep dependencies inside `BasicOpenCech.lean`, NOT named Mathlib-API gaps. The ~30–80 LOC estimate is a per-substep close-out figure once each substep's predecessor lands; it is NOT a global Phase A close-out cost. L1754 `g_R.map_smul'` is gated on L1120 closure, hence indefinitely deferred parallel to L1120. |
| B — Cotangent sheaves (`Differentials.lean`) | **conditional, revised iter-115 per strategy-critic** — ~5–8 iters / ~250–400 LOC *if L880-converse fires the named-gap escape*; ~8–14 iters / ~500–1000 LOC *if L880-converse closed in-loop* | see left | 5 sorries. **Iter-110 reclassification**: L1039 `serre_duality_genus` named-deferred (7th gap; ~3000–8000 LOC from first principles is out of scope). L798 `h_exact` continues deferred parallel to `instIsMonoidal_W`. **Phase B autonomous-loop scope is now 3 sorries**, with **non-uniform expected cost per strategy-critic-iter114 effort decomposition (refined iter-115)**: (i) **L175 `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`** (iter-113 NEW sub-helper, replacing the prior L122 sorry after the iter-113 unique-gluing reformulation) — estimated ~2–3 iters / ~100–200 LOC; close via affine-basis identification (`KaehlerDifferential.isLocalizedModule` [verified] + `AlgebraicGeometry.tilde` [verified]) + hand-rolled cofinality descent + `KaehlerDifferential.span_range_derivation` uniqueness; (ii) **L897 `cotangent_at_section`** — moderate (~1–2 iters / ~50–100 LOC, corollary of L880-forward via pullback preservation of locally-free); (iii) **L880 `smooth_iff_locally_free_omega`** — **decomposed iter-114 into forward + converse** per strategy-critic-iter114 CHALLENGE on the original under-counted ~2–4 iter / ~200 LOC estimate. **Forward direction `smooth_imp_locally_free_omega`** (~2–3 iters / ~100–200 LOC): direct from `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` [verified] + `Algebra.IsStandardSmooth.free_kaehlerDifferential` [verified] on affine charts. **Converse direction `locally_free_omega_imp_smooth`** (~3–6 iters / ~200–500 LOC): Hartshorne II.8.15 converse. **Correct closing lemma (iter-115 strategy-critic CHALLENGE fix)**: `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` [verified] (`Mathlib.RingTheory.Smooth.StandardSmoothOfFree`), with hypotheses (i) `Algebra.FinitePresentation R S`, (ii) `Subsingleton (Algebra.H1Cotangent R S)` (= formal smoothness / cotangent-cohomology vanishing — *this is the genuine deformation-theoretic content*, NOT "flatness" as the prior iter-114 phrasing read), (iii) a basis whose elements are in `Set.range (KaehlerDifferential.D R S)`. Once `IsStandardSmooth R S` lands, `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth` [verified] descends to `IsStandardSmoothOfRelativeDimension n` from `rank Ω = n`. The genuine hard step is (ii); (iii) follows from differentiating a chosen set of generators. The biconditional `smooth_iff_locally_free_omega` reassembles forward + converse trivially. **Recommended dispatch order**: L175 first (foundational; the iter-113 unique-gluing pivot is the load-bearing residual; iter-114 plan-phase deferred this lane pending the mathlib-analogist-iter114 audit of the `Scheme.PresheafOfModules`-from-affine-basis predicate per progress-critic-iter114 STUCK; iter-115 GREENLIT per blueprint-reviewer-iter115 PASS), then L880-forward, then L897 (gated on L880-forward landing), then L880-converse as the heaviest. Conditional-aggregate framing: the lower range (~5–8 iters / ~250–400 LOC) applies if iter-115+ progress-critic CHURNING on L880-converse fires the narrower-trim escape (declare `locally_free_omega_imp_smooth` as named gap #8). The upper range (~8–14 iters / ~500–1000 LOC) applies if the converse is closed in-loop (deformation-theoretic content via `Subsingleton (Algebra.H1Cotangent R S)`). |
| C0 — Monoidal `X.Modules` | — | 0 | `instIsMonoidal_W` deferred (Mathlib gap `stalk_tensorObj` for varying-ring R₀). **Status update post-mathlib-analogist-c1-route iter-108**: this sorry is currently *dormant* (no active proof DAG consumes it pre-C1) but will become **load-bearing for the entire Pic-and-down arc post-C1 promotion**. The named-gap *count* is unchanged; the *transitive reach* of the sorry expands dramatically. End-state framing must add a load-bearing disclosure paragraph mirroring the `JacobianWitness` honest-accounting. |
| C1 — Refined `LineBundle` | **DONE iter-109** | ~0 | C1 promotion COMPLETE iter-109. Body `LineBundle X := (Skeleton X.Modules)ˣ`. Pic.pullback closed via hand-construction through `(Scheme.Modules.pullback f).mapSkeleton` consuming the iter-109-introduced **named-deferred pair** (`SheafOfModules.pullback_tensorObj` L82 = `μ`-iso; `SheafOfModules.pullback_oneIso` L96 = `ε`-iso). |
| C2 — `PicardFunctor` re-derivation | ~0–4 | ~0–80 | Largely absorbed by iter-109 universe bumps. **Iter-110+ verification round** required: read `Picard/Functor.lean` post-C1 + spot-check whether `fiberMap`/`quotMap` need content re-derivation. Likely outcome: no further work needed. |
| C3 — Representability / `JacobianWitness` | DEFERRED via JacobianWitness exit policy | — | `nonempty_jacobianWitness` sorry at `Jacobian.lean:179` is the single named gap on Hilbert/Quot schemes + finite-group scheme quotients (both confirmed absent from Mathlib b80f227). |
| D, E — `genus`/`Jacobian`/instances + Abel–Jacobi | 0 | 0 | File-level closure (no inline `sorry`); content-level BLOCKED-ON-C3-WITNESS. |

**Aggregate (revised iter-115 per strategy-critic CHALLENGE on the prior aggregate not matching the per-component decomposition)**: ~5–8 prover iterations and ~250–400 LOC *if L880-converse fires the named-gap escape*; ~8–14 prover iterations and ~500–1000 LOC *if L880-converse closed in-loop*.

**Scope rationale**. After the iter-107 Phase C3 exit policy decoupled the protected `Jacobian` from any Picard / Differentials chain dependency, the remaining autonomous-loop scope is **not load-bearing for the 9 protected declarations** — only `nonempty_jacobianWitness` is. The remaining work is *blueprint-completeness commitment*.

**Trim alternatives considered**.

- *Aggressive trim* — drop all Phase B and Phase C work. Rejected: invalidates blueprint chapters; orphans the post-C1 monoidal-`X.Modules` `LineBundle X := (Skeleton X.Modules)ˣ`; less-useful project artifact.

- *Narrower L880+L897-only trim* — keep L175 in scope, defer L880 + L897 as named gaps. Documented but **not selected** because L880-forward + L897 are tractable (~3–5 iters combined) and produce concrete project content.

- **7 named Mathlib-gap sorries** in scope:
  1. `instIsMonoidal_W` (`Modules/Monoidal.lean` L173) — varying-ring `stalk_tensorObj` gap. Load-bearing post-C1.
  2. `cotangentExactSeq_structure.h_exact` (`Differentials.lean` L798) — sheaf-of-modules exactness criterion.
  3. `nonempty_jacobianWitness` (`Jacobian.lean` L179) — Hilbert/Quot schemes + finite-group quotients.
  4. `PicardFunctor.representable` (`Picard/Functor.lean` L181) — gated on C3.
  5. `SheafOfModules.pullback_tensorObj` (`Picard/LineBundle.lean` L82).
  6. `SheafOfModules.pullback_oneIso` (`Picard/LineBundle.lean` L96).
  7. `serre_duality_genus` (`Differentials.lean` L1039).
- **1 budget-deferred sorry**: `BasicOpenCech.lean` L1846 `h_loc_exact` Step 2 transport — NOT a Mathlib gap.

## Phase C3 exit policy (adopted iter-107)

**Adopted exit policy**: defer Phase C3 indefinitely via the `JacobianWitness`-witness pattern. The protected `Jacobian C`, `ofCurve P`, and downstream instances carry sorry-routed bodies that reduce to `Nonempty (JacobianWitness C)`, where `JacobianWitness C : Type` is a structure with a `sorry`-bodied existence at `Jacobian.lean:179`.

## End-state

`Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean` compile with **only the named Mathlib-gap sorries listed above + 1 budget-deferral** and **no new `axiom`**. The nine declarations in `archon-protected.yaml` carry the intended mathematical content **up to the JacobianWitness gap and the post-C1 load-bearing `instIsMonoidal_W` gap**.

## Path from today to the end-state

### Mid-term — Phase B prover work

Address `Differentials.lean` non-`h_exact` non-`serre_duality_genus` sorries (L175 unique-gluing helper, L880 forward+converse, L897 corollary).

### Mid-term — Phase C2 verification round

Read `Picard/Functor.lean` post-C1 + spot-check.

### Phase C3 — DEFERRED via `JacobianWitness` exit policy

## Soundness rule

**No helper lemma with a universally-false signature may be introduced**, even with a `sorry` body. Such a helper is logically an axiom; combined with `exact ... _` applications, it bypasses any subsequent goal.

[END VERBATIM STRATEGY.md]

(The full STRATEGY.md is on disk at `.archon/STRATEGY.md`; I have summarised the table cells slightly to fit this directive but not changed any strategic claim. Read the full file there if any cell needs more context.)

## References index

```
| File | Description |
| ---- | ----------- |
| challenge.lean | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in AlgebraicJacobian/ is a decomposition of this file; signatures here are authoritative. |
```

## Blueprint summary

(One line per chapter, `<filename>: <topic>`.)

- AbelJacobi.tex: The Abel–Jacobi map.
- Cohomology_MayerVietoris.tex: Mayer–Vietoris long exact sequence for sheaf cohomology with $k$-module coefficients.
- Cohomology_SheafCompose.tex: Sheaf condition along the structure-sheaf forget composite.
- Cohomology_StructureSheafAb.tex: Structure sheaf as a sheaf of abelian groups; sheafification and Ext.
- Cohomology_StructureSheafModuleK.tex: Sheaves of $k$-modules; sheafification, Ext, and the structure sheaf as a sheaf of $k$-modules.
- Differentials.tex: The sheaf of relative differentials.
- Genus.tex: Genus of a smooth proper curve.
- Jacobian.tex: The Jacobian as an abelian variety.
- Modules_Monoidal.tex: The symmetric monoidal category of $\mathcal O_X$-modules.
- Picard_Functor.tex: The relative Picard functor.
- Picard_FunctorAb.tex: The relative Picard functor as an abelian-group-valued presheaf.
- Picard_LineBundle.tex: Line bundles on schemes and the Picard group.
- Rigidity.tex: Rigidity for morphisms of group schemes (Mumford §4).

## Prior critique status

You were dispatched in iter-115 (`strategy-critic-iter115`); your verdict was 0 REJECT, 1 CHALLENGE on Phase B (aggregate decomposition arithmetic + L880-converse hypothesis description / closing-lemma name). Both must-fix items were addressed in STRATEGY.md edits during iter-115 (Phase B row + aggregate sentence): aggregate restated as conditional on the L880-converse outcome; L880-converse hypothesis correctly identified as `Subsingleton (Algebra.H1Cotangent R S)` (= formal smoothness / cotangent-cohomology vanishing), with the correct closing lemma `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` named.

**Specific re-verification asks for iter-116**:

1. The strategy is **unchanged from iter-115** (no edits this iter). The plan agent has paused the L175 lane via user escalation (USER_HINTS.md written this iter) and is dispatching no prover lane this iter. Do you still endorse the iter-115 strategy as-is, given that:
   - iter-115 prover returned INCOMPLETE on L175 (no closure; honest-stop before the iter-115 hard-rule trigger);
   - the iter-115 hard gate has now fired against the L175 route (5-iter sorry-trajectory stall + 4-of-5-iter recurring affine-basis-bridge blocker phrase);
   - the plan agent has escalated to the user with three options (invest in hand-rolled affine-basis sheaf bridge ~500–1500 LOC; refactor Phase B against the presheaf-only form; declare L175 as named gap #8).

2. Is the **conditional aggregate** in the Phase B row honest given the new evidence (L175 might itself need 5–10 extra iters of bridge work before it can close, *or* the project might pivot away from L175 entirely)? Should the aggregate be refined to enumerate per-option iter/LOC ranges?

3. Are there alternative routes the strategy still doesn't mention that a fresh reader would propose, given the L175 stall? Specific candidates the planner has considered but not codified in STRATEGY.md:
   - Option B from USER_HINTS.md (refactor Phase B against the presheaf-only form, dropping the sheaf-condition obligation entirely).
   - Option C from USER_HINTS.md (declare L175 as named gap #8 parallel to the existing 7).
   - L1846 in `BasicOpenCech.lean` re-opening as a Phase A wedge-task (budget-deferred per Option (i) of the iter-108 escape-valve menu, but mechanizable).

4. Any sunk-cost reasoning to flag in the strategy (the iter-115 critique cleared this; check again with fresh eyes given the L175 escalation)?

5. Verify the load-bearing Mathlib names cited in the strategy (Phase B row): `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`, `Algebra.IsStandardSmooth.free_kaehlerDifferential`, `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential`, `Subsingleton (Algebra.H1Cotangent R S)`, `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`. (`KaehlerDifferential.isLocalizedModule` and `AlgebraicGeometry.tilde` are re-verified iter-115; not asking again.)
