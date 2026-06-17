# Strategy-Critic Directive (iter-117)

## Slug

iter117

## Iteration

117

## What the user just asked the planner

The user wrote a fresh USER_HINTS.md (transcribed verbatim):

> It required some user hint, but I want you to find the best strategy yourself,
> you should remove all wrong mathematical statements and plan how to fill the
> gap it leaves. No wrong definition/proofs/signatures are accepted it should
> always be correct and never be temporarily wrong. Moreover the blueprints
> should be detailed enough to ensure that the provers have enough material.
> Moreover, the strategy file is too messy, it should be more clearly organize
> without making it an endless prose, it should focus on the strategy not
> enumerated all of the achievements in the previous steps, nothing should be
> deferred.

This is a fresh, substantive direction. The planner is composing a brand-new
STRATEGY.md to replace the current one and needs your critique BEFORE
committing it. Specifically the planner wants you to:

(a) audit the current STRATEGY.md (attached below) against the four
    user-stated criteria (autonomy, strict correctness, blueprint depth,
    clean organization, no deferrals),
(b) identify which parts of the current strategy stand under the new
    directive and which collapse,
(c) recommend a high-level shape for the replacement strategy
    consistent with the directive,
(d) name any specific Mathlib infrastructure gaps the planner must
    plan to fill rather than defer.

## Project goal (one paragraph)

The project formalizes the Jacobian of a smooth proper geometrically
irreducible curve over a field `k`, following Christian Merten's challenge
file `references/challenge.lean`. The 9 declarations in
`archon-protected.yaml` are the deliverables: `AlgebraicGeometry.genus`,
`AlgebraicGeometry.Jacobian`, the four `Jacobian` instances (`GrpObj`,
`SmoothOfRelativeDimension genus`, `IsProper`, `GeometricallyIrreducible`),
`Jacobian.ofCurve` (Abel-Jacobi), `Jacobian.comp_ofCurve`, and
`Jacobian.exists_unique_ofCurve_comp` (Albanese universal property).

## Current state (project total: 16 inline `sorry` sites)

Verified `sorry_analyzer.py` distribution:

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: 6 (L1120, L1212,
  L1536, L1564, L1754, L1846).
- `AlgebraicJacobian/Differentials.lean`: 5 (L191, L737, L931, L947, L1091).
- `AlgebraicJacobian/Modules/Monoidal.lean`: 1 (L173).
- `AlgebraicJacobian/Picard/LineBundle.lean`: 2 (L82, L96).
- `AlgebraicJacobian/Picard/Functor.lean`: 1 (L181).
- `AlgebraicJacobian/Jacobian.lean`: 1 (L179).

Dependency-graph reality (verified `dependency_graph.py`): the protected
chain depends transitively on ONLY ONE of these sorries —
`nonempty_jacobianWitness` at `Jacobian.lean:179`. The other 15 sorries
are project-content orphans (Differentials cotangent API, Picard arc,
Čech basic-open machinery, monoidal `X.Modules` framework). Removing them
does not break a single protected declaration.

## References summary

`references/summary.md`:

> | File | Description |
> | ---- | ----------- |
> | `challenge.lean` | Original AI challenge file by Christian Merten — the
> formal statement of the missing definitions and theorems for the Jacobian
> of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a
> decomposition of this file; signatures here are authoritative. |

## Blueprint chapter index

(One-line topic per chapter from `blueprint/src/chapters/*.tex`.)

- `Rigidity.tex` — Mumford rigidity for pointed proper smooth morphisms.
- `Genus.tex` — Definition of `genus C := dim_k H^1(C, O_C)`.
- `Jacobian.tex` — `Jacobian C` via Albanese witness; the four `Jacobian`
  instances; `IsAlbanese` and the `JacobianWitness` structure.
- `AbelJacobi.tex` — `Jacobian.ofCurve`, `comp_ofCurve`,
  `exists_unique_ofCurve_comp`.
- `Cohomology_SheafCompose.tex` — Composition of sheaves with forgetful
  functors (project-local API).
- `Cohomology_StructureSheafAb.tex` — `O_X` viewed as an abelian-group
  sheaf.
- `Cohomology_StructureSheafModuleK.tex` — `O_X` viewed as a `k`-module
  sheaf (for the `Genus` definition).
- `Cohomology_MayerVietorisCore.tex` /
  `Cohomology_MayerVietorisCover.tex` — Mayer-Vietoris foundations + the
  cover construction (project-local Čech infrastructure).
- `Differentials.tex` — Relative Kähler differentials `Ω_{X/S}` of a
  morphism of schemes, the cotangent exact sequence, smoothness ↔ local
  freeness of `Ω`, and the Serre-duality genus equality.
- `Modules_Monoidal.tex` — Monoidal structure on `X.Modules` via
  sheafification localization.
- `Picard_LineBundle.tex` — `LineBundle X` as units of `Skeleton X.Modules`;
  `Pic.pullback`.
- `Picard_Functor.tex` — Picard functor and representability.
- `Picard_FunctorAb.tex` — Abelian-group lift of the Picard functor.

## The current STRATEGY.md (verbatim)

