# Strategy Critic Directive

## Slug

iter115

## Project goal

The project formalizes the construction of the **Jacobian of a smooth proper geometrically irreducible curve over a field**, following Christian Merten's algebraic-Jacobian-challenge specification at `references/challenge.lean`. The nine declarations in `archon-protected.yaml` (frozen signatures) are the deliverables:

- `AlgebraicGeometry.genus`
- `AlgebraicGeometry.Jacobian` + four instances (`instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`)
- `AlgebraicGeometry.Jacobian.ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`

The project ships a Jacobian framework conditional on a small set of named Mathlib gaps (Hilbert/Quot schemes; finite-group scheme quotients; varying-ring stalk-of-presheaf-tensor; Serre duality), with the protected chain bottoming out at a single `Nonempty (JacobianWitness C)` existence sorry per the "JacobianWitness exit policy."

## Strategy under review

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
| B — Cotangent sheaves (`Differentials.lean`) | ~5–12 (revised iter-114 per strategy-critic) | ~250–400 | 5 sorries. **Iter-110 reclassification**: L1039 `serre_duality_genus` named-deferred (7th gap; ~3000–8000 LOC from first principles is out of scope). L798 `h_exact` continues deferred parallel to `instIsMonoidal_W`. **Phase B autonomous-loop scope is now 3 sorries**, with **non-uniform expected cost per strategy-critic-iter114 effort decomposition**: (i) **L175 `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`** (iter-113 NEW sub-helper, replacing the prior L122 sorry after the iter-113 unique-gluing reformulation) — estimated ~2–3 iters / ~100–200 LOC; close via universal property of `KaehlerDifferential` + structure-sheaf gluing + `KaehlerDifferential.span_range_derivation` uniqueness; (ii) **L897 `cotangent_at_section`** — moderate (~1–2 iters, corollary of L880-forward via pullback preservation of locally-free); (iii) **L880 `smooth_iff_locally_free_omega`** — **decomposed iter-114 into forward + converse** per strategy-critic-iter114 CHALLENGE on the original under-counted ~2–4 iter / ~200 LOC estimate. **Forward direction `smooth_imp_locally_free_omega`** (~2–3 iters / ~100–200 LOC): direct from `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` [verified] + `Algebra.IsStandardSmooth.free_kaehlerDifferential` [verified] on affine charts. **Converse direction `locally_free_omega_imp_smooth`** (~3–6 iters / ~200–500 LOC): Hartshorne II.8.15 converse; requires either deformation-theoretic lifting or rebuilding a standard-smooth chart from a Ω-trivializing chart + flatness + `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth` [verified]. The biconditional `smooth_iff_locally_free_omega` reassembles forward + converse trivially. **Recommended dispatch order**: L175 first (foundational; the iter-113 unique-gluing pivot is the load-bearing residual; iter-114 plan-phase deferred this lane pending the mathlib-analogist-iter114 audit of the `Scheme.PresheafOfModules`-from-affine-basis predicate per progress-critic-iter114 STUCK), then L880-forward, then L897 (gated on L880-forward landing), then L880-converse as the heaviest. Blueprint-writer-differentials-iter114 will land the iter-113 unique-gluing prose + remove stale `% NOTE` blocks + relax Serre prose to match Lean. |
| C0 — Monoidal `X.Modules` | — | 0 | `instIsMonoidal_W` deferred (Mathlib gap `stalk_tensorObj` for varying-ring R₀). **Status update post-mathlib-analogist-c1-route iter-108**: this sorry is currently *dormant* (no active proof DAG consumes it pre-C1) but will become **load-bearing for the entire Pic-and-down arc post-C1 promotion**. The named-gap *count* is unchanged; the *transitive reach* of the sorry expands dramatically. End-state framing must add a load-bearing disclosure paragraph mirroring the `JacobianWitness` honest-accounting. |
| C1 — Refined `LineBundle` | **DONE iter-109** | ~0 | C1 promotion COMPLETE iter-109 via `refactor` subagent + iter-109 prover round. Body `LineBundle X := (Skeleton X.Modules)ˣ` (bare form, no `Shrink` wrapper needed: `X.Modules` lives in `Type (u+1)`); `instCommGroupLineBundle` derives via `BraidedCategory (X.Modules)` chain (transitive on `instIsMonoidal_W`). `Pic.pullback` closed via hand-construction through `(Scheme.Modules.pullback f).mapSkeleton` consuming the iter-109-introduced **named-deferred pair** (`SheafOfModules.pullback_tensorObj` L82 = `μ`-iso; `SheafOfModules.pullback_oneIso` L96 = `ε`-iso). Both collapse together when a future Mathlib refresh lands `(SheafOfModules.pullback _).Monoidal`. Cascading universe bumps on `PicardFunctor` codomain (`Type u` → `Type (u+1)`) and `PicardFunctorAb` codomain (`AddCommGrpCat.{u}` → `AddCommGrpCat.{u+1}`) absorbed cleanly; `etaleSheafified` body simplified by one functor composition (pre-C1 lift now unnecessary). Persistent rationale: `analogies/c1-route.md`. |
| C2 — `PicardFunctor` re-derivation | ~0–4 | ~0–80 | Largely absorbed by iter-109 universe bumps. Existing `fiberMap`/`quotMap`/etale-sheafification compile against the new `LineBundle` with no new sorries beyond the C3-deferred `representable`. **Iter-110+ verification round** required (cheap intel per strategy-critic-iter110 ordering ask): read `Picard/Functor.lean` post-C1 + spot-check whether `fiberMap`/`quotMap` need content re-derivation OR are already correct against the iter-109 LineBundle. Likely outcome: no further work needed (the C2 estimate collapses from 4–6 iters to 0). |
| C3 — Representability / `JacobianWitness` | DEFERRED via JacobianWitness exit policy | — | Strategy-critic-iter105 REJECT on original estimate (10–15 iters / ~1500 LOC wildly under-counted; realistic 50–150 iters / 5,000–15,000 LOC for either FGA-Hilbert or `Sym^g/S_g`). `nonempty_jacobianWitness` sorry at `Jacobian.lean:179` is the single named gap on Hilbert/Quot schemes + finite-group quotients (both confirmed absent from Mathlib b80f227). |
| D, E — `genus`/`Jacobian`/instances + Abel–Jacobi | 0 | 0 | File-level closure (no inline `sorry`); content-level BLOCKED-ON-C3-WITNESS. |

