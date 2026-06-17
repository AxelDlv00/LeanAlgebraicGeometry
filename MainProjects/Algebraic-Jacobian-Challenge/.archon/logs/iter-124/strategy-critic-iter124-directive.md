# Strategy Critic Directive

## Slug
iter124

## Project goal

Formalize the nine protected declarations of Christian Merten's
Jacobian challenge (`references/challenge.lean`):

- `Genus.lean`: `AlgebraicGeometry.genus`.
- `Jacobian.lean`: `AlgebraicGeometry.Jacobian`,
  `Jacobian.instGrpObj`,
  `Jacobian.smoothOfRelativeDimension_genus`,
  `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible`
  (with chain-rooted at `nonempty_jacobianWitness`, the only
  inhabited mathematical sorry in the project alongside the M1.b
  bridge sorry).
- `AbelJacobi.lean`: `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`,
  `Jacobian.exists_unique_ofCurve_comp`.

All nine signatures are frozen by the mathematician; agents are
read-only on them.  `nonempty_jacobianWitness` quantifies over
arbitrary curves `C : Over (Spec (.of k))` with
`[SmoothOfRelativeDimension 1 C.hom]` — no genus parameter, no
`k`-rational-point hypothesis.

## Strategy under review

STRATEGY.md is appended verbatim at the bottom of this
directive (look for the `## STRATEGY.md (verbatim)` header).
It is also readable at `.archon/STRATEGY.md`.

## References index

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |

## Blueprint summary

| File | Topic |
| ---- | ----- |
| `AbelJacobi.tex` | The Abel–Jacobi map. |
| `Cohomology_MayerVietoris.tex` | Mayer–Vietoris long exact sequence for sheaf cohomology with $k$-module coefficients. |
| `Cohomology_SheafCompose.tex` | Sheaf condition along the structure-sheaf forget composite. |
| `Cohomology_StructureSheafAb.tex` | Structure sheaf as a sheaf of abelian groups, sheafification and Ext. |
| `Cohomology_StructureSheafModuleK.tex` | Sheaves of $k$-modules: sheafification, Ext, and the structure sheaf as a sheaf of $k$-modules. |
| `Differentials.tex` | The relative cotangent presheaf, including the M1 bridge between presheaf and algebra-Kähler forms. |
| `Genus.tex` | Genus of a smooth proper curve via `H¹(C, O_C)` $k$-rank. |
| `Jacobian.tex` | The Jacobian as an abelian variety + the genus-0 witness (M2) + positive-genus witness (M3) decomposition. |
| `Modules_Monoidal.tex` | The symmetric monoidal category of $\mathcal O_X$-modules. |
| `Picard_Functor.tex` | The relative Picard functor (Route A scaffolding). |
| `Picard_FunctorAb.tex` | The relative Picard functor as an abelian-group-valued presheaf. |
| `Picard_LineBundle.tex` | Line bundles on schemes and the Picard group. |
| `Rigidity.tex` | Rigidity for morphisms of group schemes (Mumford §4); status: closed. |

## Prior critique status

You were dispatched as `strategy-critic-iter123` last iter and returned
CHALLENGE on 4 must-fix items:

1. **M1 sunk-cost framing** — STRATEGY.md was using "we've already
   detailed M1's blueprint" as a justification for continuing M1
   work; ADDRESSED in STRATEGY.md by adding an explicit sunk-cost
   acknowledgement + iter-124 pivot commitment to M2.a if iter-123
   M1.b returns PARTIAL.
2. **M2.d-alt characteristic-`p` hazard** — `df = 0` only forces
   factoring through Frobenius in char $p > 0$; ADDRESSED by
   acknowledging hazard + naming 3 handling options + revising
   estimate upward to 10–20 iter / 800–1500 LOC.
3. **M2.c Galois descent phantom prereq** — strategy assumed
   "Galois descent of morphism equality of schemes" as a Mathlib
   piece without verification; SPOT-CHECK SCHEDULED THIS ITER
   (planner dispatches lean_leansearch / lean_loogle directly to
   resolve in iter-124 plan phase).
4. **M2.d-alt cotangent triviality phantom prereq** — abelian-
   variety cotangent triviality unverified; SPOT-CHECK SCHEDULED
   THIS ITER.

Iter-123 prover lane on `appLE_isLocalization` returned PARTIAL
with Step 1 (`IsLocalization.lift` forward map) and Step 4
(`isLocalization_of_algEquiv` reduction) closed in body; Steps 2+3
(cofinality + inverse identities) packaged into a single AlgEquiv
residual `sorry` at L362. Per the iter-123 commitment, since this
is "substantial Step 1+3+4 closure" (well, Step 1+4 with Step 3
deferred-but-tightly-scoped), iter-124 continues M1.b (does NOT
fire the M2.a pivot).

**Live questions for re-verification this iter**:

- Is the M1-continuation defensible given the iter-123 outcome
  (Step 1+4 closed, Step 2+3 packaged), or has the 2-iter CHURNING
  trigger now fired and the planner is rationalizing?
