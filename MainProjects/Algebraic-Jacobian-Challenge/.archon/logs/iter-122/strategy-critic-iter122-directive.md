# Strategy Critic Directive

## Slug
iter122

## Project goal

Formalize the nine protected declarations of Christian Merten's Jacobian
challenge (`references/challenge.lean`), namely
`AlgebraicGeometry.genus`,
`AlgebraicGeometry.Jacobian`,
`Jacobian.instGrpObj`,
`Jacobian.smoothOfRelativeDimension_genus`,
`Jacobian.instIsProper`,
`Jacobian.instGeometricallyIrreducible`,
`Jacobian.ofCurve`,
`Jacobian.comp_ofCurve`,
`Jacobian.exists_unique_ofCurve_comp`.
Per the iter-121 user directive, the loop now operates as a Mathlib
contributor: every previously-deferred Mathlib gap is on the active
roadmap, end-state is zero inline `sorry`, no deferred tasks.

## Strategy under review

<paste below: verbatim contents of `.archon/STRATEGY.md` at iter-122
plan-phase head>

```markdown
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
detail and per-step effort estimates.

## Decomposition: genus-stratified body of `nonempty_jacobianWitness`

The protected `nonempty_jacobianWitness` has signature

```
theorem nonempty_jacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] :
    Nonempty (JacobianWitness C)