**Aggregate (revised iter-110 with C1 closed + C2 collapsed + L877 reclassified as named gap)**: ~6–12 prover iterations and ~150–300 LOC remain for what the autonomous loop will deliver (Phase A residual + Phase B non-L877 + Phase C2 verification round). Phase C3 deferred. The final project terminates with the following sorry-disclosure structure:

**Scope rationale (added iter-112 per strategy-critic-iter112 CHALLENGE; reframed iter-114 per strategy-critic-iter114 sunk-cost reframe)**. After the iter-107 Phase C3 exit policy decoupled the protected `Jacobian` from any Picard / Differentials chain dependency, the remaining autonomous-loop scope (Phase B non-`h_exact` non-`serre_duality_genus` sorries; Phase C2 verification; post-C1 disclosure tracking) is **not load-bearing for the 9 protected declarations** — only `nonempty_jacobianWitness` is. The remaining work is *blueprint-completeness commitment*: the project's blueprint chapters (`Differentials.tex`, `Picard_*.tex`, `Modules_Monoidal.tex`) describe a sheaf-theoretic Jacobian-and-Picard framework whose Lean targets we ship even though the protected-declaration chain currently bottoms out at the JacobianWitness gap.

**Trim alternatives considered**. Two distinct trim options have been considered and rejected:

- *Aggressive trim* — drop all Phase B and Phase C work, ship only the protected-chain. Rejected because doing so would (i) invalidate the blueprint chapters as committed-but-unformalized; (ii) leave the post-C1 monoidal-`X.Modules` `LineBundle X := (Skeleton X.Modules)ˣ` orphaned, whereas it is *the* correct sheaf-theoretic definition (the merit-frame here is current mathematical correctness of the definition — independent of the path the project took to land it); (iii) make the project a less-useful artifact for whoever picks it up once Mathlib's algebraic-geometry foundations are deeper.