- Do the iter-124 phantom-prereq spot-checks (M2.c Galois descent,
  M2.d-alt cotangent triviality) need to be done before the
  prover lane runs, or after? (Note: the planner intends to do
  them this iter regardless; the question is whether failure of
  either spot-check should block the M1.b continuation.)
- Are the iter-123 M3 audit numbers (Route A ≈6500 LOC, Route B
  ≈9000 LOC, both > 5000-LOC threshold) reliable enough to drive
  user-escalation, or should the audit be re-run with a different
  granularity?

## STRATEGY.md (verbatim)

# Strategy

## Project goal

Formalize the nine protected declarations of Christian Merten's Jacobian
challenge (`references/challenge.lean`):

| File | Declaration |
|---|---|
| `Genus.lean` | `AlgebraicGeometry.genus` |
| `Jacobian.lean` | `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible` |
| `AbelJacobi.lean` | `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` |

All nine signatures are frozen by the mathematician; agents are read-only
on them. Importantly, `nonempty_jacobianWitness` quantifies over an
arbitrary curve `C : Over (Spec (.of k))` with `[SmoothOfRelativeDimension 1 C.hom]`
— no genus parameter, no $k$-rational-point hypothesis. Any sub-strategy
that depends on `C(k) ≠ ∅` (notably `C ≅ ℙ¹_k`) is mathematically false
on the protected signature (Brauer–Severi conics over `ℚ` are
counterexamples) and must be handled by base change.

## End-state (iter-121 pivot)

Prior iterations operated under a "ship with one inline `sorry`" end-
state, treating each remaining Mathlib gap as project-external and
documented-but-deferred. **Per the iter-121 user directive, this framing
is dropped**: the project's autonomous loop now operates as a Mathlib
contributor, building each missing piece directly in-tree at
Mathlib-merge quality and removing the corresponding `sorry`.

The end-state is **zero inline `sorry` in the project**. There are no
deferred tasks; every gap is on the active roadmap. The roadmap is
multi-month, decomposed into milestones M1, M2, M3 with sub-step
detail and per-step effort estimates. Iter-by-iter `PROGRESS.md`
schedules the next concrete sub-step.

## Decomposition: genus-stratified body of `nonempty_jacobianWitness`

The protected `nonempty_jacobianWitness` has signature

```
theorem nonempty_jacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] :
    Nonempty (JacobianWitness C)
```

Although signatures are frozen, bodies are not. The plan is to
restructure the proof body as a genus case-split:

```
theorem nonempty_jacobianWitness ... := by
  by_cases h : AlgebraicGeometry.genus (k := k) C.left = 0
  · exact ⟨genusZeroWitness C h⟩      -- closed by milestone M2
  · exact ⟨positiveGenusWitness C (Nat.pos_of_ne_zero h)⟩  -- closed by M3
```

`genus C : ℕ` is decidable-equality, so the `by_cases` is well-formed.
This converts M2 from "preparatory infrastructure" into an explicit
half-of-a-sorry-closure: the genus-0 sub-theorem `genusZeroWitness`
becomes a concrete Lean target. M3 is then framed as "close
`positiveGenusWitness`," which is morally what it always was.

## Current sorry inventory

| Site | Status | Roadmap section |
|---|---|---|
| `Differentials.lean` — `smooth_locally_free_omega` | closed iter-120 | — |
| `Differentials.lean` — bridge `relativeDifferentialsPresheaf_iso_kaehler_appLE` | **NEW iter-121** declaration to be introduced; sorry body | § Roadmap M1 |
| `Jacobian.lean:179` — `nonempty_jacobianWitness` | open; body to be restructured into genus case-split | § Roadmap M2 (genus-0 arm) + M3 (positive-genus arm) |

## Roadmap

### M1 — Bridge: presheaf ↔ algebra-Kähler form on an affine chart (OFF the critical path)

**Framing — critical-path status.** M1 does NOT lie on the critical
path for closing the protected chain rooted at
`nonempty_jacobianWitness` (per the iter-122 strategy-critic).
Closing M1 introduces a new declaration with a `sorry` body and then
closes it (net zero on the inhabited-sorry count); the `sorryAx` chain
through `Jacobian.lean:179` is not affected. Neither M2's
decomposition (rigidity + base change + descent + Riemann-Roch) nor
M3's decomposition (Picard or symmetric-powers + Stein) names the
M1 bridge as a prerequisite.