```

Body restructure plan: `by_cases h : genus C = 0`. The genus-0 arm
closes via the M2 sub-theorem `genusZeroWitness`; the positive-genus
arm closes via the M3 sub-theorem `positiveGenusWitness`.

## Roadmap

### M1 — Bridge: presheaf ↔ algebra-Kähler form on an affine chart

**Framing.** M1 is upstream Mathlib infrastructure investment. The
closure of the new bridge declaration
`relativeDifferentialsPresheaf_equiv_kaehler_appLE` reduces the project's
sorry count by 1 once introduced and closed. Its value is producing a
clean Mathlib contribution candidate generalising
`KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale` to the "only the
lower step is formally unramified" case (candidate name
`KaehlerDifferential.equivOfFormallyUnramified`).

**Statement.** Let `f : X ⟶ S` be a morphism of schemes, `U : S.Opens`
and `V : X.Opens` affine opens with `V ≤ f ⁻¹ᵁ U`. Write
`A := Γ(S, U)`, `B := Γ(X, V)` with appLE algebra structure `A → B`.
Then the section module of the relative cotangent presheaf at `V` is
canonically `B`-linearly equivalent to the appLE-algebra Kähler module:

```
(relativeDifferentialsPresheaf f).presheaf.obj (.op V)  ≃ₗ[B]  Ω[B ⁄ A]
```

**API shape** (per mathlib-analogist-bridge-iter121): `LinearEquiv`
(`≃ₗ[B]`) with `@[simps]`. Namespace: load-bearing
`appLE_isLocalization` under `AlgebraicGeometry.IsAffineOpen`.

**Decomposition (post mathlib-analogist findings):**

| Step | Math content | Mathlib leverage | Est. |
|---|---|---|---|
| M1.a | Submonoid `M := {g ∈ A : appLE(g) ∈ B^×}` | `Submonoid.mk` | 1 iter / 30 LOC |
| M1.b | `IsLocalization M A_colim` via two-direction `IsLocalization.of_le` construction (build `A_M → A_colim` via `Localization.lift`; build `A_colim → A_M` via colim cocone universal property; verify composites via `IsLocalization.ringHom_ext`). Avoids `Functor.Final` colim-comparison entirely. | `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen` `[verified]`; `IsLocalization.lift`, `IsLocalization.ringHom_ext`, `IsLocalization.of_le` `[verified]` | 2-3 iter / 100-250 LOC |
| M1.c | `Subsingleton Ω[A_colim/A]` — two-line re-export via `Algebra.FormallyUnramified.of_isLocalization` + `subsingleton_kaehlerDifferential` instance. NOT a Mathlib gap. | `Algebra.FormallyUnramified.of_isLocalization` `[verified]` | inline / 2 LOC |
| M1.d | Tower-cancellation `LinearEquiv` `Ω[B⁄A] ≃ₗ[B] Ω[B⁄L]` for `[IsLocalization M L]`, `[Algebra L B]`, `[IsScalarTower A L B]`. Built via `KaehlerDifferential.map` + `LinearEquiv.ofBijective` using `exact_mapBaseChange_map` + `map_surjective` + M1.c `Subsingleton`. Most extractable Mathlib contribution candidate. | `KaehlerDifferential.exact_mapBaseChange_map` + `KaehlerDifferential.map_surjective` `[verified]` | 1 iter / 10-30 LOC |
| M1.e | Assemble bridge: M1.d composed with `relativeDifferentialsPresheaf_obj_kaehler`. | The existing `rfl` lemma. | 1 iter / 10-20 LOC |

Total M1: 3-6 iter / 130-300 LOC.

### M2 — Genus-0 witness sub-theorem `genusZeroWitness`

**Estimated cost.** 5-10 iter / 250-600 LOC.

**Statement.** `C` smooth proper geom-irred of `genus = 0` over `k`
⇒ ∃ `JacobianWitness C` whose underlying scheme is `Spec k`.

**Critical correction from iter-121 first draft.** The first-draft
strategy named M2.c as `C ≅ ℙ¹_k`, which is **mathematically false**
for the protected signature: Brauer–Severi conics over `ℚ` are
counterexamples. The corrected M2 handles the non-`k`-rational-point
case by base change to `k̄`:
- Over `k̄`, every smooth proper geom-irred curve of genus 0 has a
  `k̄`-rational point ⇒ `C_{k̄} ≅ ℙ¹_{k̄}` via genus-0+rational-point
  (still upstream Mathlib work).
- Rigidity for `ℙ¹_{k̄} → A_{k̄}` (project's `GrpObj.eq_of_eqOnOpen`
  over `k̄`).
- Galois descent of constancy back to `k`.

For the genus-0 universal property of `J = Spec k`:
- If `C(k) ≠ ∅`: pick a marked point `P ∈ C(k)`, reduce to constancy
  via rigidity after base change.
- If `C(k) = ∅` (Brauer–Severi case): `IsAlbanese C P J` is vacuously
  satisfied (no marked points to universally-quantify over); the
  `JacobianWitness` field `isAlbaneseFor` is therefore vacuous.

**Decomposition.**

| Step | Math content | Mathlib leverage | Est. |
|---|---|---|---|
| M2.a | Rigidity for `ℙ¹_{k̄} → A_{k̄}` | Project's `GrpObj.eq_of_eqOnOpen` over `k̄` | 2-3 iter / 100 LOC |
| M2.b | Genus-0 witness for `Spec k` | New project material | 2 iter / 100 LOC |
| M2.c | Base-change-and-descent infrastructure | Mathlib `Scheme.Pullback`; Galois descent | 3-6 iter / 150-300 LOC |
| M2.d | Genus-0 identification `C_{k̄} ≅ ℙ¹_{k̄}` over `k̄` | Mathlib gap (Riemann-Roch over `k̄`); partial cohomology coverage in `StructureSheafModuleK.lean`/`MayerVietorisCore.lean` | 5-10 iter / 250-500 LOC |

M2.b depends on M2.a. M2.c is a prerequisite for M2.a's transport from
`k̄` to `k`. M2.d gates the `C(k) ≠ ∅` case.

### M3 — Positive-genus witness sub-theorem `positiveGenusWitness`

**Estimated cost.** Many tens of iters / thousands of LOC; multi-month.

**Statement.** `C` smooth proper geom-irred of `genus ≥ 1` ⇒ ∃
`JacobianWitness C` whose underlying scheme is the Albanese variety.

**Two equally hard routes** (picked after M1 closes, by Mathlib-coverage
audit + cumulative LOC estimate + cross-utility tiebreaker).

#### Route A — Picard scheme via FGA

Hilbert schemes, Quot schemes, representability of Picard functor for
smooth proper geom-connected curves, identity-component construction.

Top-3 gating Mathlib pieces:
1. **Hilbert scheme representability for projective schemes**: doesn't
   exist; decomposes into Hilbert-functor representability via
   Grothendieck flattening, smoothness/properness on smooth projective
   bases.
2. **Quot scheme representability**: representability of Quot-of-coherent
   functor on a proper scheme.
3. **Identity-component construction `G^0 ⊆ G`**: for a `k`-group scheme
   locally of finite type.

#### Route B — Symmetric powers + Stein factorisation

Scheme-level symmetric powers, finite-group-scheme quotients,
Brill-Noether-Riemann-Roch, Stein factorisation.

Top-3 gating Mathlib pieces:
1. **Symmetric powers of schemes `Sym^n X` with smoothness**:
   doesn't exist; requires `X^n / S_n` finite-group-quotient
   construction.
2. **Stein factorisation theorem**: for proper `f : X → Y` of locally
   Noetherian schemes, `f_* O_X` is a coherent `O_Y`-algebra and `f`
   factors as `X → Spec_Y(f_* O_X) → Y`.
3. **Brill-Noether and Riemann-Roch**: curve-side Riemann-Roch input;
   largest Mathlib gap.

#### Route-pick decision criterion

Trigger: first iter after M1 closes. Run Mathlib coverage audit per
route; pick smaller cumulative LOC. Tiebreaker (within 20%): prefer
route with more cross-utility outside Jacobian arc (Route A's
Hilbert/Quot infrastructure beats Route B's curve-specific machinery).
Hard fallback: if both routes exceed 5000 LOC of upstream-Mathlib work,
escalate to user.

#### Per-iter progress signal for M3

On-track: at least one named gating piece scaffolds (with `sorry` body)
or its body partially closes; cumulative LOC against route's BOM
decreases or stays flat; cumulative `\leanok`-tagged declarations
across BOM increases by ≥1 per 2 iters.

Off-track: two iters in a row introduce new helper declaration whose
blueprint chapter doesn't exist; prover lane on BOM's smallest piece
returns INCOMPLETE twice consecutively.

## What ships unconditionally (current snapshot)

These files compile end-to-end with no `sorryAx` in their axiom chains
as of iter-120 close: `Rigidity.lean`, `Genus.lean`,
`Cohomology/SheafCompose.lean`, `Cohomology/StructureSheafAb.lean`,
`Cohomology/StructureSheafModuleK.lean`, `Cohomology/MayerVietorisCore.lean`,
`Cohomology/MayerVietorisCover.lean`, `Differentials.lean`.

## What ships against the genus case-split (current snapshot)

The protected `Jacobian`-arc declarations (`Jacobian.lean` +
`AbelJacobi.lean`) all `lean_verify` to `sorryAx` rooted at
`Jacobian.lean:179`. Once M2 lands `genusZeroWitness` and M3 lands
`positiveGenusWitness`, the genus-stratified body of
`nonempty_jacobianWitness` closes the chain.

## Soundness rules

- **No new axioms.** Every closed declaration must `lean_verify` to
  kernel-only axioms (`propext, Classical.choice, Quot.sound`).
- **No "deferred" framing.** Mathlib gaps are decomposed into the
  M1/M2/M3 roadmap with concrete sub-step estimates.
- **No phantom `k`-rational-point hypotheses.** Sub-strategies that
  depend on `C(k) ≠ ∅` must explicitly handle the no-rational-point
  case via base change to `k̄` + Galois descent, or document why
  vacuity (`isAlbaneseFor` is vacuously true when `C(k) = ∅`) suffices.

## Iter-122 sequencing

Iter-122 schedules **M1.a or M1.b** as the first concrete sub-step,
contingent on the iter-122 blueprint-reviewer clearing the HARD GATE
on `Differentials.tex` (iter-121 blueprint-writer pass + iter-122
inline plan-agent corrections incorporating mathlib-analogist findings
have landed; both Differentials and Jacobian chapter cleanups
this iter incorporate the lean-vs-blueprint-checker review121
findings).

M2 enters the active prover queue after M1 produces enough structural
advance (estimated iter-125 or iter-126).

M3 enters the prover queue after M1 closes (or makes substantial
progress) and the route-pick criterion fires (estimated iter-128+).
```

