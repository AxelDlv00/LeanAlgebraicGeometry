# Strategy Critic Directive

## Slug
iter114

## Project goal

Formalize the Jacobian of a smooth proper geometrically irreducible curve over a field,
following Christian Merten's challenge file (`references/challenge.lean`). The 9
protected declarations the project must deliver are:

- `AlgebraicGeometry.genus` (`AlgebraicJacobian/Genus.lean`)
- `AlgebraicGeometry.Jacobian` and its four instances (`instGrpObj`,
  `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`)
  in `AlgebraicJacobian/Jacobian.lean`
- `AlgebraicGeometry.Jacobian.ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`
  in `AlgebraicJacobian/AbelJacobi.lean`

Signatures are frozen by the mathematician; only proof bodies may change.

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
| A — Čech acyclicity (`BasicOpenCech.lean`) | **DEFERRED (gated)** | ~30–80 (per-substep, conditional) | Phase A escape-valve fired iter-108 with Option (i): defer L1846 `h_loc_exact` with `-- DEFERRED (budget): ...` annotation. L1846 is **NOT a Mathlib gap**: Mathlib has `IsLocalizedModule.{Away,pi,prodMap}`. L1120 active-route status: PAUSED (7 consecutive PARTIAL + 2 PAUSED iters). Phase A residual prover work (~2–4 iters / ~30–80 LOC per substep, conditional on predecessors): L1212, L1536, L1564 each await named substep dependency inside `BasicOpenCech.lean`. L1754 gated on L1120, indefinitely deferred. |
| B — Cotangent sheaves (`Differentials.lean`) | ~4–8 | ~200 | 5 sorries. L1039 `serre_duality_genus` is named-deferred (7th gap; ~3000–8000 LOC closure from first principles is out of scope). L798 `h_exact` continues deferred parallel to `instIsMonoidal_W`. Phase B autonomous-loop scope is **3 sorries**: (i) **L175 `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`** (iter-113 NEW unique-gluing sub-helper — the residual mathematical content of helper #1 after the iter-113 reformulation; close via universal property of `KaehlerDifferential` + structure-sheaf gluing + `span_range_derivation` uniqueness, ~80–120 LOC); (ii) L897 `cotangent_at_section` — moderate (~1–2 iters, corollary of L880 via pullback preservation of locally-free); (iii) **L880 `smooth_iff_locally_free_omega`** — heaviest of the three (~2–4 iters; Hartshorne II Theorem 8.15 forward + converse + local-to-global glue + Nakayama). Recommended dispatch order: close L175 first (load-bearing for the sheaf condition of Ω_{X/S}), then L897 if it lands quickly, finally L880 as the heaviest. |
| C0 — Monoidal `X.Modules` | — | 0 | `instIsMonoidal_W` deferred (Mathlib gap `stalk_tensorObj` for varying-ring R₀). Status: this sorry is currently *dormant* (no active proof DAG consumes it pre-C1) but **load-bearing for the entire Pic-and-down arc post-C1 promotion**. End-state framing carries a load-bearing disclosure paragraph mirroring the `JacobianWitness` honest-accounting. |
| C1 — Refined `LineBundle` | **DONE iter-109** | ~0 | C1 promotion COMPLETE via `refactor` subagent + iter-109 prover round. Body `LineBundle X := (Skeleton X.Modules)ˣ`; `instCommGroupLineBundle` derives via `BraidedCategory (X.Modules)` chain (transitive on `instIsMonoidal_W`). `Pic.pullback` closed via hand-construction through `(Scheme.Modules.pullback f).mapSkeleton` consuming the iter-109-introduced **named-deferred pair** (`SheafOfModules.pullback_tensorObj` L82 = `μ`-iso; `SheafOfModules.pullback_oneIso` L96 = `ε`-iso). Persistent rationale: `analogies/c1-route.md`. |
| C2 — `PicardFunctor` re-derivation | ~0–4 | ~0–80 | Largely absorbed by iter-109 universe bumps. Existing `fiberMap`/`quotMap`/etale-sheafification compile against the new `LineBundle` with no new sorries beyond the C3-deferred `representable`. Iter-110+ verification round required (cheap intel): read `Picard/Functor.lean` post-C1 + spot-check whether `fiberMap`/`quotMap` need content re-derivation. Likely outcome: no further work needed. |
| C3 — Representability / `JacobianWitness` | DEFERRED via JacobianWitness exit policy | — | Original strategy-critic-iter105 REJECT on 10–15 iters / ~1500 LOC estimate (realistic 50–150 iters / 5,000–15,000 LOC for either FGA-Hilbert or `Sym^g/S_g`). `nonempty_jacobianWitness` sorry at `Jacobian.lean:179` is the single named gap on Hilbert/Quot schemes + finite-group quotients (both absent from Mathlib b80f227). |
| D, E — `genus`/`Jacobian`/instances + Abel–Jacobi | 0 | 0 | File-level closure (no inline `sorry`); content-level BLOCKED-ON-C3-WITNESS. |

**Aggregate**: ~6–12 prover iterations and ~150–300 LOC remain for what the autonomous loop will deliver (Phase A residual + Phase B non-L1039 + Phase C2 verification round). Phase C3 deferred.

**Scope rationale (added iter-112 per strategy-critic-iter112 CHALLENGE)**. After the iter-107 Phase C3 exit policy decoupled the protected `Jacobian` from any Picard / Differentials chain dependency, the remaining autonomous-loop scope (Phase B non-`h_exact` non-`serre_duality_genus` sorries; Phase C2 verification; post-C1 disclosure tracking) is **not load-bearing for the 9 protected declarations** — only `nonempty_jacobianWitness` is. The remaining work is *blueprint-completeness commitment*: the project's blueprint chapters describe a sheaf-theoretic Jacobian-and-Picard framework whose Lean targets we ship even though the protected-declaration chain currently bottoms out at the JacobianWitness gap. The alternative — trim project scope to the protected-only chain — was considered iter-112 and rejected: doing so would (i) invalidate the blueprint chapters as committed-but-unformalized, (ii) erase the post-C1 monoidal-`X.Modules` work that establishes the *correct* sheaf-theoretic `LineBundle` as the iter-109 promotion delivered, and (iii) make the project a less-useful artifact for whoever picks it up once Mathlib's algebraic-geometry foundations are deeper.

- **7 named Mathlib-gap sorries**:
  1. `instIsMonoidal_W` (`Modules/Monoidal.lean` L173) — varying-ring `stalk_tensorObj` gap. **Load-bearing post-C1** for the entire Pic-and-down arc.
  2. `cotangentExactSeq_structure.h_exact` (`Differentials.lean` L798) — sheaf-of-modules exactness criterion (Mathlib gap). Deferred parallel to `instIsMonoidal_W`.
  3. `nonempty_jacobianWitness` (`Jacobian.lean` L179) — Hilbert/Quot schemes + finite-group quotients. Phase C3 exit policy.
  4. `PicardFunctor.representable` (`Picard/Functor.lean` L181) — gated on C3.
  5. `SheafOfModules.pullback_tensorObj` (`Picard/LineBundle.lean` L82) — `(pullback f).obj (M ⊗ N) ≅ (pullback f).obj M ⊗ (pullback f).obj N`. The `μ`-iso of an absent `(SheafOfModules.pullback _).Monoidal` instance.
  6. `SheafOfModules.pullback_oneIso` (`Picard/LineBundle.lean` L96) — `(pullback f).obj (𝟙_ Y.Modules) ≅ 𝟙_ X.Modules`. The `ε`-iso of the same absent monoidal instance.
  7. `serre_duality_genus` (`Differentials.lean` L1039) — closure from first principles would require ~3000–8000 LOC. Mathlib b80f227 has NO Serre duality, NO dualizing sheaf, NO trace morphism for proper morphisms, and NO Zariski coherent cohomology of `O_X`-modules. Out of scope for the autonomous loop; named-deferred parallel to (1)–(4). Persistent rationale: `analogies/serre-duality.md`.

- **1 budget-deferred sorry**: `BasicOpenCech.lean` L1846 `h_loc_exact` Step 2 transport — `-- DEFERRED (budget): ...` annotation per Option (i) of the iter-108 escape-valve menu. **NOT a Mathlib gap.** Mechanizable from existing Mathlib (`IsLocalizedModule.{Away,pi,prodMap}` + algebra adapter); parked behind Phase B priorities.

**Load-bearing-vs-orphan split** of the 7 named gaps: exactly **one is load-bearing on the 9 protected declarations**: `nonempty_jacobianWitness` (gap #3). The other 6 are *orphan disclosures* — honest project-content sorries that no protected-chain `lean_verify` will surface but that the blueprint commits to.

## What's unconditional vs framework-conditional (explicit enumeration)

For a fresh reader of the end-state, the named-gap surface splits the project's deliverables into three layers:

- **Unconditional core (compiles end-to-end with no `sorryAx` in the axiom chain)**:
  - `Rigidity.lean` (Mumford rigidity).
  - `Genus.lean`'s definition `AlgebraicGeometry.genus` (= `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`).
  - The Čech-cohomology infrastructure under `Cohomology/*.lean` (modulo the 6 budget/Mathlib-infra-blocked transient sorries in `BasicOpenCech.lean`).
  - `Differentials.lean`'s cotangent API (modulo `h_exact` and the 4 non-`h_exact` Phase B sorries which are *not yet* in the chain).
  - `Picard/FunctorAb.lean`'s additive-group wrapping.
- **Framework-conditional on `nonempty_jacobianWitness`**: `Jacobian.lean`'s protected signatures + `AbelJacobi.lean`'s `ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`.
- **Framework-conditional on `instIsMonoidal_W` + the iter-109 sister pair**: `Picard/LineBundle.lean`'s `Pic`, `instCommGroupLineBundle`, `Pic.pullback{,_id,_comp}`; `Picard/Functor.lean`'s `PicardFunctor`, `fiberMap`, `quotMap`; `Picard/FunctorAb.lean`'s `etaleSheafified`-derived terms.
- **Framework-conditional on `serre_duality_genus`**: any future downstream consumer that bridges `genus` to `dim_k H⁰(C, Ω_{C/k})`. None of the current protected signatures consume this.
- **Multi-gap-conditional**: `Picard/Functor.lean`'s `representable` (gated on C3 + the iter-109 pair).

## Phase C3 exit policy

Defer Phase C3 indefinitely via the `JacobianWitness`-witness pattern. The protected `Jacobian C`, `ofCurve P`, and downstream instances carry sorry-routed bodies that reduce to `Nonempty (JacobianWitness C)`, where `JacobianWitness C : Type` is a structure with a `sorry`-bodied existence at `Jacobian.lean:179`. **Mathematically honest**: the project delivers a *framework* for the Jacobian that bottoms out in a single named Mathlib gap.

The strategy-critic's "divisor-class-image Pic⁰" alternative is documented as future-work, NOT selected as within-scope.

## End-state

`Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean` compile with **only the named Mathlib-gap sorries listed above + 1 budget-deferral** and **no new `axiom`**. The nine declarations in `archon-protected.yaml` carry the intended mathematical content **up to the JacobianWitness gap and the post-C1 load-bearing `instIsMonoidal_W` gap**.

**Plain-language disclosure**: the project ships a Jacobian *framework*, conditional on the witness. A fresh reader of the final project state should understand: "did you build the Jacobian of a smooth proper curve?" answers as "no, we built every Jacobian-derived instance + AbelJacobi morphism + downstream consequences AGAINST the named existence hypothesis `nonempty_jacobianWitness`, which itself rests on Mathlib gaps (Hilbert / Quot schemes; finite-group scheme quotients)".

**Additional disclosure (post-C1)**: the project also ships a *Picard framework*, conditional on the Mathlib gap `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗ N.stalk x` (varying-ring R₀).

## Soundness rule

**No helper lemma with a universally-false signature may be introduced**, even with a `sorry` body. Such a helper is logically an axiom; combined with `exact ... _` applications, it bypasses any subsequent goal.

When the genuine statement is impossible to prove because of a Mathlib gap, the project's choice is between:
(a) Leave the inline `sorry` in place at the use site (preferred — surfaces honest status).
(b) Define an iff-form helper as a `theorem ... : iff_statement := sorry` if the statement is mathematically TRUE; the application then exposes the unprovable side as a fresh, named goal rather than displacing it silently. Only do this when downstream consumers can usefully assume the iff in `simp`/`rw`/`exact` chains.

Never replace an inline `sorry` with a `sorry`-bodied helper that strengthens the claim or with one whose signature is mathematically wrong.

The **Phase C3 exit policy** is the soundness-rule-compliant treatment of an unbounded Mathlib gap.

The **post-C1 load-bearing disclosure of `instIsMonoidal_W`** is the same pattern extended to a different witness.

The **Option (i) budget-deferral on L1846** is a *distinct* category from named Mathlib gaps and the `JacobianWitness` exit policy: L1846 is mechanizable from existing Mathlib; its label `-- DEFERRED (budget): ...` distinguishes it from a structural Mathlib gap.
```

## References index

```markdown
# References

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

## Blueprint summary

- `AbelJacobi.tex` — Albanese / Abel–Jacobi morphism `ofCurve P : C → Jac(C)`, universal up to translation; foundation for the protected `comp_ofCurve` and `exists_unique_ofCurve_comp`.
- `Cohomology_MayerVietoris.tex` — Mayer–Vietoris LES + AffineCoverMVSquare carrier + the BasicOpenCech sub-step infrastructure (~6 budget/Mathlib-infra-blocked transient sorries) for Čech acyclicity on basic-open covers.
- `Cohomology_SheafCompose.tex` — `HasSheafCompose` for `forget CommRing → AddCommGrp`.
- `Cohomology_StructureSheafAb.tex` — `HasSheafify` + `HasExt` instances for `Sheaf (Opens X) AddCommGrp`; gives `toAbSheaf`.
- `Cohomology_StructureSheafModuleK.tex` — Project-local `HModule` / `HModule'` via `Abelian.Ext`; structure-sheaf as `ModuleCat k`-presheaf; Stein-finiteness chain to `module_finite_HModule_of_HModule'_X₄`.
- `Differentials.tex` — Relative cotangent sheaf `Ω_{X/S}`; cotangent exact sequence (α/β); smooth-iff-Ω-locally-free and the cotangent-at-section corollary; Serre-duality genus equality (the named-deferred 7th gap).
- `Genus.tex` — `genus C := Module.finrank k (HModule k (toModuleKSheaf C) 1)`.
- `Jacobian.tex` — Protected `Jacobian C`, `ofCurve P`, four instances (`grpObj`, `smoothOfRelativeDimension_genus`, `isProper`, `geomIrred`), routed through `Nonempty (JacobianWitness C)`. JacobianWitness exit policy.
- `Modules_Monoidal.tex` — `(W X).IsMonoidal` on the localised category `X.Modules`; depends on the absent `stalk_tensorObj` Mathlib lemma for varying-ring R₀.
- `Picard_Functor.tex` — `PicardFunctor C` contravariant functor; `fiberMap`/`quotMap` quotient descent; `representable` (FGA-deferred sorry).
- `Picard_FunctorAb.tex` — Additive wrapper `PicardFunctorAb`; etale sheafification.
- `Picard_LineBundle.tex` — Post-C1 refined `LineBundle X := (Skeleton X.Modules)ˣ`; `Pic.pullback` hand-built through `mapSkeleton` consuming the iter-109 named-deferred pair `pullback_tensorObj` + `pullback_oneIso`.
- `Rigidity.tex` — Mumford rigidity (`GrpObj.eq_of_eqOnOpen`); foundation for uniqueness of `ofCurve`.

## Prior critique status

Strategy-critic-iter113-retry CHALLENGE on Phase B orphan-signature defects (free `n : ℕ` on `Smooth f`-iffs; `H^0 = H^0` for Serre duality) was **addressed iter-113 via a refactor lane**: `smooth_iff_locally_free_omega` (L880) and `cotangent_at_section` (L897) now correctly thread `n` through `IsSmoothOfRelativeDimension n f`; `serre_duality_genus` (L1039) now reads `H^0(Ω) = H^1(O_C)`. The Soundness rule violation the critic flagged is removed.

One residual challenge from iter-113's lean-vs-blueprint-checker (not strategy-critic): the iter-113 Lean for `serre_duality_genus` still has `IsIntegral C.left` instead of "geometrically irreducible" + `Smooth C.hom` instead of `IsSmoothOfRelativeDimension 1 C.hom`. The current strategy notes this as named-deferred (Mathlib gap #7); the iter-114 blueprint-writer dispatch will reconcile by relaxing the chapter prose to match the Lean signatures (rather than tightening the Lean — `IsGeometricallyIntegral` for schemes is `[gap]` in Mathlib b80f227 per iter-113 verification).

Strategy is otherwise unchanged from iter-113. Asking for re-verification given the iter-113 refactor landed and now-trimmed-to-3-sorry Phase B scope.