```markdown
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
| B — Cotangent sheaves (`Differentials.lean`) | **conditional on user response to iter-116 escalation; per-option ranges below** | see left | 5 sorries. **Iter-110 reclassification**: L1039 `serre_duality_genus` named-deferred (7th gap; ~3000–8000 LOC from first principles is out of scope). L798 `h_exact` continues deferred parallel to `instIsMonoidal_W`. **Phase B autonomous-loop scope is 3 sorries** (L175, L880, L897), broken down below. **L175 status (iter-116 USER ESCALATION)**: the iter-115 hard gate fired against the L175 lane after 5 consecutive iters of 0 sorries closed and a verified missing-Mathlib-bridge blocker (`Scheme.PresheafOfModules` on affine basis ⇒ sheaf on $X$, persistent rationale `analogies/affine-basis-sheaf-bridge.md`). Iter-116 plan-phase wrote `USER_HINTS.md` requesting a decision among three options; until the user responds, **L175 is paused and no Phase B prover lane is dispatched**. Per-option L175 cost: **(Option 1, build the Mathlib-style bridge)** ~5–10 iters / ~500–1500 LOC (multi-file infra build of `PresheafOfModules.IsSheafOnBasis ⇒ IsSheaf` for affine-chart basic-open bases, then composing Step 1 affine identification + the bridge to close L175); **(Option 2, refactor Phase B against the presheaf-only form)** ~1–2 iters refactor + L880/L897 budgets below — the L175 obligation evaporates because downstream consumers (`smooth_iff_locally_free_omega`, `cotangent_at_section`) get rewritten in terms of "locally-free as a module on each affine chart" which is the genuine mathematical content; **(Option 3, declare L175 named gap #8 and proceed against the presheaf-only form)** ~0 iters for L175 itself; downstream Phase B work proceeds as in Option 2 against `Ω_{X/S}` formally a presheaf. The L880 and L897 estimates below are **independent of the L175 option** (none of them depend on L175 being closed; L897 historically depends on L880-forward). (i) **L897 `cotangent_at_section`** — moderate (~1–2 iters / ~50–100 LOC, corollary of L880-forward via pullback preservation of locally-free; rephrased on the presheaf-only side under Option 2/3 with the same content). (ii) **L880 `smooth_iff_locally_free_omega`** — **decomposed iter-114 into forward + converse** per strategy-critic-iter114 CHALLENGE on the original under-counted ~2–4 iter / ~200 LOC estimate. **Forward direction `smooth_imp_locally_free_omega`** (~2–3 iters / ~100–200 LOC): direct from `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` [verified] + `Algebra.IsStandardSmooth.free_kaehlerDifferential` [verified] on affine charts, threaded through `AlgebraicGeometry.isSmoothOfRelativeDimension_iff` [verified, **strategy-critic-iter116 bonus finding**] for the algebra-to-scheme translation. **Converse direction `locally_free_omega_imp_smooth`** (~3–6 iters / ~200–500 LOC): Hartshorne II.8.15 converse. **Correct closing lemma**: `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` [verified] (`Mathlib.RingTheory.Smooth.StandardSmoothOfFree`), with hypotheses (i) `Algebra.FinitePresentation R S`, (ii) `Subsingleton (Algebra.H1Cotangent R S)` (= formal smoothness / cotangent-cohomology vanishing — *this is the genuine deformation-theoretic content*, NOT "flatness"), (iii) a basis whose elements are in `Set.range (KaehlerDifferential.D R S)`. **Strategy-critic-iter116 bonus finding**: `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential` [verified] (`Mathlib.RingTheory.Smooth.StandardSmoothOfFree`) is the **full biconditional under `[FinitePresentation R S]`** (`IsStandardSmooth R S ↔ Subsingleton (H1Cotangent R S) ∧ ∃ I b, range b ⊆ range (KaehlerDifferential.D R S)`); using this Mathlib biconditional collapses the manual forward/converse reassembly. Combined with `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth` [verified], the project lands at `IsStandardSmoothOfRelativeDimension n R S ↔ <conditions>` in one less rebuild step. The genuine hard step on the converse is exhibiting `[Subsingleton (H1Cotangent R S)]` from a Ω-locally-free hypothesis at the chart level + the chart-by-chart construction lifted to scheme level. **Recommended dispatch order under each L175 option**: under **Option 1**, dispatch the bridge-build first (Phase B halts on L175 until the bridge lands), then resume L880-forward / L897 / L880-converse. Under **Option 2**, dispatch the refactor first (rewrite `relativeDifferentialsPresheaf` consumers), then L880-forward, then L897 (gated on L880-forward landing), then L880-converse. Under **Option 3**, dispatch L880-forward immediately (L175 is stub-and-disclose), then L897, then L880-converse. **Aggregate per option** (lower range applies if L880-converse fires the narrower-trim escape — declare `locally_free_omega_imp_smooth` as named gap #9 — upper range if closed in-loop): Option 1 = ~10–18 iters / ~750–1900 LOC (lower) or ~13–24 iters / ~1000–2400 LOC (upper); Option 2 = ~6–10 iters / ~350–700 LOC (lower) or ~9–16 iters / ~600–1300 LOC (upper); Option 3 = ~5–8 iters / ~250–600 LOC (lower) or ~8–14 iters / ~500–1200 LOC (upper). |
| C0 — Monoidal `X.Modules` | — | 0 | `instIsMonoidal_W` deferred (Mathlib gap `stalk_tensorObj` for varying-ring R₀). **Status update post-mathlib-analogist-c1-route iter-108**: this sorry is currently *dormant* (no active proof DAG consumes it pre-C1) but will become **load-bearing for the entire Pic-and-down arc post-C1 promotion**. The named-gap *count* is unchanged; the *transitive reach* of the sorry expands dramatically. End-state framing must add a load-bearing disclosure paragraph mirroring the `JacobianWitness` honest-accounting. |
| C1 — Refined `LineBundle` | **DONE iter-109** | ~0 | C1 promotion COMPLETE iter-109 via `refactor` subagent + iter-109 prover round. Body `LineBundle X := (Skeleton X.Modules)ˣ` (bare form, no `Shrink` wrapper needed: `X.Modules` lives in `Type (u+1)`); `instCommGroupLineBundle` derives via `BraidedCategory (X.Modules)` chain (transitive on `instIsMonoidal_W`). `Pic.pullback` closed via hand-construction through `(Scheme.Modules.pullback f).mapSkeleton` consuming the iter-109-introduced **named-deferred pair** (`SheafOfModules.pullback_tensorObj` L82 = `μ`-iso; `SheafOfModules.pullback_oneIso` L96 = `ε`-iso). Both collapse together when a future Mathlib refresh lands `(SheafOfModules.pullback _).Monoidal`. Cascading universe bumps on `PicardFunctor` codomain (`Type u` → `Type (u+1)`) and `PicardFunctorAb` codomain (`AddCommGrpCat.{u}` → `AddCommGrpCat.{u+1}`) absorbed cleanly; `etaleSheafified` body simplified by one functor composition (pre-C1 lift now unnecessary). Persistent rationale: `analogies/c1-route.md`. |
| C2 — `PicardFunctor` re-derivation | ~0–4 | ~0–80 | Largely absorbed by iter-109 universe bumps. Existing `fiberMap`/`quotMap`/etale-sheafification compile against the new `LineBundle` with no new sorries beyond the C3-deferred `representable`. **Iter-110+ verification round** required (cheap intel per strategy-critic-iter110 ordering ask): read `Picard/Functor.lean` post-C1 + spot-check whether `fiberMap`/`quotMap` need content re-derivation OR are already correct against the iter-109 LineBundle. Likely outcome: no further work needed (the C2 estimate collapses from 4–6 iters to 0). |
| C3 — Representability / `JacobianWitness` | DEFERRED via JacobianWitness exit policy | — | Strategy-critic-iter105 REJECT on original estimate (10–15 iters / ~1500 LOC wildly under-counted; realistic 50–150 iters / 5,000–15,000 LOC for either FGA-Hilbert or `Sym^g/S_g`). `nonempty_jacobianWitness` sorry at `Jacobian.lean:179` is the single named gap on Hilbert/Quot schemes + finite-group quotients (both confirmed absent from Mathlib b80f227). |
| D, E — `genus`/`Jacobian`/instances + Abel–Jacobi | 0 | 0 | File-level closure (no inline `sorry`); content-level BLOCKED-ON-C3-WITNESS. |

**Aggregate (revised iter-116 per strategy-critic-iter116 CHALLENGE on the prior aggregate not branching on the L175 user-escalation outcome)**: see Phase B row for per-option L175 cost. The aggregate now branches on **two** independent dimensions: **L175 fate** (Option 1 build the bridge / Option 2 refactor / Option 3 named gap #8) and **L880-converse fate** (in-loop / named-gap escape). Cross-product:

| L175 option × L880-converse fate | Iters | LOC |
|---|---:|---:|
| Option 1 × converse-named-gap | ~10–18 | ~750–1900 |
| Option 1 × converse-in-loop | ~13–24 | ~1000–2400 |
| Option 2 × converse-named-gap | ~6–10 | ~350–700 |
| Option 2 × converse-in-loop | ~9–16 | ~600–1300 |
| Option 3 × converse-named-gap | ~5–8 | ~250–600 |
| Option 3 × converse-in-loop | ~8–14 | ~500–1200 |

The remainder is dominated by Phase B (Phase A residual is gated and not on the schedule, but L1846 reactivation is on the table as a fallback wedge-task if the user picks Option 1 with a long bridge build that has cheap interleaved iters; Phase C2 verification round is cheap intel collapsing to ~0). Phase C3 deferred. The final project terminates with the following sorry-disclosure structure:

**Scope rationale (added iter-112 per strategy-critic-iter112 CHALLENGE; reframed iter-114 per strategy-critic-iter114 sunk-cost reframe)**. After the iter-107 Phase C3 exit policy decoupled the protected `Jacobian` from any Picard / Differentials chain dependency, the remaining autonomous-loop scope (Phase B non-`h_exact` non-`serre_duality_genus` sorries; Phase C2 verification; post-C1 disclosure tracking) is **not load-bearing for the 9 protected declarations** — only `nonempty_jacobianWitness` is. The remaining work is *blueprint-completeness commitment*: the project's blueprint chapters (`Differentials.tex`, `Picard_*.tex`, `Modules_Monoidal.tex`) describe a sheaf-theoretic Jacobian-and-Picard framework whose Lean targets we ship even though the protected-declaration chain currently bottoms out at the JacobianWitness gap.

**Trim alternatives considered**. Five distinct trim options have been considered (iter-116 expanded the menu per strategy-critic-iter116 must-fix on missing Options 2 and 3 from the user-facing escalation):

- *Aggressive trim* — drop all Phase B and Phase C work, ship only the protected-chain. Rejected because doing so would (i) invalidate the blueprint chapters as committed-but-unformalized; (ii) leave the post-C1 monoidal-`X.Modules` `LineBundle X := (Skeleton X.Modules)ˣ` orphaned, whereas it is *the* correct sheaf-theoretic definition (the merit-frame here is current mathematical correctness of the definition — independent of the path the project took to land it); (iii) make the project a less-useful artifact for whoever picks it up once Mathlib's algebraic-geometry foundations are deeper.

- *Narrower L880+L897-only trim* (strategy-critic-iter114 alternative) — keep L175 in scope (the load-bearing residual of the iter-113 unique-gluing pivot), and defer L880 + L897 as **named gaps #8 / #9** parallel to the existing 7. Documented but **not selected** because: (a) L880-forward + L897 are tractable (~3–5 iters combined) and produce concrete project content (the smoothness ↔ Ω-locally-free criterion is *the* characterisation cited by both Hartshorne and Stacks); (b) only L880-converse is genuinely heavy; (c) the project's converse-direction obligation is mathematically standard (Nakayama + standard-smooth-chart reconstruction) and not phantom Mathlib infrastructure. **Open option** (still live): if iter-117+ progress-critic reports CHURNING on L880-converse for 2+ iters, the narrower trim fires: declare `locally_free_omega_imp_smooth` as named gap #9 (Mathlib-gap: no `Algebra.IsStandardSmoothOfRelativeDimension.of_free_kaehlerDifferential` reverse direction in Mathlib b80f227), keep the iff-form helper sorry-stubbed in the soundness-rule-compliant way, and ship the disclosure paragraph.

- *Option 2 — refactor Phase B against the presheaf-only form* (added iter-116 per strategy-critic-iter116 critical finding; user-facing in `USER_HINTS.md`). The L175 sheaf condition is currently load-bearing only on `cotangent_at_section`; if Phase B's downstream consumers (`smooth_iff_locally_free_omega`, `cotangent_at_section`) are rewritten in terms of "locally-free as a module on each affine chart" (the genuine mathematical content) rather than against `Ω_{X/S}` packaged as a `SheafOfModules`, the L175 obligation evaporates entirely. This *bypasses* the missing-Mathlib-bridge gap rather than building infrastructure to fill it. It is also better-aligned with Mathlib's algebra-side framing: `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential` is stated in algebra-Ω terms, and `AlgebraicGeometry.isSmoothOfRelativeDimension_iff` quantifies over affine charts — so the project's natural framing is *already* presheaf-on-affine-charts; the iter-113 sheaf pivot is a detour. Cost: ~1–2 iters of refactor planning + 1 iter of refactor execution + the existing L880/L897 budget. **Status**: live user option in `USER_HINTS.md`; awaiting user response.

- *Option 3 — declare L175 as named gap #8 and proceed against the presheaf-only form* (added iter-116 per strategy-critic-iter116 major finding; user-facing in `USER_HINTS.md`). Stub L175 with `sorry`, annotate as named Mathlib gap #8, document the disclosure in End-state, and proceed with L880 / L897 against `Ω_{X/S}` formally a presheaf. The mathematical content of downstream consumers is identical to Option 2; only the named-gap count increments (8 named gaps + 1 budget-deferral instead of 7 + 1). The cost difference vs Option 2 is the absence of the refactor — strictly cheaper at the cost of one more disclosure entry. **Status**: live user option in `USER_HINTS.md`; awaiting user response.

- *Option 1 — invest in a hand-rolled affine-basis sheaf bridge for `Scheme.PresheafOfModules`* (added iter-116; user-facing in `USER_HINTS.md`). Build the `PresheafOfModules.IsSheafOnBasis ⇒ IsSheaf` bridge as a multi-file Mathlib-style infrastructure addition (~500–1500 LOC across 2–4 new files), then close L175 by composition with the Step-1 affine identification. **Status**: live user option in `USER_HINTS.md`; awaiting user response. The autonomous loop's default if the user does not respond is the iter-115 review-recommended Option A (route pivot); see "Path from today" for the fallback execution.

The strategy schedules Phase B and Phase C2 because the **blueprint's content commitment** says so, not because the protected chain requires them. A fresh reader should understand: the autonomous loop ships project-content beyond the strict protected set, with the protected chain itself dependent on exactly one named witness gap.

- **7 named Mathlib-gap sorries** in scope (mathlib-analogist-serre-duality-iter110 added serre_duality_genus):
  1. `instIsMonoidal_W` (`Modules/Monoidal.lean` L173) — varying-ring `stalk_tensorObj` gap. **Load-bearing post-C1** for the entire Pic-and-down arc.
  2. `cotangentExactSeq_structure.h_exact` (`Differentials.lean` L798) — sheaf-of-modules exactness criterion (Mathlib gap). Deferred parallel to `instIsMonoidal_W`.
  3. `nonempty_jacobianWitness` (`Jacobian.lean` L179) — Hilbert/Quot schemes + finite-group quotients. Phase C3 exit policy.
  4. `PicardFunctor.representable` (`Picard/Functor.lean` L181) — gated on C3.
  5. `SheafOfModules.pullback_tensorObj` (`Picard/LineBundle.lean` L82) — `(pullback f).obj (M ⊗ N) ≅ (pullback f).obj M ⊗ (pullback f).obj N`. The `μ`-iso of an absent `(SheafOfModules.pullback _).Monoidal` instance.
  6. `SheafOfModules.pullback_oneIso` (`Picard/LineBundle.lean` L96) — `(pullback f).obj (𝟙_ Y.Modules) ≅ 𝟙_ X.Modules`. The `ε`-iso of the same absent monoidal instance; sibling to (5). Both collapse simultaneously when Mathlib lands the monoidal instance.
  7. `serre_duality_genus` (`Differentials.lean` L1039) — **NEW iter-110 reclassification** per mathlib-analogist-serre-duality. Closure from first principles would require ~3000–8000 LOC (trace morphism for proper morphisms + dualizing sheaf + duality pairing + perfect-pairing argument — Hartshorne-chapter scope). Mathlib b80f227 has NO Serre duality, NO dualizing sheaf, NO trace morphism for proper morphisms, and NO Zariski coherent cohomology of `O_X`-modules (only ℓ-adic on the pro-étale site). Out of scope for the autonomous loop; named-deferred parallel to (1)–(4). Persistent rationale: `analogies/serre-duality.md`.
- **1 budget-deferred sorry**: `BasicOpenCech.lean` L1846 `h_loc_exact` Step 2 transport — `-- DEFERRED (budget): ...` annotation per Option (i) of the iter-108 escape-valve menu. **NOT a Mathlib gap.** Provable from existing Mathlib (`IsLocalizedModule.{Away,pi,prodMap}` + algebra adapter); mechanization parked behind Phase B priorities.

The named-gap count is **7** (was 5 mid-iter-109; +1 for `pullback_oneIso` sister-gap split; +1 iter-110 for `serre_duality_genus` reclassification). The pair (5, 6) is a single underlying Mathlib gap recorded as two project-side sorries because the surface API needs both iso-witnesses to construct `Pic.pullback` by hand-bundling.

**Load-bearing-vs-orphan split of the 7 named gaps (added iter-112 per strategy-critic-iter112)**. Of the 7 named gaps, exactly **one is load-bearing on the 9 protected declarations**:

- `nonempty_jacobianWitness` (gap #3) — the JacobianWitness exit policy routes every protected `Jacobian.*` / `AbelJacobi.*` declaration through this single existence sorry; `lean_verify` on any protected signature surfaces `sorryAx` rooted here.

The other **6 are orphan disclosures** — honest project-content sorries that no protected-chain `lean_verify` will surface but that the blueprint commits to as named project-content:

- (1) `instIsMonoidal_W` — load-bearing on the **Picard arc** (`Pic`, `Pic.pullback`, `PicardFunctor`, `PicardFunctorAb`), not on any protected `Jacobian` declaration.
- (2) `cotangentExactSeq_structure.h_exact` (L798) — load-bearing on the **cotangent exact sequence theorem** (project content, not in the protected chain).
- (4) `PicardFunctor.representable` — load-bearing on the **Picard representability theorem** (project content, not in the protected chain; gated on C3 + iter-109 sister pair).
- (5) `SheafOfModules.pullback_tensorObj` — load-bearing on `Pic.pullback` (project content via Picard arc).
- (6) `SheafOfModules.pullback_oneIso` — sibling to (5); same situation.
- (7) `serre_duality_genus` — forward-compatibility named-deferral; no current protected signature consumes this.

So the actual delivery surface vis-à-vis the protected chain is **1 load-bearing named gap + 1 budget-deferral**, with **6 orphan-disclosure named gaps** documenting honest project-content work the autonomous loop ships against the blueprint's commitments. A reader counting gaps for "what stands between the project and shipping the 9 protected declarations" should read **1** (gap #3); a reader counting gaps for "what stands between the project and full blueprint-content closure" should read **7 + 1 budget-deferral**.

## What's unconditional vs framework-conditional (explicit enumeration)

Added iter-109 per strategy-critic-iter109 Q3; expanded explicitly iter-110 per strategy-critic-iter110 Q3 ask. For a fresh reader of the end-state, the named-gap surface splits the project's deliverables into three layers:

- **Unconditional core (compiles end-to-end with no `sorryAx` in the axiom chain)**:
  - `Rigidity.lean` (Mumford rigidity).
  - `Genus.lean`'s definition `AlgebraicGeometry.genus` (= `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`).
  - The Čech-cohomology infrastructure under `Cohomology/*.lean` (modulo the 6 budget/Mathlib-infra-blocked transient sorries in `BasicOpenCech.lean` — these are off-loop and don't enter the unconditional chain).
  - `Differentials.lean`'s cotangent API (modulo `h_exact` and the 4 non-`h_exact` Phase B sorries which are *not yet* in the chain — they will join one of the conditional layers once formalized).
  - `Picard/FunctorAb.lean`'s additive-group wrapping.
- **Framework-conditional on `nonempty_jacobianWitness`** (= conditional on Hilbert/Quot or finite-group-quotient gap-fills):
  - `Jacobian.lean`'s protected signatures (`Jacobian C`, `ofCurve`, four `Jacobian` instances).
  - `AbelJacobi.lean`'s `ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`.
  - `lean_verify` on these surfaces `sorryAx` rooted at `Jacobian.lean:179`.
- **Framework-conditional on `instIsMonoidal_W` + the iter-109 sister pair**:
  - `Picard/LineBundle.lean`'s `Pic`, `instCommGroupLineBundle` (transitive on `instIsMonoidal_W` only).
  - `Picard/LineBundle.lean`'s `Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp` (transitive on `instIsMonoidal_W` AND the pair `pullback_tensorObj` + `pullback_oneIso`).
  - `Picard/Functor.lean`'s `PicardFunctor`, `fiberMap`, `quotMap` (transitive on `instIsMonoidal_W` AND the pair, via `Pic.pullback`).
  - `Picard/FunctorAb.lean`'s `etaleSheafified`-derived terms (transitive on the same).
  - `lean_verify` on these surfaces `sorryAx` chains rooted at `Modules/Monoidal.lean:173` and `Picard/LineBundle.lean:{82,96}`.
- **Framework-conditional on `serre_duality_genus` (iter-110 reclassification)**: any future downstream consumer that bridges `genus` (= `dim_k H¹(C, O_C)`) to the cotangent-side `dim_k H⁰(C, Ω_{C/k})`. None of the current protected signatures consume this; it is a forward-compatibility named-deferral.
- **Multi-gap-conditional**: `Picard/Functor.lean`'s `representable` (gated on C3 + the iter-109 pair).

The autonomous loop ships *all* layers above. The unconditional core is a non-trivial mathematics-content delivery; the framework-conditional layers are structurally well-formed APIs against named witnesses. The end-state's named-sorry surface (6 Mathlib gaps + 1 budget-deferral) is the full disclosure for a fresh reader.

## Phase A escape-valve menu — RESOLVED iter-108 with Option (i)

Iter-109 (narrative) prover delivered the second consecutive PARTIAL on L1846, triggering the iter-107 strategy-critic exit criterion. Iter-108 (Archon canonical) plan-agent fired Option (i) per the canonical decision tree:

- **Option (i) chosen**: defer L1846 with `-- DEFERRED (budget): ...` annotation. Per strategy-critic-iter108 CHALLENGE, the labelling is `DEFERRED (budget)`, NOT `MATHLIB GAP` — Mathlib has the building blocks. The inline iter-108 + iter-109 narrative scaffolding (Steps 1a–1c at L1786–L1834) is preserved as inert infrastructure.
- **Option (ii) deferred to iter-109 narrative**: C1 promotion. The strategy-critic-iter108 alternative recommendation to fire C1 *concurrently* with Option (i) was rebutted in `iter/iter-108/plan.md` on the basis that the same critic's minor finding (`MonoidalCategory.Invertible` NOT FULLY VERIFIED) required a mathlib-analogist consult before the refactor; the analogist dispatched THIS iter returned with critical must-fix findings (target name, load-bearing transition, pullback gap) that materially reshape the refactor's scope and would have caused a flawed iter-108 firing. **C1 fires iter-109 informed by the analogist.**
- **Option (iii) not selected**: mathlib-analogist re-consult on a different L1846 decomposition. Not needed: the strategy-critic-iter108 confirmed L1846 is mechanizable from existing Mathlib; the `letI`-in-goal-type friction is a Lean elaboration ergonomics issue, not a structural blocker. Future re-attempt (when scheduled) should consider `IsLocalizedModule.mk` term-mode construction per the iter-109 prover's named alternative path (ii).

## Phase C3 exit policy (adopted iter-107)

The strategy-critic-iter105 audit returned REJECT on Phase C3 with the argument that both proposed routes (FGA-via-Hilbert; `Sym^g C / S_g`) require constructing Mathlib infrastructure (Hilbert scheme; finite-group scheme quotient) that is a Hartshorne-chapter-sized undertaking (~5,000–10,000 LOC each), wildly exceeding the project's stated estimate.

**Adopted exit policy**: defer Phase C3 indefinitely via the `JacobianWitness`-witness pattern. The protected `Jacobian C`, `ofCurve P`, and downstream instances (`GrpObj`, `IsProper`, `GeometricallyIrreducible`, `SmoothOfRelativeDimension`) carry sorry-routed bodies that reduce to `Nonempty (JacobianWitness C)`, where `JacobianWitness C : Type` is a structure with a `sorry`-bodied existence at `Jacobian.lean:179`. This is **mathematically honest**: the project delivers a *framework* for the Jacobian (genus, Picard functor, all instance plumbing) that bottoms out in a single named Mathlib gap.

The strategy-critic's "divisor-class-image Pic⁰" alternative (avoiding both Hilbert and Sym^g via scheme-theoretic image of `C^g → Pic^g` + Riemann–Roch effective theory) is documented as a future-work option for whoever picks up the project after Mathlib's algebraic-geometry foundations are deeper. It is NOT selected as a within-scope route because the prerequisite infrastructure (scheme-theoretic image API; Riemann–Roch effective theory; birational-image-is-group-scheme) is itself missing from Mathlib b80f227.

## End-state

`Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean` compile with **only the named Mathlib-gap sorries listed above + 1 budget-deferral** and **no new `axiom`**. The nine declarations in `archon-protected.yaml` carry the intended mathematical content **up to the JacobianWitness gap and the post-C1 load-bearing `instIsMonoidal_W` gap**, with all other infrastructure (Čech cohomology, cotangent sheaves, sheafified Picard functor, refined LineBundle) delivered.

**Plain-language disclosure of the End-state for the human reader** (strategy-critic-iter106 CHALLENGE accepted, extended iter-108 with mathlib-analogist-c1-route findings):

The protected `Jacobian C`, `ofCurve`, and the four `Jacobian` instances (`grpObj`, `smooth_genus`, `proper`, `geomIrred`) compile against a `Nonempty (JacobianWitness C)` witness whose existence sorry is at `Jacobian.lean:179` (`nonempty_jacobianWitness`). **The project ships a Jacobian *framework*, conditional on the witness — it does NOT autonomously construct the Jacobian.** A fresh reader of the final project state should understand: "did you build the Jacobian of a smooth proper curve?" answers as "no, we built every Jacobian-derived instance + AbelJacobi morphism + downstream consequences AGAINST the named existence hypothesis `nonempty_jacobianWitness`, which itself rests on Mathlib gaps (Hilbert / Quot schemes; finite-group scheme quotients)".

**Additional disclosure (post-C1, iter-108 mathlib-analogist-c1-route)**: the project also ships a *Picard framework*, conditional on the Mathlib gap `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗ N.stalk x` (varying-ring R₀). Specifically: post-C1 promotion, the protected `Pic`, `Pic.pullback`, `PicardFunctor`, `PicardFunctorAb`, the C2 étale-sheafified Picard functor, and downstream consumers in `Jacobian.lean` / `AbelJacobi.lean` will type-check against `BraidedCategory (X.Modules)`, hence transitively against `instIsMonoidal_W` (the deferred `(W X).IsMonoidal` sorry at `Modules/Monoidal.lean` L173). Pre-C1, this sorry is dormant (no active proof DAG consumes it because LineBundle currently uses the `CommRing.Pic Γ(X, ⊤)` approximation that bypasses `X.Modules`'s monoidal structure). Post-C1, it becomes load-bearing. The disclosure mirrors the JacobianWitness one: "did you build the Picard framework on top of the *correct* sheaf-theoretic LineBundle?" answers as "yes, but the framework type-checks transitively against the named Mathlib gap on stalk-of-presheaf-tensor in the varying-ring setting; the `Pic`/`PicardFunctor` API is well-formed and well-typed but `lean_verify` will surface `sorryAx` in their axiom chains".

The autonomous loop terminates at this honest framing; both the Jacobian construction and the load-bearing `instIsMonoidal_W` Mathlib gap are left for whoever picks up the project once Mathlib's algebraic-geometry foundations are deeper. (Strategy-critic-iter106: "Jacobian framework conditional on `nonempty_jacobianWitness`" ≠ "Jacobian constructed". Mathlib-analogist-iter108: post-C1 the Picard arc carries the same conditional framing on `instIsMonoidal_W`.)

**What's unconditional vs framework-conditional (strategy-critic-iter109 Q3 / iter-110 Q3 expansion)**: see the explicit `## What's unconditional vs framework-conditional` section above (added iter-109; explicit enumeration iter-110). The two stacked conditionals (`nonempty_jacobianWitness` for the Jacobian arc; `instIsMonoidal_W` plus the iter-109 sister pair for the post-C1 Pic-and-down arc) do **not** make the entire project conditional — the unconditional core (Rigidity, Genus definition, Čech-cohomology API, Differentials cotangent API modulo the parked sorries, FunctorAb additive wrapping) is a non-trivial mathematics-content delivery.

## Honest assessment of Phase A (Archon iter-108 / narrative iter-110 status)

The `cechCofaceMap_pi_smul` lane (L1120) is **PAUSED** per progress-critic-iter106/107/108 STUCK verdicts: 7 consecutive PARTIAL iters on the same root cause + 2 successfully observed PAUSED iters (iter-108 + iter-109 narrative). The iter-107 partial-proof scaffold (including `have h_iter104` at L1119) is preserved byte-for-byte. **Wrapper engineering AND body-level inlining of the same `Pi.lift` compositional approach are both committed to NOT be repeated.** A future revisit must come via either Q2 Path B (`set F := cechCofaceMap_summand_family s₀ n` at top of body + `change`) or Q2 Path A (architectural refactor to `ModuleCat R`); both routes documented in `analogies/finite-product-localisation-and-cech-r-linearity.md`.

The L1846 `h_loc_exact` lane was **active iter-108 + iter-109 narrative under the analogist Q1 ALIGN_WITH_MATHLIB recipe**, with both iters delivering PARTIAL outcomes (Steps 1a + 1b iter-108; Step 1c iter-109; ~50 LOC inline scaffolding accreted across the two iters). The iter-107 strategy-critic exit criterion fired iter-108 (Archon canonical), and the **escape-valve menu Option (i) executed THIS iter**: trailing sorry at L1846 annotated as `-- DEFERRED (budget): ...` per strategy-critic-iter108 CHALLENGE. The inline scaffolding stays as inert infrastructure for a future re-attempt. **Phase A status (revised iter-116 per strategy-critic-iter116 sunk-cost flag)**: parked behind Phase B priorities; **if Phase B is paused for >2 iters by the iter-116 user escalation, L1846 reactivation is on the table as a fallback wedge-task** (mechanizable from existing Mathlib per strategy-critic-iter108 verification; not a Mathlib gap). The iter-110 framing of "closed-out for the autonomous loop's scope" was correct under the budget pressure of Phase B competing for iter slots; with Phase B now paused, that pressure is lifted and the L1846 line is no longer permanently parked. The deferred sub-step sorries L1212/L1536/L1564 remain off-path (their substep-predecessor dependencies — augmented Čech complex, K → K₀ transport — are project-local rather than Mathlib gaps, but their predecessors are themselves off-path, so they stay deferred).

## Mathlib gaps in scope

| Gap | Phase | Plan |
|---|---|---|
| Stalkwise criterion for `SheafOfModules` exactness | B | Both routes confirmed Mathlib-gap blocked (iter-086 audit). `h_exact` deferred parallel to `instIsMonoidal_W`. |
| `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗ N.stalk x` (varying-ring `R₀`) | C0 / **load-bearing post-C1** | Defer indefinitely. Pre-C1: dormant. Post-C1: load-bearing for entire Pic-and-down arc. Honest-disclosure framing in End-state above. |
| Sheaf cohomology `Hⁱ(X, F)` for quasi-coherent sheaves | A | Project-local `HModule`/`HModule'` via `Abelian.Ext` (built iter-003–008). |
| `IsLocalizedModule.Away f.1` on finite products of restricted basic-opens | A — **NO LONGER A GAP** | Strategy-critic-iter108 verified: Mathlib has `IsLocalizedModule.{Away,pi,prodMap}` + adapter. L1846 mechanizable. **Removed from named-gaps list iter-108 (was previously scheduled as conditional 4th gap)**; reclassified as budget-deferral with `-- DEFERRED (budget):` annotation per Option (i). |
| `Functor.Monoidal (Scheme.Hom.pullback f)` for `SheafOfModules` | C1 (NEW, iter-108) | Absent from Mathlib b80f227 (analogist-c1-route verified). C1 refactor commits upfront to default option (c): named-deferral via standalone `SheafOfModules.pullback_tensorObj` sorry. Adds 5th named gap to end-state. Alternative options (a) build the `Functor.Monoidal` instance (multi-iter, multi-hundred LOC) or (b) hand-build the iso (smaller scope; same content) are documented but not selected. |
| Hilbert / Quot schemes | C3-DEFERRED | Phase C3 deferred via JacobianWitness exit policy. |
| Finite-group quotients of schemes | C3-DEFERRED | Same. |
| Riemann–Roch effective theory + scheme-theoretic image (for divisor-class-image alternative) | C3-DEFERRED | Mathlib gap; the strategy-critic-suggested "divisor-class-image Pic⁰" route is documented but not selected. |

## Path from today to the end-state

### Iter-116 (THIS iter — deeper-think iter, no prover lane; user escalation on L175)

Per the iter-115 hard gate firing on the L175 unique-gluing route + the iter-115 review's Option B recommendation, iter-116 dispatches NO prover round. Instead:

- **`USER_HINTS.md` written**: requests user response to a 3-option fan on L175 — (1) build a Mathlib-style affine-basis sheaf bridge (~500–1500 LOC); (2) refactor Phase B against the presheaf-only form; (3) declare L175 as named Mathlib gap #8. Detailed cost estimates per option are in the Phase B row above.
- **3 mandatory critics dispatched** (strategy-critic-iter116 returned CHALLENGE on Phase B with ≥2 must-fix items; blueprint-reviewer-iter116 returned PASS-WITH-MINOR-FIXES with 1 chapter `correct: partial` due to cosmetic Mathlib name slips; progress-critic-iter116 dispatched after these two returned).
- **1 thin blueprint-writer dispatched** for the 2 cosmetic Mathlib name slips in `Differentials.tex` (L59 `KaehlerDifferential.isLocalizedModule_map` → drop `_map`; L73 `AlgebraicGeometry.Modules.tilde` → `AlgebraicGeometry.tilde`) — orthogonal to the strategic decision.
- **STRATEGY.md edits this iter** absorb the strategy-critic-iter116 must-fix items: Phase B row reframed with per-option L175 cost; aggregate cross-product table; Trim alternatives section expanded with Options 2 and 3; sunk-cost framings on "L175 first foundational" + "Phase A closed-out" softened.

**Iter-117+ (anticipated)**: depending on user response, execute one of Options 1 / 2 / 3 above. If no response by iter-118+, fall back to iter-115 review's recommended Option A — defer all of Phase B by 2+ iters, mid-iter strategy-critic re-dispatch, pull forward L1846 in `BasicOpenCech.lean` as the wedge-task.

**Target net iter-116**: project total 16 → 16 (no prover lanes; blueprint name-slip cleanup + critic absorption only).

### Mid-term — Phase B prover work (paused iter-116 pending user response)

Address `Differentials.lean` non-`h_exact` non-`serre_duality_genus` sorries (L175 unique-gluing helper, L880 forward+converse, L897 corollary). **Iter-116 plan-phase has paused L175 lane via user escalation** (`USER_HINTS.md` written iter-116 requesting decision among Options 1 / 2 / 3 — see Trim alternatives section). The dispatch order is conditional on the user response:

- **Under Option 1 (build the Mathlib bridge)**: dispatch the bridge-build first; Phase B halts on L175 until the bridge lands; then resume L880-forward → L897 → L880-converse.
- **Under Option 2 (refactor to presheaf-only)**: dispatch the refactor first (rewrite `relativeDifferentialsPresheaf` consumers); then L880-forward → L897 → L880-converse.
- **Under Option 3 (declare L175 named gap #8)**: dispatch L880-forward immediately (L175 is stub-and-disclose); then L897 → L880-converse.
- **Default if no user response by iter-118+**: fall back to iter-115 review's recommended Option A — revise STRATEGY.md to defer all of Phase B by 2+ iters, mid-iter strategy-critic re-dispatch to validate, pull forward L1846 in `BasicOpenCech.lean` as the wedge-task (mechanizable from existing Mathlib; not a Mathlib gap).

### Mid-term — Phase C2 verification round (iter-111+)

Read `Picard/Functor.lean` post-C1 + spot-check whether `fiberMap`/`quotMap` content needs re-derivation (per strategy-critic-iter110 ordering ask: this is cheap intel that load-bears the Phase C2 budget). Likely outcome: no further work needed; the iter-109 universe bumps already absorbed the required changes. C2 estimate collapses from ~150 LOC to ~0.

### Phase C3 — DEFERRED via `JacobianWitness` exit policy

See "Phase C3 exit policy" section above.

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

The **post-C1 load-bearing disclosure of `instIsMonoidal_W`** is the same pattern
extended to a different witness: keep the inline sorry at the use site
(`Modules/Monoidal.lean` L173); ship the Pic-and-down arc against the
`MonoidalCategory (X.Modules)` typeclass that transitively depends on it; disclose
the load-bearing transition in the End-state framing.

The **Option (i) budget-deferral on L1846** is a *distinct* category from the named
Mathlib gaps and the `JacobianWitness` exit policy: L1846 is mechanizable from
existing Mathlib (per strategy-critic-iter108 verification); its label
`-- DEFERRED (budget): ...` distinguishes it from a structural Mathlib gap. A
future iter outside the autonomous loop can mechanize it.

```

## What the planner is considering for the replacement

The planner is leaning toward this high-level reshape:

1. **The 9 protected declarations are mathematically correct as
   currently formulated.** None of them are "temporarily wrong"; the
   only sorry on the protected chain is `nonempty_jacobianWitness`,
   whose statement is the true existence of a Jacobian/Albanese variety
   for a smooth proper geometrically irreducible curve.

2. **The 15 orphan project-content sorries split into two groups**:
   - **Closeable with bounded infrastructure** (~1–10 iters each):
     L1846 (`h_loc_exact`, mechanizable from existing Mathlib per the
     iter-108 audit), L82/L96 (`pullback_tensorObj`/`pullback_oneIso`,
     hand-build of the monoidal-functor witness on
     `Scheme.Modules.pullback f`), L931/L947 (`smooth_iff_locally_free_omega`
     forward/converse via `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`
     [verified] + `AlgebraicGeometry.isSmoothOfRelativeDimension_iff`
     [verified]), L737 (`h_exact`, requires building
     `SheafOfModules.exact_iff_stalkwise`, ~2–4 iters), L191
     (`isSheafUniqueGluing_type`, requires either Mathlib-bridge build or
     refactor to presheaf-only framing).

   - **Genuinely massive Mathlib gaps** (multi-thousand-LOC builds, each
     comparable to a Hartshorne chapter):
     - L1091 `serre_duality_genus` — dualizing sheaf, trace morphism for
       proper morphisms, duality pairing.
     - L181 `PicardFunctor.representable` — FGA representability of the
       Picard functor.
     - L173 `instIsMonoidal_W` — `stalk_tensorObj` for varying-ring
       `PresheafOfModules` (Mathlib only has the fixed-ring version).
     - L179 `nonempty_jacobianWitness` — Albanese existence, requires
       Hilbert/Quot schemes + finite-group scheme quotients (or
       alternative routes like the divisor-class-image Pic⁰
       construction).
     - The Phase A residual `BasicOpenCech.lean` sorries (L1120, L1212,
       L1536, L1564, L1754) — load-bearing Čech-cohomology body work
       gated on the L1120 `cechCofaceMap_pi_smul` route which has been
       PAUSED for 4+ iters per progress-critic STUCK verdicts.

3. **User directive "nothing deferred" leaves three honest options for
   the massive gaps**:
   - **(α) Build the prerequisite Mathlib infrastructure** within the
     loop. Plan multi-thousand-LOC sub-projects. Likely 50+ iters and
     out of practical scope for the autonomous loop.
   - **(β) Find alternative routes that bypass the missing
     infrastructure**. For some (e.g. L173 has no obvious bypass since
     it's the actual mathematical content), this option is closed.
     For others (L179 Jacobian-existence has the divisor-class-image
     Pic⁰ alternative; L181 has direct construction routes), this is
     viable but each route also requires real Mathlib gap-fills.
   - **(γ) Remove the corresponding declaration from project scope**.
     Since 15 of 16 sorries are orphan project content, removing them
     does not break the protected chain. The blueprint would need to be
     trimmed accordingly. This is mathematically honest (we ship less,
     but everything we ship is closed).

4. **The planner's current best guess** is a hybrid:
   - Close all closeable sorries (L1846, L82, L96, L931, L947, L737,
     L191 via refactor) — 6 sorries closed across ~10–15 iters.
   - For L1091, L181, L173: pre-commit to one of (α), (β), (γ) per
     gap, name the route, and either schedule iters to fill or remove
     the declaration. The cleanest user-directive-aligned outcome is
     (γ) for all three orphan-massive gaps, with the corresponding
     blueprint sections trimmed.
   - For L179: this is the load-bearing protected-chain sorry. Removing
     it would require deleting the Jacobian definition itself; the
     user's directive is to find a strategy, not to abandon the project
     goal. The cleanest plan is (β) — build the divisor-class-image
     Pic⁰ alternative route, OR honestly disclose that the Jacobian
     construction is the headline open problem.
   - The Phase A residual `BasicOpenCech` sorries are orphan and not
     transitively needed by `Genus.lean`'s definition (which uses the
     project-local `HModule` not Čech machinery). Option (γ) on those
     — strip the Phase A work to only what `MayerVietorisCover.lean`
     genuinely needs (which is 0 sorries; it already compiles).

## What you should produce

A standard strategy-critic report covering:

- **Routes audited** (the three options α/β/γ above as candidate
  responses to the user directive; or new options if you identify
  better ones).
- **Verdicts per option**: PROCEED / CHALLENGE / REJECT with reasons.
- **Sunk-cost / momentum flags** on the current strategy.
- **Recommended replacement-strategy shape** for the planner. Be
  concrete: name which sorries you'd close, which you'd remove (with
  blueprint trimming), and which you'd plan multi-iter for.
- **Mathlib-name spot checks** on any names you recommend (a Mathlib
  name recommended without `lean_leansearch` / `lean_loogle` verification
  this iter is treated as `[expected]`, not `[verified]`).
- **Alternative routes** you'd consider for the orphan-massive sorries.

The planner specifically wants you to challenge: is the directive
"nothing deferred" compatible with shipping a non-trivial fraction of
the original blueprint commitment? If not, which subset is honest to
ship?

The planner's prior STRATEGY.md framed the orphan-massive sorries as
"named Mathlib gaps deferred indefinitely". The user has explicitly
overruled that framing. Help the planner choose between (α), (β), (γ)
on a per-gap basis.

## Constraints on your report

- Do not include rebuttals about the user directive itself — the user
  is the boss. Your job is to help the planner translate the directive
  into a concrete strategy.
- Do not propose adding new axioms.
- All Mathlib names you cite must be tagged `[verified]` / `[expected]`
  / `[gap]` per the planner-side conventions.
- Length: <2000 words. The planner reads this report verbatim.