## References index

```markdown
# References

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

## Blueprint summary

- `AbelJacobi.tex` — the Abel-Jacobi map `C → Jac(C)` and its
  universal property among morphisms to abelian varieties.
- `Cohomology_MayerVietoris.tex` — Mayer-Vietoris LES for `HModule'`
  cohomology, plus Čech-acyclic-cover Cech-to-derived comparison.
- `Cohomology_SheafCompose.tex` — sheaf composition via forgetful
  functor (`HasSheafCompose` instance for the forget functor).
- `Cohomology_StructureSheafAb.tex` — `Scheme.toAbSheaf` (`O_X` as a
  sheaf of additive groups) and Ext infrastructure for it.
- `Cohomology_StructureSheafModuleK.tex` — `Scheme.toModuleKSheaf`
  (`O_X` as a sheaf of `k`-modules), `HModule` / `HModule'` Ext-based
  cohomology classes, plus the multi-page Čech-cohomology
  reconciliation infrastructure used by `Genus.tex`.
- `Differentials.tex` — relative cotangent presheaf, forward direction
  of smoothness criterion (algebra-Kähler form), milestone M1 bridge
  to presheaf form, milestone M4 converse (out-of-scope per
  H1Cotangent hypothesis), M5-M8 milestones (sheafification,
  cotangent exact sequence, etc.).
