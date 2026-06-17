# Strategy Critic Directive

## Slug
iter111

## Project goal

This project formalizes the Jacobian of a smooth proper geometrically
irreducible curve over a field, following Christian Merten's challenge
(`references/challenge.lean`). The deliverables are the 9 protected
declarations in `archon-protected.yaml`:

- `AlgebraicGeometry.genus` (`Genus.lean`)
- `AlgebraicGeometry.Jacobian` + 4 instances
  (`Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`,
   `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible`)
  (`Jacobian.lean`)
- `AlgebraicGeometry.Jacobian.ofCurve`,
  `AlgebraicGeometry.Jacobian.comp_ofCurve`,
  `AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp`
  (`AbelJacobi.lean`)

These are the protected signatures; the project must deliver them with
bodies that compile, modulo the named Mathlib-gap sorries explicitly
disclosed in the end-state framing.

## Strategy under review

[Note: STRATEGY.md is unchanged from iter-110 — this is an iter-111
re-verification per the mandatory-every-iter rule. The strategy was
substantially revised iter-110 in response to your iter-110 4-question
CHALLENGE; all 4 asks were addressed.]

The verbatim STRATEGY.md follows.

---

# Strategy

## How to read this file

Forward-looking only. The mathematician should be able to see, at a glance, **what
remains** between today and the end-state and **in what order** the remaining work
must happen. History lives in `task_done.md`; per-iteration recipes live in
`PROGRESS.md`. This file is the arc.

## Estimations (auto-maintained)

