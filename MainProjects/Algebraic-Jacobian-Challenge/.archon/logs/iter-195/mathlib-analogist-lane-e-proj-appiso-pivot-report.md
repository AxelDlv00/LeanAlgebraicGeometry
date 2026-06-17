# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
lane-e-proj-appiso-pivot

## Iteration
195

## Structural problem

Lane E has been STUCK for 7 iters (iter-188 → iter-194) on evaluating
`(Proj.awayι 𝒜 f).appIso ⊤ .inv : Γ(Spec(Away 𝒜 f), ⊤) → Γ(Proj 𝒜, basicOpen 𝒜 f)`
on a specific generator `isLocElem`. Abstracted: given an iso `α : F(U) ≅ G(V)`
between section presheaves, evaluate `α.inv` on a canonical generator.
Direct chasing of the iso-definition chain (4 attempted approaches in
the directive's "Failed approaches" log) has been the consistent
failure mode.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `IsAffineOpen.fromSpec_app_self` (`Mathlib/AlgebraicGeometry/AffineScheme.lean:560`) | alg geom — affine open theory | low (30-50 LOC, 1-2 iters) | ANALOGUE_FOUND |
| `IsAffineOpen.app_basicOpen_eq_away_map` (`Mathlib/AlgebraicGeometry/AffineScheme.lean:684`) | alg geom — affine + IsLocalization UMP | medium (40-70 LOC, 1-2 iters) | ANALOGUE_FOUND |
| `CategoryTheory.Iso.eq_inv_apply` / `Scheme.Hom.appIso_inv_app` (`Mathlib/AlgebraicGeometry/OpenImmersion.lean:224`) | category theory — universal flip technique | low-medium (20-40 LOC, 1 iter) | ANALOGUE_FOUND |
| `ΓSpec.adjunction.unit.app` / `ΓSpecIso_inv_ΓSpec_adjunction_homEquiv` | alg geom — adjunction-unit eval | medium (50-80 LOC) | PARTIAL_ANALOGUE |
| `InnerProductSpace.toDual.symm` (Riesz Representation) | functional analysis | medium-high | PARTIAL_ANALOGUE |
| `IsLocalization.algEquiv.symm_apply` / `ringHom_ext` | commutative algebra — UMP | medium | PARTIAL_ANALOGUE |

## Top suggestion

**Adopt analogue #1 (`IsAffineOpen.fromSpec_app_self`) as the
iter-196 Lane E route-pivot.** The Mathlib lemma at
`Mathlib/AlgebraicGeometry/AffineScheme.lean:560-564` is the SAME
structural theorem on a slightly different canonical iso —
`Scheme.IsAffineOpen.fromSpec` vs `Proj.awayι` — both defined by the
SAME composition pattern `isoSpec.inv ≫ ι` (compare
`AffineScheme.lean:414-417` to `ProjectiveSpectrum/Basic.lean:189`).
Mathlib's proof technique transports directly: build a project-local
`Proj.awayι_app_basicOpen` mirroring `fromSpec_app_self`, using the
already-present substrate `Proj.basicOpenToSpec_app_top`
(`ProjectiveSpectrum/Basic.lean:143`) as the explicit-formula primitive.
Then via `Scheme.Hom.appIso_hom` (`OpenImmersion.lean:199`), `appIso ⊤`
reduces to a closed-form composition of `basicOpenIsoAway` and
`ΓSpecIso`, and the inverse evaluation `appIso ⊤ .inv isLocElem`
closes via `Iso.eq_inv_apply` + `awayToSection_apply` (the explicit
`HomogeneousLocalization.val` formula).

**First Mathlib file to read**:
`Mathlib/AlgebraicGeometry/AffineScheme.lean:481-565` — the
`fromSpec_app_of_le` → `ΓSpecIso_hom_fromSpec_app` → `fromSpec_app_self`
→ `@[elementwise]` chain, used as the proof-shape template.

**First project file to touch**:
`AlgebraicJacobian/AbelianVarietyRigidity.lean` — add
`Proj.awayι_app_basicOpen` and `Proj.awayι_appIso_top_inv_apply`
helpers above `kbarChart1Ring_specMap_fac` (line 222). Then close the
two structurally-equivalent sorries at lines 273
(`kbarChart1Ring_specMap_fac`) and 481 (`iotaGm_chart1_appIso_eval`)
via the new helpers. The iter-194 reduction has already shown both
sorries reduce to the same residual — closing one closes both modulo
iso-chain functoriality.

If analogue #1 unexpectedly snags during the iter-196 attempt,
**fallback** to analogue #3 (the `Iso.eq_inv_apply` + `appIso_hom`
direct chain). It's strictly more surgical and uses only Mathlib's
existing `basicOpenToSpec_app_top` substrate without building a new
helper, at the cost of leaving the `appIso ⊤` formula in raw form for
each consumer.

## Discarded
- `LocallyRingedSpace.Hom.appIso` (directive hint #1): UPSTREAM of
  `Scheme.Hom.appIso`. The project's failed approaches WERE chasing
  through this layer — porting back makes the problem harder.
- `Scheme.Spec.appIso` (directive hint #3): no Spec-specific evaluation
  lemma beyond the `ΓSpecIso` identification, which analogue #1
  already uses.
- `SheafCondition.equalizer` (directive hint #5): wrong-shape — helps
  prove `is a sheaf`, not evaluate canonical isos.
- `RingedSpace.PresheafedSpace.Hom.app` (directive hint #4): same
  upstream-direction failure mode as the LRS hint.
- `Knaster–Tarski` / order-theoretic fixed points: not a fixed-point
  problem; wrong shape.
- `OrderIso.symm_apply_eq` / `Equiv.symm_apply_eq`: subsumed by the
  categorical `Iso.eq_inv_apply` in analogue #3.

## Persistent file
- `analogies/lane-e-proj-appiso-pivot.md` — full analogue list with
  per-analogue technique, mapping to project objects, and detailed
  proof-sketch port for the recommended route.

Overall verdict: **ANALOGUE_FOUND** — Mathlib has solved the same
structural problem in `IsAffineOpen.fromSpec_app_self` for affine-open
canonical isos; the technique ports verbatim to `Proj.awayι` with
30-50 LOC of project-local plumbing, well within budget for iter-196.