**Why we still execute M1.** The iter-121 user pivot directive
("act as a Mathlib contributor; no deferred tasks; fill the Mathlib
gap by writing it") explicitly invites Mathlib-contribution-candidate
work even when off the critical path of the protected chain. M1 is
the smallest such candidate: a clean generalisation of
`KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale` to the
"only the lower step is formally unramified" case (candidate name
`KaehlerDifferential.equivOfFormallyUnramified`). Detailed design
in `analogies/relative-differentials-presheaf-bridge.md`.

**Honest opportunity-cost statement (revised iter-123).** Iter-122
chose M1 over M2.a (rigidity over `k̄`, the smallest on-critical-path
step) for two reasons: (i) M1's blueprint was fully detailed with
analogist-verified Mathlib alignment; (ii) the user pivot directive
invites Mathlib-contribution work and M1's PR-extractability is its
primary value. The iter-123 strategy-critic flagged this preference
as sunk-cost-adjacent: the *fact* that M1's blueprint is detailed
(because we've worked on it) was used to justify continuing M1 work,
when the obvious fix to "M2.a's prerequisite `Rigidity.lean` refactor
has not been scoped" is to scope it.

**Iter-123 progress-critic returned CHURNING on M1** (PARTIAL ≥3 of
last K=5 iters: iter-118, iter-119, iter-122). Per STRATEGY's
critical-path-preference rule ("If the M1 work stalls — progress-critic
CHURNING for 2+ iters — pivot to M2.a"), this is the FIRST CHURNING
verdict. Iter-123 invokes the progress-critic's primary corrective
(mathlib-analogist consult on the iter-122 tactical blockers: Lan-
functor `map_comp`, `IsLocalization.of_le` alternatives, `algebraMap`
rewriting) and continues M1.b. **Iter-124 plan agent is committed**
to the following: if the iter-123 prover lane (with analogist's
inputs) returns COMPLETE or PARTIAL with substantial Step 1+3+4
closure, continue M1.b; otherwise (CHURNING continues into iter-124,
i.e. the rule's "2+ iters" trigger fires), pivot to M2.a, dispatching
the Rigidity.lean refactor scoping as the iter-124 plan-phase
deliverable. The Rigidity refactor itself is then queued for
iter-125; M2.a as a prover lane is iter-126+.

**M1 is not iff-form elegance**. An earlier framing claimed M1
"restores the iff-form elegance of the smoothness criterion"; this is
incidental, not load-bearing. The forward direction
`smooth_locally_free_omega` is closed in algebra-Kähler form and is
the only direction the project uses downstream.

**Estimated cost.** 4–7 iter / 200–400 LOC (revised iter-122 per
strategy-critic-iter122's effort-honesty challenge on M1.b: the
two-direction `IsLocalization.of_le` construction requires building
both the `A_M → A_colim` and `A_colim → A_M` homs, plus
`IsScalarTower` instances and definitional unfolds of the cocone
universal property; estimate 3–5 iter / 200–400 LOC for M1.b alone).

**Statement.** Let `f : X ⟶ S` be a morphism of schemes, `U : S.Opens`
and `V : X.Opens` affine opens with `V ≤ f ⁻¹ᵁ U`. Write
`A := Γ(S, U)`, `B := Γ(X, V)`, with the appLE algebra structure
`A → B` induced by `f`. Then the section module of the relative
cotangent presheaf at `V` is canonically `B`-linearly isomorphic to
the appLE-algebra Kähler module:

```
(relativeDifferentialsPresheaf f).presheaf.obj (.op V)  ≃ₗ[B]  Ω[B ⁄ A]
```

**API shape (per mathlib-analogist):**

- Package as a `LinearEquiv` (`≃ₗ[B]`) with `@[simps]`, mirroring
  `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale`.
- `ModuleCat.Iso` form derives freely via `LinearEquiv.toModuleIso`.
- Do NOT package as a global `PresheafOfModules` natural iso this
  milestone — pointwise consumers don't need it.

**Namespace shape (per mathlib-analogist):** the load-bearing
`appLE_isLocalization` sub-lemma is best housed under
`AlgebraicGeometry.IsAffineOpen` (not `AlgebraicGeometry.Scheme`),
matching Mathlib's `IsAffineOpen.isLocalization_basicOpen` and
`IsAffineOpen.appLE_eq_away_map`.

**Decomposition (post mathlib-analogist):**

| Step | Math content | Mathlib leverage | Est. |
|---|---|---|---|
| M1.a | The multiplicative set `M := {g ∈ A : appLE(g) ∈ B^×}` is a submonoid of `A` (project: `appLE_unitSubmonoid`) | `Submonoid.mk` | 1 iter / 30 LOC |
| M1.b | The canonical algebra map `A → A_colim` (from the `TopCat.Presheaf.pullback` colim cocone leg) exhibits `A_colim` as `IsLocalization M A_colim`. **Re-framed per mathlib-analogist**: build the inverse maps `A_M → A_colim` (via `Localization M` universal property + each `g ∈ M` is a unit in `A_colim`) and `A_colim → A_M` (via colim cocone universality, picking basic-open refinements `D(g) ⊆ W` on each open), verify composites via `IsLocalization.ringHom_ext`, then conclude `IsLocalization M A_colim` via `IsLocalization.of_le`. **Avoids the `Functor.Final` colim-comparison framing entirely** (no Mathlib closure for "colim of localizations is localization at M"). | `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen` `[verified]`; `IsLocalization.of_le` `[verified]` (`Mathlib.RingTheory.Localization.Defs`); cocone-leg morphisms from `TopCat.Presheaf.pullback` `[verified]`. | 2–3 iter / 100–250 LOC |
| M1.c | `Subsingleton Ω[A_colim/A]`. **NOT a Mathlib gap** (correction from iter-121 first draft): Mathlib has `Algebra.FormallyUnramified.of_isLocalization` (`Mathlib.RingTheory.Unramified.Basic:303`) + the `Subsingleton (KaehlerDifferential R S)` instance for `FormallyUnramified R S` (`Mathlib.RingTheory.Unramified.Basic:57-59`). Two-line proof from M1.b's `IsLocalization`. **Dropped as a standalone declaration**; inlined at M1.d call site. | `Algebra.FormallyUnramified.of_isLocalization` `[verified]` | inline / 2 LOC |
| M1.d | The tower-cancellation `LinearEquiv` `Ω[B⁄A] ≃ₗ[B] Ω[B⁄L]` for `[IsLocalization M L]`, `[Algebra L B]`, `[IsScalarTower A L B]`. Built via `KaehlerDifferential.map A L B B` + `LinearEquiv.ofBijective` using `KaehlerDifferential.exact_mapBaseChange_map` + `KaehlerDifferential.map_surjective` + the M1.c `Subsingleton` consequence. **This is the most extractable Mathlib contribution candidate** (generalises `tensorKaehlerEquivOfFormallyEtale` to the "only base is unramified" case). | `KaehlerDifferential.exact_mapBaseChange_map` `[verified]`; `KaehlerDifferential.map_surjective` `[verified]`; both in `Mathlib.RingTheory.Kaehler.Basic`. | 1 iter / 10–30 LOC |
| M1.e | Assemble the bridge by composing M1.d with the `rfl`-identification `relativeDifferentialsPresheaf_obj_kaehler` already in `Differentials.lean:58`. | The existing `rfl` lemma. | 1 iter / 10–20 LOC |

The Mathlib contribution candidate is M1.d (the
`equivOfFormallyUnramified` LinearEquiv generalisation), not M1.b
(which is too scheme-morphism-shaped for a clean upstream PR). M1.b
remains a project-local lemma; if a future Mathlib PR wants it,
extraction is straightforward.

### M2 — Genus-0 witness sub-theorem `genusZeroWitness`

**Estimated cost.** 15–30 iter / 1000–2500 LOC (revised upward iter-122
per strategy-critic-iter122's effort-honesty challenge: M2.d alone is
multi-thousand LOC because Mathlib lacks every component of
Riemann–Roch over a field — divisor module, degree map, Riemann–Roch
space, Serre duality, the Riemann–Roch theorem statement and proof. If
the **cotangent-vanishing-rigidity alternative** under M2.d closes (see
Alternative below), the realistic cost falls to 7–15 iter / 500–1200
LOC.).

**Statement.** Let `C` be a smooth proper geometrically irreducible
curve over a field `k` with `genus C = 0`. Then there exists a
`JacobianWitness` for `C` whose underlying scheme is `Spec k`.

**Critical correction from iter-121 first draft.** The first-draft
strategy named M2.c as `C ≅ ℙ¹_k`, which is **mathematically false**
for the protected signature: Brauer–Severi conics over `ℚ` (smooth
proper geometrically irreducible curves of genus 0 without
`ℚ`-rational points) are *not* isomorphic to `ℙ¹_ℚ`. The corrected M2
handles the non-`k`-rational-point case by base change to the
algebraic closure `k̄`:

- Over `k̄`, every smooth proper geom-irred curve of genus 0 has a
  `k̄`-rational point (geom-irred + nonempty source ⇒ generic point
  pulls back to a closed `k̄`-rational point on `C_{k̄}` via
  `geomIrred.exists_kalg_pt` or equivalent — the standard
  $k$-rational-point existence on the geometric fibre).
- `C_{k̄} ≅ ℙ¹_{k̄}` via the genus-0-with-rational-point step (this
  is now over `k̄`, where the identification holds; Mathlib needs
  Riemann–Roch over algebraically closed fields, still upstream
  work).
- Rigidity for `ℙ¹_{k̄} → A_{k̄}` (project's existing
  `GrpObj.eq_of_eqOnOpen` applied over `k̄`).
- Galois descent of constancy back to `k`.

For the genus-0 universal property of `J = Spec k`:

- If `C(k) ≠ ∅`: pick a marked point `P ∈ C(k)`. The unique morphism
  `ι_P : C → Spec k` is `terminal`; the factorisation claim for
  `f : C → A` with `f(P) = e_A` reduces to "f is constant at e_A,"
  which follows from rigidity (after base change to `k̄` and descent).
- If `C(k) = ∅` (Brauer–Severi case): `IsAlbanese C P J` is vacuously
  satisfied for every `P` (there are no marked points to
  universally-quantify over); the `JacobianWitness` field
  `isAlbaneseFor : ∀ P ∈ C(k), IsAlbanese C P J` is therefore vacuous.

**Decomposition.**

| Step | Math content | Mathlib leverage | Est. |
|---|---|---|---|
| M2.a | Rigidity for `ℙ¹_{k̄} → A_{k̄}`: any morphism from `ℙ¹_{k̄}` to a smooth proper geometrically irreducible group scheme `A_{k̄}` over `k̄` that hits the identity at a $k̄$-rational point is constant | The project's existing `GrpObj.eq_of_eqOnOpen` over `k̄` (Rigidity.lean) | 2–3 iter / 100 LOC |
| M2.b | Genus-0 witness for `Spec k`: define `genusZeroWitness C h` where `h : genus C = 0`, returning a `JacobianWitness C` with underlying scheme `Spec k`, trivial group structure, smoothness of relative dimension 0 (matching `genus C = 0`), and `isAlbaneseFor` either via vacuity (no $k$-rational points) or via the base-change-and-descent argument (one $k$-rational point exists) | New project material | 2 iter / 100 LOC |
| M2.c | Base-change-and-descent infrastructure: `(C ⊗_k k̄).hom : C_{k̄} → Spec k̄`; group-scheme structure of `A_{k̄}`; rigidity-and-constancy descent | Mathlib: `Scheme.Pullback`, `Spec.preserves` on group-scheme structures. **Phantom prerequisite** (iter-123 strategy-critic): "Galois descent of morphism equality of schemes" is named but unverified. Spot-check scheduled iter-124 — search likely names `AlgebraicGeometry.Scheme.descent_morphism`, `Scheme.Pullback.descent_morphismEq`, or `IsLocalGalois.descent_morphism`. If absent, M2.c estimate revises upward to 6–10 iter / 300–500 LOC for the descent-of-morphism-equality infrastructure. | 3–6 iter / 150–300 LOC (range pending iter-124 spot-check) |
| M2.d (RR path) | Genus-0 identification `C_{k̄} ≅ ℙ¹_{k̄}` over `k̄` via Riemann–Roch. Decomposes into: divisor module on a curve, degree of a divisor, Riemann–Roch space `H⁰(C, O_C(D))`, Serre duality `H⁰(C, ω_C ⊗ O(D)^∨) ≃ H¹(C, O_C(D))*`, the Riemann–Roch theorem `dim H⁰(D) − dim H⁰(K-D) = deg D + 1 − g`, the genus-0-with-`k̄`-rational-point ⇒ `ℙ¹` corollary, scheme-level `Spec(R[x,y]/(xy)) → C` and gluing | Mathlib gap on every sub-step | 15–25 iter / 1500–3000 LOC |
| M2.d (alt) | **Cotangent-vanishing rigidity alternative**: skip the `C ≅ ℙ¹` identification entirely. For genus 0, prove rigidity directly via `H⁰(C, Ω¹_{C/k}) = 0` (Serre dual of `H¹(C, O_C) = 0`, which IS the project's definition of `genus C = 0`). Concretely: for `f : C → A` with `f(P) = e_A`, the pullback `f*(Ω¹_{A/k}) → Ω¹_{C/k}` factors through `H⁰(C, Ω¹_{C/k}) = 0` (since `Ω¹_{A/k}` is trivial of rank `dim A` for an abelian variety, so its pullback's global sections inject into `H⁰(C, Ω¹_{C/k})`), forcing `df = 0`. **Characteristic-`p` hazard (iter-123 strategy-critic).** `df = 0` only forces `f` to factor through `Spec k` in characteristic 0; in characteristic `p > 0` it forces `f` to factor through the relative Frobenius `F_C : C → C^{(p)}`. To conclude constancy in char `p > 0`, one must either (i) iterate the Frobenius factorization and argue convergence (each iterate keeps `df = 0`, so converges to constant in finitely many steps for curves), (ii) invoke that abelian varieties have no rational curves (Mumford's projective-rationality argument), or (iii) reduce to char 0 via lifting / spreading-out. Each adds work the iter-122 5–10 iter / 300–800 LOC estimate did not account for. Avoids divisor modules + degree + RR space + RR theorem entirely | Mathlib: Serre duality for smooth proper curves (Mathlib gap; verified absent — `lean_leansearch` zero matches); abelian-variety cotangent triviality (**phantom prerequisite**, iter-123 strategy-critic flagged; spot-check scheduled iter-124; likely names `AbelianVariety.cotangent_trivial` / `GroupScheme.Omega_trivial`); cotangent functor's interaction with morphisms | 10–20 iter / 800–1500 LOC (revised upward iter-123 for char-`p` Frobenius work + dualizing-sheaf infrastructure required by Serre duality) |

**Sub-step dependency**: M2.b depends on M2.a (rigidity). M2.c is
prerequisite for M2.a's transport from `k̄` to `k`. M2.d (one of
the two variants) gates the case `C(k) ≠ ∅`. Concretely: M2.a can
be attempted first (stand-alone over `k̄`); M2.c and the chosen
M2.d variant are sequential prerequisites for the `Spec k`-side
conclusion. **Choosing the M2.d variant**: prefer the cotangent-
vanishing alternative if Serre duality for curves is more accessible
than full Riemann–Roch; fall back to the RR path only if Serre
duality requires Riemann–Roch as a prerequisite. The decision is
made in the iter that first attempts M2.d (estimated iter-130+).

### M3 — Positive-genus witness sub-theorem `positiveGenusWitness`

**Estimated cost.** 100+ iter / 10000+ LOC per route; honest figure
per strategy-critic-iter122. Both Route A (Picard scheme via FGA) and
Route B (symmetric powers + Stein) require multi-thousand-LOC
contributions to Mathlib for each of their top-3 gating pieces. Per
the existing route-pick decision criterion's "hard fallback" rule
(LOC > 5000 of upstream-Mathlib work ⇒ user-escalate), **user
escalation is the correct action once the route-pick audit fires**;
the audit can run independently of M1 (it is a Mathlib namespace scan
+ LOC estimate, not Lean proof work).

**Iter-123 M3 route-pick audit result.** `mathlib-analogist-m3-route-audit-iter123`
returned per-piece LOC estimates against Mathlib snapshot `b80f227`:
Route A midpoint **~6500 LOC** (A1 Hilbert+QCoh/Coh/flattening ~4150 LOC;
A2 Quot post-A1 ~1400 LOC; A3 identity-component subgroup scheme
~1025 LOC). Route B midpoint **~9000 LOC** (B1 `Sym^n` of schemes
~3075 LOC; B2 Stein factorisation ~2800 LOC; B3 RR + Brill-Noether
~3450 LOC). **Both routes exceed the 5000-LOC hard-fallback
threshold; user escalation is triggered for iter-124.**
Route A preferred on cross-utility (Hilbert/Quot/identity-component
are top-tier Mathlib infrastructure) and LOC (~2500 LOC lower at
midpoint). Three smallest extractable upstream-PR pieces (each <1500
LOC, useful regardless of route): Relative Spec functor (~700–1100
LOC; **top recommend** — strict prerequisite for Stein, useful for
affine-map factorisation in any FGA setup), identity-component of
`k`-group scheme (~850–1200 LOC; needed by both routes), QCoh+Coh
typeclass on `Scheme.SheafOfModules` (~700–900 LOC; foundational
for every downstream coherent-sheaf theorem). Persistent file:
`analogies/m3-route-audit.md`.

**Statement.** Let `C` be a smooth proper geometrically irreducible
curve over `k` with `genus C ≥ 1`. Then there exists a
`JacobianWitness` for `C` whose underlying scheme is the Albanese
variety of `C` (i.e. the connected component of the identity of
`Pic_{C/k}`, or equivalently the Stein factorisation of the
Abel–Jacobi morphism on `Sym^g(C)`).

**Two equally hard routes.** The project will pick one route after
M1 closes and the project audits Mathlib's then-current snapshot
against each route's gating dependencies.

#### Route A — Picard scheme via FGA

Hilbert schemes, Quot schemes, representability of the Picard
functor for smooth proper geometrically connected curves,
identity-component construction.

**Top-3 gating Mathlib pieces** (each is itself a multi-thousand-LOC
contribution candidate):

1. **Hilbert scheme representability for projective schemes**:
   `Mathlib.AlgebraicGeometry.Hilbert.Representability` (doesn't
   exist). Decomposes into (a) the Hilbert functor as a functor
   $(\Sch/k)^{\mathrm{op}} \to \Sets$, (b) the representability theorem
   via Grothendieck's flattening stratification, (c) the
   smoothness/properness of the Hilbert scheme on smooth projective
   bases.
2. **Quot scheme representability**: representability of the Quot
   functor of coherent quotients on a proper scheme. Generalises
   Hilbert; depends on coherent-sheaf-of-finite-type infrastructure
   that is partially in Mathlib.
3. **Identity-component construction `G^0 ⊆ G`**: for a $k$-group
   scheme `G` locally of finite type, the connected component of the
   identity as a closed (and open) subgroup scheme. Requires
   `IsConnectedSpace` for the identity component, plus the topological
   connectedness of identity components of group objects in `Scheme/k`.

#### Route B — Symmetric powers + Stein factorisation

Scheme-level symmetric powers, finite-group-scheme quotients,
Brill–Noether–Riemann–Roch, Stein factorisation.

**Top-3 gating Mathlib pieces**:

1. **Symmetric powers of schemes `Sym^n X` with smoothness**:
   `Mathlib.AlgebraicGeometry.SymmetricPower` (doesn't exist).
   Requires the finite-group-quotient construction `X^n / S_n` with
   smoothness when `X` is smooth (Fogarty's symmetric-product
   computation).
2. **Stein factorisation theorem**: for a proper morphism
   `f : X → Y` of locally Noetherian schemes, $f_* \mathcal O_X$ is a
   coherent $\mathcal O_Y$-algebra and $f$ factors as
   $X \to \mathrm{Spec}_Y(f_*\mathcal O_X) \to Y$. Requires coherent
   $\mathcal O$-module cohomology of proper morphisms (partially in
   Mathlib).
3. **Brill–Noether and Riemann–Roch**: as for M2.d, the curve-side
   Riemann–Roch input is the largest Mathlib gap; absent from
   Mathlib in usable form for the project's genus-via-Ext
   definition.

#### Route-pick decision criterion

**Trigger** (revised iter-122 per strategy-critic-iter122). The
Mathlib-coverage audit is an offline LOC estimation that does NOT
depend on M1 closure. **Schedule: iter-123** (immediately after the
iter-122 M1 work returns its first results, regardless of whether
M1 closes; the audit is a parallel deliverable, not a sequential
gate). The route is "picked" once the audit returns its honest LOC
totals.

**Criterion.** Run a Mathlib coverage audit of each route's top-3
gating pieces. For each missing piece, estimate the project-internal
LOC required to build it (the typical multi-K LOC contribution). Pick
the route with the smaller cumulative LOC estimate. **Tiebreaker**:
if estimates are within 20% of each other, prefer the route whose
top-3 gating pieces have the most cross-utility outside the Jacobian
arc (the Hilbert/Quot/representability infrastructure of Route A has
broader downstream value; the symmetric-power / Stein machinery of
Route B is more curve-specific). **Hard fallback**: if both routes
exceed 5000 LOC of estimated upstream-Mathlib work, escalate to the
user for an external-PR routing decision (likely: post an upstream
PR for at least the smallest gating piece and continue on the
remaining routes-and-arms while waiting).

#### Per-iter progress signal for M3

During M3's multi-iter run, the progress signal is:

- **Iter $N$ "on track" criteria**:
  1. At least one named gating piece has its scaffolding declaration
     (with `sorry` body) introduced or its body partially closed.
  2. The cumulative LOC against the route's bill-of-materials
     decreases or stays flat (an iter that ADDS LOC to the BOM is
     CHURNING; the route is on a deeper gap than estimated).
  3. The cumulative `\leanok`-tagged declarations across the BOM
     increases by at least one per 2 iters (otherwise CHURNING).
- **Iter "off track" signal**:
  1. Two iters in a row introduce a new helper declaration whose
     blueprint chapter doesn't yet exist (blueprint expansion is
     overdue).
  2. The prover lane on the BOM's smallest piece returns INCOMPLETE
     twice consecutively (the piece is too tightly coupled to
     Mathlib infrastructure; pivot strategy or escalate to user).

## What ships unconditionally (current snapshot)

These files compile end-to-end with no `sorryAx` in their axiom chains
as of iter-120 close:

- `Rigidity.lean` — Mumford rigidity for pointed proper smooth morphisms.
- `Genus.lean` — `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`.
- `Cohomology/SheafCompose.lean` / `StructureSheafAb.lean` /
  `StructureSheafModuleK.lean` / `MayerVietorisCore.lean` /
  `MayerVietorisCover.lean` — the Čech / Mayer–Vietoris infrastructure
  consumed by `Genus.lean`.
- `Differentials.lean` (current declarations) —
  `relativeDifferentialsPresheaf` definition,
  `relativeDifferentialsPresheaf_obj_kaehler` identification,
  `smooth_locally_free_omega` forward direction (algebra-Kähler form).
  The bridge declaration `relativeDifferentialsPresheaf_iso_kaehler_appLE`
  introduced by iter-121 will hold a `sorry` body during M1.

The protected `genus` and `Rigidity` are unconditional.

## What ships against the genus case-split (current snapshot)

The protected `Jacobian`-arc declarations (`Jacobian.lean` +
`AbelJacobi.lean`) all `lean_verify` to `sorryAx` rooted at
`Jacobian.lean:179`. Once M2 lands `genusZeroWitness` and M3 lands
`positiveGenusWitness`, the genus-stratified body of
`nonempty_jacobianWitness` closes the chain. Until then, the framework
around the Albanese variety (group-object structure, smoothness of
relative dimension `g`, properness, geometric irreducibility, the
Abel–Jacobi map, and the universal property) ships against the
witness existence.

## Soundness rules

- **No new axioms.** Every closed declaration must `lean_verify` to
  kernel-only axioms (`propext, Classical.choice, Quot.sound`). The
  iter-122 strategy-critic raised an alternative end-state of
  promoting `nonempty_jacobianWitness` to a named project `axiom`
  (signature unchanged, the protected chain `lean_verify`s to one
  named project axiom + kernel axioms). **This alternative is ruled
  out by the plan-agent standing instruction in `prompts/plan.md`
  ("You should NEVER propose adding new axioms")**, which supersedes
  the iter-121 user pivot directive — the plan-agent hard rule is a
  project-wide standing rule, while the user pivot directive is an
  iter-by-iter strategic instruction. The named-axiom alternative is
  therefore not on the table.
- **No "deferred" framing.** Mathlib gaps are decomposed into the
  M1/M2/M3 roadmap with concrete sub-step estimates; the planner does
  not write "out-of-autonomous-loop scope" sections anymore. If a
  sub-step is genuinely outside the loop's reach (e.g. requires a
  multi-month upstream contribution), it is recorded in the roadmap
  with an explicit "blocked on upstream X" note and a fallback
  iter-by-iter approach that progresses the surrounding sub-steps.
- **No phantom $k$-rational-point hypotheses.** The protected
  `nonempty_jacobianWitness` quantifies over arbitrary `C` without
  $k$-rational points. Sub-strategies that depend on $C(k) \neq \emptyset$
  (notably `C ≅ ℙ¹_k`) must explicitly handle the no-rational-point
  case via base change to $\bar k$ + Galois descent, or document why
  vacuity (`isAlbaneseFor` is vacuously true when $C(k) = \emptyset$)
  suffices.
- **Converse of `smooth_locally_free_omega` is mathematically false.**
  The counterexample `Spec k → Spec k[t]` via `t ↦ 0` (locally of
  finite presentation, `Ω = 0` everywhere locally free, but not flat
  hence not smooth) breaks the bare local-freeness-of-Ω implication.
  The true converse needs `Subsingleton (Algebra.H1Cotangent A B)`
  (formal smoothness via vanishing André–Quillen `H¹`). The blueprint
  chapter `Differentials.tex` discloses this; we do not state the
  false iff. The Mathlib converse-lemma
  `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` `[verified]`
  exists with these extra hypotheses; an optional future M4 milestone
  may wire it up as a scheme-level converse-with-extra-hypothesis
  result if a downstream consumer needs it.

## Mathlib gap inventory (live)

The roadmap above absorbs every gap previously labelled "Mathlib gap"
into a concrete milestone. For clarity:

- **Gap (bridge)**: subsumed by milestone M1.
- **Gap (genus-0 identification `C ≅ ℙ¹_k`)**: replaced under M2 by
  the base-change-to-`k̄` + descent argument; M2.d still depends on
  a Riemann–Roch-over-`k̄` upstream piece, but the false unconditional
  `C ≅ ℙ¹_k` claim is corrected.
- **Gap (Hilbert/Quot/FGA)**: subsumed by milestone M3 Route A,
  decomposed into top-3 gating pieces above.
- **Gap (symmetric powers / Stein factorisation)**: subsumed by
  milestone M3 Route B, decomposed into top-3 gating pieces above.
- **Gap (converse of smoothness criterion)**: optional future M4,
  driven by downstream consumer demand.
- **Gap (Galois descent of morphism equality of schemes)**: subsumed
  by milestone M2.c.

All gaps are in-scope; none are project-external. The loop's job is
to execute the roadmap, one sub-step per iter, recording PARTIAL
progress in `PROGRESS.md` and the iter sidecar as each sub-step
advances.

## Sequencing (current snapshot)

The current loop position: **M1.b is mid-execution.** Iter-122 introduced
the M1 bridge scaffolding (`appLE_unitSubmonoid` def, `appLE_isLocalization`
theorem with `sorry`, `relativeDifferentialsPresheaf_equiv_kaehler_appLE`
def with `sorry`) and closed 3 of 4 sorry sites in the same iter, including
Step 0 of the M1.b body (`isUnit_appLE_unitSubmonoid_in_colim`). Iter-123
continues M1.b targeting Steps 1–4 of the `IsLocalization.of_le` chain,
with a fresh mathlib-analogist consult on the iter-122 tactical blockers
(Lan-functor `map_comp`, `IsLocalization.of_le` alternatives, `algebraMap`
rewriting) per the iter-123 progress-critic's CHURNING corrective.

**On-critical-path alternatives** (queued, not active this iter):
- M2.a (rigidity over `k̄`) requires a `Rigidity.lean` source-side refactor
  (per blueprint-writer-jacobian-iter121 finding on `GrpObj.eq_of_eqOnOpen`
  needing a non-group-object source). Refactor scoping is iter-124's
  plan-phase deliverable iff M1.b CHURNING repeats (iter-124 progress-critic
  fires the 2-iter trigger). M2.a as a prover lane is then iter-126+.
- M3 user escalation is the iter-124 plan-phase deliverable, regardless of
  M1.b outcome — both routes audited at >5000 LOC of Mathlib gap (iter-123
  M3 audit, see § M3).

The genus-stratified body restructure of `nonempty_jacobianWitness` (the
`by_cases h : genus C = 0` decomposition) lands once `genusZeroWitness`
(M2 output) and `positiveGenusWitness` (M3 output) are at least scaffolded
with sorry-bodies. The estimated iter for this restructure is post-M2.b /
post-M3-scaffolding, i.e. multi-month away.