- `Genus.tex` — definition of arithmetic genus `genus C := dim_k H¹(C, O_C)`
  via the project's `HModule`/`HModule'` infrastructure.
- `Jacobian.tex` — definition of `JacobianWitness`, `Jacobian`,
  protected instance projections, statement of `nonempty_jacobianWitness`
  (the project's single foundational existence hypothesis), expanded
  C.2 sub-step (genus-0 rigidity via base change to `k̄` + Galois
  descent; iter-121 rewrite).
- `Modules_Monoidal.tex` — monoidal-category structure on the
  category of `Scheme.toModuleKSheaf`-modules (used for the cotangent
  exact sequence's beta map).
- `Picard_Functor.tex` — Picard functor of a scheme (contravariant
  functor to `AddCommGrp` via `Pic`).
- `Picard_FunctorAb.tex` — Picard functor in the `AddCommGrp` /
  `Additive` wrapper form (used for the Albanese functor framing).
- `Picard_LineBundle.tex` — line-bundle approximation via global-
  sections Picard `CommRing.Pic` (legacy genus-0 framework; not
  active for the current `nonempty_jacobianWitness` roadmap).
- `Rigidity.tex` — Mumford rigidity for pointed proper smooth
  morphisms via `GrpObj.eq_of_eqOnOpen`.

## Prior critique status

The iter-121 strategy-critic returned CHALLENGE on M2 and M3 with
three concrete corrections, all addressed by the STRATEGY.md rewrite
landed iter-121:
- M2: genus-stratified body `by_cases h : genus C = 0` adopted.
- M2.c (false `C ≅ ℙ¹_k` step): replaced with base-change-to-`k̄` +
  Galois descent.
- M3: explicit route-pick criterion + top-3 gating pieces per route
  + per-iter progress signal rules added.

The iter-121 strategy is unchanged at iter-122 head (no further
rewrites this iter). Re-verify whether the iter-121 challenges are
now adequately addressed and whether any new strategic concerns
surface on a fresh read.