| Phase | Iterations remaining | LOC remaining | Status |
|---|---:|---:|---|
| A — Čech acyclicity (`BasicOpenCech.lean`) | ~2–4 | ~30–80 | **Iter-110 (narrative) / Archon iter-108 plan: Phase A escape-valve fired with Option (i) — defer L1846 `h_loc_exact` with `-- DEFERRED (budget): ...` annotation per strategy-critic-iter108 CHALLENGE.** L1846 is **NOT a Mathlib gap**: Mathlib b80f227 has `IsLocalizedModule.Away`, `IsLocalizedModule.pi`, `IsLocalizedModule.prodMap`, and the algebra adapter `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid` (verified via `lean_leansearch`). The lemma is mechanizable; mechanization deferred at iter-108 due to `letI ... in <goal-type>` propagation friction (per-x algebra threading). The inline iter-108 + iter-109 narrative scaffolding at L1786–L1834 (~50 LOC: `h_V_le_U`, `h_slice_eq`, `h_pi_eq_inf'`, `h_V_affine`, `h_isLoc`) is preserved as inert infrastructure for future re-attempt. **L1120 active-route status: PAUSED** (progress-critic-iter106/107/108 STUCK; 7 consecutive PARTIAL + 2 PAUSED iters). **Phase A residual prover work** (~2–4 iters / ~30–80 LOC, refined iter-110 per strategy-critic-iter110 CHALLENGE on the "tractable-but-blocked" framing): the deferred substep sorries at L1212, L1536, L1564 each have a *named substep dependency* — L1212 awaits the substep (a) augmented-Čech complex; L1536 awaits the `K → K₀` transport; L1564 awaits the substep (a) for `s₀` — these are project-local substep dependencies inside `BasicOpenCech.lean`, NOT named Mathlib-API gaps. The ~30–80 LOC estimate is a per-substep close-out figure once each substep's predecessor lands; it is NOT a global Phase A close-out cost. L1754 `g_R.map_smul'` is gated on L1120 closure, hence indefinitely deferred parallel to L1120. |
| B — Cotangent sheaves (`Differentials.lean`) | ~3–6 | ~150 | 5 sorries. **Iter-110 reclassification (mathlib-analogist-serre-duality)**: L877 `serre_duality_genus` joins the named-deferred gap roster (7th gap; ~3000–8000 LOC closure from first principles is out of scope). L636 `h_exact` continues deferred parallel to `instIsMonoidal_W`. **Phase B autonomous-loop scope is now 3 sorries**: L122 `relativeDifferentialsPresheaf_isSheaf`, L718 `smooth_iff_locally_free_omega`, L735 `cotangent_at_section`. Blueprint detail expanded iter-110 (Mathlib lemma names + Stacks/Hartshorne refs); chapter is Phase-B-prover-ready for iter-111+ dispatch. |
| C0 — Monoidal `X.Modules` | — | 0 | `instIsMonoidal_W` deferred (Mathlib gap `stalk_tensorObj` for varying-ring R₀). **Status update post-mathlib-analogist-c1-route iter-108**: this sorry is currently *dormant* (no active proof DAG consumes it pre-C1) but will become **load-bearing for the entire Pic-and-down arc post-C1 promotion**. The named-gap *count* is unchanged; the *transitive reach* of the sorry expands dramatically. End-state framing must add a load-bearing disclosure paragraph mirroring the `JacobianWitness` honest-accounting. |
| C1 — Refined `LineBundle` | **DONE iter-109** | ~0 | C1 promotion COMPLETE iter-109 via `refactor` subagent + iter-109 prover round. Body `LineBundle X := (Skeleton X.Modules)ˣ` (bare form, no `Shrink` wrapper needed: `X.Modules` lives in `Type (u+1)`); `instCommGroupLineBundle` derives via `BraidedCategory (X.Modules)` chain (transitive on `instIsMonoidal_W`). `Pic.pullback` closed via hand-construction through `(Scheme.Modules.pullback f).mapSkeleton` consuming the iter-109-introduced **named-deferred pair** (`SheafOfModules.pullback_tensorObj` L82 = `μ`-iso; `SheafOfModules.pullback_oneIso` L96 = `ε`-iso). Both collapse together when a future Mathlib refresh lands `(SheafOfModules.pullback _).Monoidal`. Cascading universe bumps on `PicardFunctor` codomain (`Type u` → `Type (u+1)`) and `PicardFunctorAb` codomain (`AddCommGrpCat.{u}` → `AddCommGrpCat.{u+1}`) absorbed cleanly; `etaleSheafified` body simplified by one functor composition (pre-C1 lift now unnecessary). Persistent rationale: `analogies/c1-route.md`. |
| C2 — `PicardFunctor` re-derivation | ~0–4 | ~0–80 | Largely absorbed by iter-109 universe bumps. Existing `fiberMap`/`quotMap`/etale-sheafification compile against the new `LineBundle` with no new sorries beyond the C3-deferred `representable`. **Iter-110+ verification round** required (cheap intel per strategy-critic-iter110 ordering ask): read `Picard/Functor.lean` post-C1 + spot-check whether `fiberMap`/`quotMap` need content re-derivation OR are already correct against the iter-109 LineBundle. Likely outcome: no further work needed (the C2 estimate collapses from 4–6 iters to 0). |
| C3 — Representability / `JacobianWitness` | DEFERRED via JacobianWitness exit policy | — | Strategy-critic-iter105 REJECT on original estimate (10–15 iters / ~1500 LOC wildly under-counted; realistic 50–150 iters / 5,000–15,000 LOC for either FGA-Hilbert or `Sym^g/S_g`). `nonempty_jacobianWitness` sorry at `Jacobian.lean:179` is the single named gap on Hilbert/Quot schemes + finite-group scheme quotients (both confirmed absent from Mathlib b80f227). |
| D, E — `genus`/`Jacobian`/instances + Abel–Jacobi | 0 | 0 | File-level closure (no inline `sorry`); content-level BLOCKED-ON-C3-WITNESS. |

**Aggregate (revised iter-110 with C1 closed + C2 collapsed + L877 reclassified as named gap)**: ~6–12 prover iterations and ~150–300 LOC remain for what the autonomous loop will deliver (Phase A residual + Phase B non-L877 + Phase C2 verification round). Phase C3 deferred. The final project terminates with the following sorry-disclosure structure:

- **7 named Mathlib-gap sorries** in scope (mathlib-analogist-serre-duality-iter110 added L877):
  1. `instIsMonoidal_W` (`Modules/Monoidal.lean` L173) — varying-ring `stalk_tensorObj` gap. **Load-bearing post-C1** for the entire Pic-and-down arc.
  2. `cotangentExactSeq_structure.h_exact` (`Differentials.lean` L636) — sheaf-of-modules exactness criterion (Mathlib gap). Deferred parallel to `instIsMonoidal_W`.
  3. `nonempty_jacobianWitness` (`Jacobian.lean` L179) — Hilbert/Quot schemes + finite-group quotients. Phase C3 exit policy.
  4. `PicardFunctor.representable` (`Picard/Functor.lean` L181) — gated on C3.
  5. `SheafOfModules.pullback_tensorObj` (`Picard/LineBundle.lean` L82) — `(pullback f).obj (M ⊗ N) ≅ (pullback f).obj M ⊗ (pullback f).obj N`. The `μ`-iso of an absent `(SheafOfModules.pullback _).Monoidal` instance.
  6. `SheafOfModules.pullback_oneIso` (`Picard/LineBundle.lean` L96) — `(pullback f).obj (𝟙_ Y.Modules) ≅ 𝟙_ X.Modules`. The `ε`-iso of the same absent monoidal instance; sibling to (5). Both collapse simultaneously when Mathlib lands the monoidal instance.
  7. `serre_duality_genus` (`Differentials.lean` L877) — **NEW iter-110 reclassification** per mathlib-analogist-serre-duality. Closure from first principles would require ~3000–8000 LOC (trace morphism for proper morphisms + dualizing sheaf + duality pairing + perfect-pairing argument — Hartshorne-chapter scope). Mathlib b80f227 has NO Serre duality, NO dualizing sheaf, NO trace morphism for proper morphisms, and NO Zariski coherent cohomology of `O_X`-modules (only ℓ-adic on the pro-étale site). Out of scope for the autonomous loop; named-deferred parallel to (1)–(4). Persistent rationale: `analogies/serre-duality.md`.
- **1 budget-deferred sorry**: `BasicOpenCech.lean` L1846 `h_loc_exact` Step 2 transport — `-- DEFERRED (budget): ...` annotation per Option (i) of the iter-108 escape-valve menu. **NOT a Mathlib gap.** Provable from existing Mathlib (`IsLocalizedModule.{Away,pi,prodMap}` + algebra adapter); mechanization parked behind Phase B priorities.

The named-gap count is **7** (was 5 mid-iter-109; +1 for `pullback_oneIso` sister-gap split; +1 iter-110 for `serre_duality_genus` reclassification). The pair (5, 6) is a single underlying Mathlib gap recorded as two project-side sorries because the surface API needs both iso-witnesses to construct `Pic.pullback` by hand-bundling.

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
- **Option (ii) deferred to iter-109 narrative**: C1 promotion fired iter-109 informed by the analogist.
- **Option (iii) not selected**: mathlib-analogist re-consult on a different L1846 decomposition. Not needed.

## Phase C3 exit policy (adopted iter-107)

The strategy-critic-iter105 audit returned REJECT on Phase C3 with the argument that both proposed routes (FGA-via-Hilbert; `Sym^g C / S_g`) require constructing Mathlib infrastructure (Hilbert scheme; finite-group scheme quotient) that is a Hartshorne-chapter-sized undertaking (~5,000–10,000 LOC each), wildly exceeding the project's stated estimate.

**Adopted exit policy**: defer Phase C3 indefinitely via the `JacobianWitness`-witness pattern. The protected `Jacobian C`, `ofCurve P`, and downstream instances (`GrpObj`, `IsProper`, `GeometricallyIrreducible`, `SmoothOfRelativeDimension`) carry sorry-routed bodies that reduce to `Nonempty (JacobianWitness C)`, where `JacobianWitness C : Type` is a structure with a `sorry`-bodied existence at `Jacobian.lean:179`. This is **mathematically honest**: the project delivers a *framework* for the Jacobian (genus, Picard functor, all instance plumbing) that bottoms out in a single named Mathlib gap.

The strategy-critic's "divisor-class-image Pic⁰" alternative is documented as a future-work option.

## End-state

`Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean` compile with **only the named Mathlib-gap sorries listed above + 1 budget-deferral** and **no new `axiom`**. The nine declarations in `archon-protected.yaml` carry the intended mathematical content **up to the JacobianWitness gap and the post-C1 load-bearing `instIsMonoidal_W` gap**, with all other infrastructure (Čech cohomology, cotangent sheaves, sheafified Picard functor, refined LineBundle) delivered.

**Plain-language disclosure of the End-state for the human reader**:

The protected `Jacobian C`, `ofCurve`, and the four `Jacobian` instances compile against a `Nonempty (JacobianWitness C)` witness whose existence sorry is at `Jacobian.lean:179`. **The project ships a Jacobian *framework*, conditional on the witness — it does NOT autonomously construct the Jacobian.**

**Additional disclosure (post-C1)**: the project also ships a *Picard framework*, conditional on the Mathlib gap `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗ N.stalk x` (varying-ring R₀).

## Honest assessment of Phase A (Archon iter-108 / narrative iter-110 status)

The `cechCofaceMap_pi_smul` lane (L1120) is **PAUSED** per progress-critic-iter106/107/108 STUCK verdicts. The L1846 `h_loc_exact` lane was active iter-108 + iter-109 narrative with two PARTIAL outcomes; iter-108 (Archon canonical) plan-agent fired Option (i). **Phase A is now closed-out for the autonomous loop's scope** modulo the deferred sub-step sorries L1212/L1536/L1564.

## Mathlib gaps in scope

| Gap | Phase | Plan |
|---|---|---|
| Stalkwise criterion for `SheafOfModules` exactness | B | Both routes confirmed Mathlib-gap blocked (iter-086 audit). `h_exact` deferred parallel to `instIsMonoidal_W`. |
| `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗ N.stalk x` (varying-ring `R₀`) | C0 / **load-bearing post-C1** | Defer indefinitely. |
| Sheaf cohomology `Hⁱ(X, F)` for quasi-coherent sheaves | A | Project-local `HModule`/`HModule'` via `Abelian.Ext`. |
| `IsLocalizedModule.Away f.1` on finite products of restricted basic-opens | A — **NO LONGER A GAP** | L1846 mechanizable; reclassified as budget-deferral. |
| `Functor.Monoidal (Scheme.Hom.pullback f)` for `SheafOfModules` | C1 | Default option (c): named-deferral via standalone `SheafOfModules.pullback_tensorObj` sorry + `pullback_oneIso` sibling. |
| Hilbert / Quot schemes | C3-DEFERRED | Phase C3 deferred via JacobianWitness exit policy. |
| Finite-group quotients of schemes | C3-DEFERRED | Same. |
| Riemann–Roch effective theory + scheme-theoretic image | C3-DEFERRED | Documented but not selected. |
| Serre duality / dualizing sheaf / trace morphism / Zariski coherent cohomology | B / iter-110 reclassification | **NEW iter-110**: L877 named-deferred Mathlib gap #7. ~3000–8000 LOC from first principles. |