- *Narrower L880+L897-only trim* (strategy-critic-iter114 alternative) — keep L175 in scope (the load-bearing residual of the iter-113 unique-gluing pivot, which is the only Phase B sorry whose closure visibly drives the blueprint's `Differentials.tex` proof of `thm:relative_kaehler_isSheaf`), and defer L880 + L897 as **named gaps #8 / #9** parallel to the existing 7. Documented but **not selected** because: (a) L880-forward + L897 are tractable (~3–5 iters combined) and produce concrete project content (the smoothness ↔ Ω-locally-free criterion is *the* characterisation cited by both Hartshorne and Stacks); (b) only L880-converse is genuinely heavy; (c) the project's converse-direction obligation is mathematically standard (Nakayama + standard-smooth-chart reconstruction) and not phantom Mathlib infrastructure. The decomposed `smooth_imp_locally_free_omega` / `locally_free_omega_imp_smooth` pair (iter-114 effort decomposition) lets the planner stage the dispatch so that an iter-115+ "converse is genuinely stalled" signal triggers a *partial* trim (defer just L880-converse as named gap #8) without writing off the forward direction. **Open option**: if iter-115+ progress-critic reports CHURNING on L880-converse for 2+ iters, the narrower trim fires: declare `locally_free_omega_imp_smooth` as named gap #8 (Mathlib-gap: no `Algebra.IsStandardSmoothOfRelativeDimension.of_free_kaehlerDifferential` reverse direction in Mathlib b80f227), keep the iff-form helper sorry-stubbed in the soundness-rule-compliant way (combined with explicit forward-direction theorem so the iff is the witness for the missing direction), and ship the disclosure paragraph.

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

The L1846 `h_loc_exact` lane was **active iter-108 + iter-109 narrative under the analogist Q1 ALIGN_WITH_MATHLIB recipe**, with both iters delivering PARTIAL outcomes (Steps 1a + 1b iter-108; Step 1c iter-109; ~50 LOC inline scaffolding accreted across the two iters). The iter-107 strategy-critic exit criterion fired iter-108 (Archon canonical), and the **escape-valve menu Option (i) executed THIS iter**: trailing sorry at L1846 annotated as `-- DEFERRED (budget): ...` per strategy-critic-iter108 CHALLENGE. The inline scaffolding stays as inert infrastructure for a future re-attempt (parked behind C1 + Phase B priorities). **Phase A is now closed-out for the autonomous loop's scope** modulo the deferred sub-step sorries L1212/L1536/L1564 (tractable Mathlib-infrastructure work scheduled for future iters).

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

### Archon iter-110 (THIS iter — deeper-think iter, no prover lane)

Per the HARD GATE rule + strategy-critic-iter110 + progress-critic-iter110 verdicts, iter-110 dispatches NO prover round. Instead:

- **4 blueprint-writer dispatches** (per blueprint-reviewer-iter110 must-fix): `Picard_Functor.tex` (stale post-C1 sorry prose at L84, missing `pullback_oneIso` in inherited-gap bullet L74), `Picard_FunctorAb.tex` (universe-lift contradiction at L66/L73 vs. iter-109 Lean state), `Differentials.tex` (insufficient proof detail on L122, L718, L735 — required before opening Phase B prover lane), `Cohomology_MayerVietoris.tex` (stale 3-tuple gap-list at L1198, substep numbering inconsistency L1196 vs L1167–1176).
- **1 mathlib-analogist dispatch** on Serre-duality coverage for smooth proper curves (variance flag carried iter-107/108/109; clearance for L877 specifically per Phase B variance-flag-scope clarification above).
- **Picard_LineBundle.tex updates** already applied this plan-phase by the plan agent (added `pullback_oneIso` block, refreshed stale prose, updated proof block to reflect hand-construction route).

**Iter-111 (anticipated)**: with blueprint-writers complete and analogist findings in hand, open Phase B prover lane on **non-L877 Differentials sorries** (L122 likely first per blueprint depth — `relativeDifferentialsPresheaf_isSheaf`). L877 stays gated by the analogist findings.

**Target net iter-110**: project total 16 → 16 (no prover lanes; blueprint + analogist alignment only).

### Mid-term — Phase B prover work (iter-115+ once blueprint complete + mathlib-analogist verdict in)

Address `Differentials.lean` non-`h_exact` non-`serre_duality_genus` sorries (L175 unique-gluing helper, L880 forward+converse, L897 corollary) per the dispatch order recorded in the Phase B row above. **Iter-114 plan-phase ratifies a DEFERRAL of the L175 prover lane** pending: (a) the blueprint-writer-differentials-iter114 dispatch landing the unique-gluing prose (replaces the stale Route (a) prose in `Differentials.tex` proof of `\thm:relative_kaehler_isSheaf`); (b) the mathlib-analogist-iter114 dispatch on the `Scheme.PresheafOfModules`-from-affine-basis predicate (per progress-critic-iter114 STUCK verdict) to confirm whether the recurring "no off-the-shelf basis-to-Scheme sheaf bridge" blocker has a workaround in Mathlib b80f227 or whether the project must build the bridge as an explicit sub-lemma route. The L175 prover lane re-opens iter-115 once both inputs are in hand.

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

## References index

```markdown
# References

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

## Blueprint summary

- `AbelJacobi.tex` — Abel–Jacobi morphism `C → Jac(C)` (via JacobianWitness exit policy), uniqueness, factorisation through Albanese.
- `Cohomology_MayerVietoris.tex` — Mayer–Vietoris LES + affine-cover acyclicity + Čech-to-derived-functor comparison; basicOpenCover construction.
- `Cohomology_SheafCompose.tex` — Sheaf composition via universe pinning (`forget CommRing → AddCommGrp`).
- `Cohomology_StructureSheafAb.tex` — `O_X`-as-Ab-sheaf instance plumbing + `HasExt` + `HasSheafify`.
- `Cohomology_StructureSheafModuleK.tex` — `k`-module structure on global sections + `HModule k F i`; presheaf form + sheafification + finiteness.
- `Differentials.tex` — Relative cotangent sheaf `Ω_{X/S}` (presheaf + sheaf-condition via unique-gluing); universal derivation; cotangent exact sequence (α/β); smooth ↔ Ω-locally-free criterion; Serre-duality reformulation of genus.
- `Genus.tex` — `genus C := Module.finrank k (HModule k (toModuleKSheaf C) 1)`.
- `Jacobian.tex` — Protected `Jacobian C` + instances; `JacobianWitness` structure + `nonempty_jacobianWitness` exit-policy sorry.
- `Modules_Monoidal.tex` — Monoidal structure on `X.Modules` via `LocalizedMonoidal`; `instIsMonoidal_W` Mathlib gap (varying-ring `stalk_tensorObj`).
- `Picard_Functor.tex` — Contravariant `PicardFunctor`; `fiberMap`/`quotMap`; etale-sheafification; representability gap.
- `Picard_FunctorAb.tex` — `Additive`-wrapped `PicardFunctorAb` + `etaleSheafified` derived functor.
- `Picard_LineBundle.tex` — `LineBundle X := (Skeleton X.Modules)ˣ` (post-C1 form); `Pic.pullback` via `(Scheme.Modules.pullback f).mapSkeleton`; `pullback_tensorObj`/`pullback_oneIso` sister-pair Mathlib gap.
- `Rigidity.tex` — Mumford rigidity / open-cover equality.

## Prior critique status

You audited iter-114. The result was 0 REJECT, 2 CHALLENGE, 1 sunk-cost reframe. Three STRATEGY.md edits landed this iter (iter-114): (a) Phase B L880 effort decomposed into forward + converse with separate budgets; (b) explicit narrower-L880+L897-only trim alternative added to scope-rationale (open option, not selected); (c) reframed reason (ii) on current-correctness merits of `LineBundle X := (Skeleton X.Modules)ˣ` (was sunk-cost-framed on iter-109 effort).

Re-verify whether these edits adequately addressed your iter-114 challenges, and audit the strategy as a whole for any NEW issues a fresh reader would raise. Specifically check:

- Phase B's revised aggregate estimate (~5–12 iters / ~250–400 LOC) for honesty against the new decomposition.
- Whether the narrower-trim alternative's "open option" trigger (iter-115+ CHURNING on L880-converse for 2+ iters) is the right escalation criterion.
- Whether the current-correctness framing of reason (ii) is genuinely merit-based rather than re-clothed sunk cost.

This iter (iter-115) plans to open the L175 prover lane on `Differentials.lean` with the analogist-verified corrected recipe (affine-basis identification via `KaehlerDifferential.isLocalizedModule_map` + `AlgebraicGeometry.Modules.tilde`; hand-rolled cofinality descent against `isSheaf_iff_isSheafOpensLeCover`; uniqueness via `eq_of_locally_eq` + `span_range_derivation`). No strategic route is being opened or closed; this is execution of the Phase B mid-term plan.