## Path from today to the end-state

### Archon iter-110 (PRIOR iter — deeper-think iter, no prover lane)

Per the HARD GATE rule + strategy-critic-iter110 + progress-critic-iter110 verdicts, iter-110 dispatched NO prover round. 4 blueprint-writer dispatches + 1 mathlib-analogist consult.

### Archon iter-111 (NEXT iter — anticipated Phase B opening)

With blueprint-writers complete and analogist findings in hand, open Phase B prover lane on **non-L877 Differentials sorries** (L122 likely first per blueprint depth — `relativeDifferentialsPresheaf_isSheaf`). L877 stays gated by the analogist findings.

### Mid-term — Phase B prover work (iter-112+ once L122 closed)

Address `Differentials.lean` non-`h_exact` non-L877 sorries (L718, L735) once L122 is closed.

### Mid-term — Phase C2 verification round (iter-112+)

Read `Picard/Functor.lean` post-C1 + spot-check whether `fiberMap`/`quotMap` content needs re-derivation. Likely outcome: no further work needed.

### Phase C3 — DEFERRED via `JacobianWitness` exit policy

See "Phase C3 exit policy" section above.

## Soundness rule

**No helper lemma with a universally-false signature may be introduced**, even with a `sorry` body. Such a helper is logically an axiom; combined with `exact ... _` applications, it bypasses any subsequent goal.

When the genuine statement is impossible to prove because of a Mathlib gap, the project's choice is between:
(a) Leave the inline `sorry` in place at the use site (preferred — surfaces honest status).
(b) Define an iff-form helper as a `theorem ... : iff_statement := sorry` if the statement is mathematically TRUE.

Never replace an inline `sorry` with a `sorry`-bodied helper that strengthens the claim or with one whose signature is mathematically wrong.

The **Phase C3 exit policy** above is the soundness-rule-compliant treatment of an unbounded Mathlib gap.

The **post-C1 load-bearing disclosure of `instIsMonoidal_W`** is the same pattern extended to a different witness.

The **Option (i) budget-deferral on L1846** is a *distinct* category from the named Mathlib gaps and the `JacobianWitness` exit policy.

---

End of STRATEGY.md verbatim.

## References index

- `references/challenge.lean`: authoritative formal statement of the
  9 protected declarations.
- `analogies/serre-duality.md`: persistent rationale for L877
  reclassification (iter-110 mathlib-analogist).
- `analogies/c1-route.md`: persistent rationale for C1 promotion
  (iter-108 mathlib-analogist).
- `analogies/finite-product-localisation-and-cech-r-linearity.md`:
  persistent rationale for L1120/L1846 routes (Phase A).

## Blueprint summary (chapter titles + one-line topic)

- `Rigidity.tex` — Mumford rigidity criterion for group schemes.
- `Genus.tex` — algebraic genus as `dim_k H¹(C, O_C)`.
- `Cohomology_SheafCompose.tex` — sheafification compatibility.
- `Cohomology_StructureSheafAb.tex` — Ab-valued structure sheaf.
- `Cohomology_StructureSheafModuleK.tex` — k-valued structure sheaf + HModule/HModule' Ext-based cohomology.
- `Cohomology_MayerVietoris.tex` — Mayer–Vietoris LES + Čech acyclicity.
- `Modules_Monoidal.tex` — `(X.Modules).IsMonoidal` (post-C1 load-bearing).
- `Picard_LineBundle.tex` — refined `LineBundle X := (Skeleton X.Modules)ˣ`; `Pic.pullback` via hand-construction.
- `Picard_Functor.tex` — contravariant `PicardFunctor` to `Type (u+1)`.
- `Picard_FunctorAb.tex` — `PicardFunctorAb` lift to `AddCommGrpCat.{u+1}`.
- `Differentials.tex` — relative cotangent sheaf `Ω_{X/S}` + cotangent exact sequence + smoothness iff locally free Ω.
- `Jacobian.tex` — `JacobianWitness`-conditioned protected signatures.
- `AbelJacobi.tex` — `ofCurve`/`comp_ofCurve`/`exists_unique` via `JacobianWitness` projections.

## Re-verification ask

STRATEGY.md is unchanged from your iter-110 verdict (SOUND-with-CHALLENGE,
4 precision asks, all addressed). Please re-verify the strategy from
fresh context this iter: are the 7+1 named-gap roster, the Phase A
substep framing, the Phase B 3-sorry scope (post-L877 reclassification),
and the C3 JacobianWitness exit policy still sound? Anything that's
slipped since iter-110?
