# AlgebraicJacobian/RiemannRoch/WeilDivisor.lean (Lane I, iter-194)

## Summary

**HARD BAR MET**: 1 axiom-clean substrate helper closed (the
`instIsLocallyNoetherianProjectiveLineBar` typed-sorry typeclass
instance). File state: **5 sorries → 4 sorries**, build GREEN, 0 axioms
introduced.

PUSH-BEYOND attempts on the second instance + body were structurally
blocked by genuine Mathlib gaps (DVR-stalks-on-Proj substrate; the
function-field-determines-curve correspondence + the affine-chart-
pullback bridge). The body of `degree_positivePart_principal_eq_finrank`
received a partial structural advance: `hLPUnif` is now destructured to
expose the uniformiser witness `Y₀` for downstream consumption once the
affine-chart bridge lands.

## `instIsLocallyNoetherianProjectiveLineBar` (line 703)

### Attempt 1 — Compose `IsProper ⟹ LocallyOfFiniteType` + Noetherian base

- **Approach**: Apply `LocallyOfFiniteType.isLocallyNoetherian` to
  `(ProjectiveLineBar kbar).hom`. The hom is `IsProper` (existing
  `projectiveLineBar_isProper` from `BareScheme.lean:106`), hence
  `LocallyOfFiniteType` via `IsProper.toLocallyOfFiniteType`. The base
  `Spec (.of kbar)` is `IsLocallyNoetherian` because the field `kbar` is
  Noetherian (Field ⟹ PID ⟹ Noetherian via Mathlib synthesis).
- **Result**: RESOLVED axiom-clean. 4 LOC.
- **Key insight**: The fully derived chain `IsProper →
  LocallyOfFiniteType` + `LocallyOfFiniteType.isLocallyNoetherian` is a
  direct Mathlib-only composition; no new substrate required.

## `instIsRegularInCodimOneProjectiveLineBar` (line 719) — UNCHANGED

### Attempt 1 — Direct stalk-level computation via Proj structure

- **Approach considered**: Show every prime divisor `Y` of
  `(ProjectiveLineBar kbar).left` has `IsDiscreteValuationRing` on the
  stalk. The stalk is `HomogeneousLocalization.AtPrime 𝒜
  Y.point.asHomogeneousIdeal` (Mathlib `Proj.stalkIso'`); for a codim-1
  closed point of ℙ¹_{k̄}, this is morally the localization of `k̄[X₀,X₁]`
  at a height-1 homogeneous prime, hence DVR.
- **Result**: NOT ATTEMPTED — the formal chain "homogeneous localization at
  height-1 homogeneous prime of `k̄[X₀,X₁]` = DVR" is itself a Mathlib gap;
  the affine-chart `Spec(k̄[t])` is Dedekind, but the
  `Proj.affineCover.IsLocalization ↔ presheaf.stalk` bridge to lift this
  is not present in `b80f227`.
- **Alternative considered**: thread `[SmoothOfRelativeDimension 1
  (ProjectiveLineBar kbar).hom]` into the instance signature and derive
  via smooth ⟹ regular ⟹ DVR-at-codim-1. Rejected because the
  `SmoothOfRelativeDimension` instance on ProjectiveLineBar is itself a
  scaffold `sorry` (BareScheme.lean:154-156), so this would chain through
  a project-side `sorry`.
- **Next step**: iter-195+ would attempt either (a) close the
  `projectiveLineBar_smoothOfRelativeDimension` substrate in
  `BareScheme.lean` (Lane A scope) then chain through `IsSmooth ⟹
  IsRegularLocalRing` ⟹ `IsDiscreteValuationRing`, or (b) bespoke
  ℙ¹-specific DVR-stalk computation via the affine cover `Spec(k̄[t])`.

## `degree_positivePart_principal_eq_finrank` (line 763) — PARTIAL

### Attempt 1 — Partial structural advance (unpack `hLPUnif`)

- **Approach**: `obtain ⟨Y₀, hY₀_one, hY₀_unique⟩ := hLPUnif` to expose the
  uniformiser witness in the proof context. The remainder of the body
  needs the scheme-level morphism `φ : C → ℙ¹` from the function-field
  embedding and the affine-chart bridge (`Spec(A) ⊂ ℙ¹` with `A = k̄[t_∞]`,
  `Spec(B) := φ^{-1}(Spec(A))`) to apply `Ideal.sum_ramification_inertia`.
- **Result**: PARTIAL (1 line structural advance committed). Body sorry
  retained with extensive recipe comment.
- **Blocker**: No `Scheme.Hom.ofFunctionFieldEmbedding` constructor or
  `IsLocalization.AtPrime` ↔ `presheaf.stalk` affine-chart bridge in
  Mathlib `b80f227`. The function-field-determines-curve correspondence
  (Hartshorne I.6.12) is itself a Mathlib gap.
- **Next step**: iter-195+ contingent on the affine-chart-bridge substrate
  landing (Lane E `pullbackSpecIso` or similar).

## `rationalMap_order_finite_support` non-zero branch (line 227) — UNCHANGED

Hartshorne II.6.1 / Stacks 02RV; documented Mathlib-upstream-pending gap.
The `f = 0` branch closed axiom-clean iter-192. The `f ≠ 0` branch needs
the substrate "for a Noetherian integral scheme, only finitely many
height-1 primes can divide the numerator or denominator of a nonzero
rational function" — Mathlib gap.

## `principal_degree_zero` non-constant branch (line 503) — UNCHANGED

Hartshorne II.6.10 / Stacks 0BE3 non-constant case; depends on the
`φ : C → ℙ¹` construction (Hartshorne I.6.12) + degree-multiplicativity
under finite pullback (Hartshorne II.6.9). Both are Mathlib gaps;
structurally chained through `degree_positivePart_principal_eq_finrank`.

## Lemmas discovered

- `AlgebraicGeometry.LocallyOfFiniteType.isLocallyNoetherian` — the
  source of a `LocallyOfFiniteType` morphism over a `IsLocallyNoetherian`
  base is itself `IsLocallyNoetherian`. (Mathlib
  `Mathlib.AlgebraicGeometry.Noetherian`.)
- `AlgebraicGeometry.IsProper.toLocallyOfFiniteType` — proper morphisms
  are locally of finite type. (Mathlib
  `Mathlib.AlgebraicGeometry.Morphisms.Proper`.)
- `AlgebraicGeometry.instIsLocallyNoetherianSpecOfIsNoetherianRingCarrier`
  — `Spec R` is locally Noetherian when `R` is a Noetherian ring.
- `AlgebraicGeometry.Proj.stalkIso'` — stalk of `Proj 𝒜` at `x` is
  `HomogeneousLocalization.AtPrime 𝒜 x.asHomogeneousIdeal.toIdeal`. (Key
  for any future direct-stalk-DVR computation on ℙ¹.)

## Blueprint markers

`lem:degree_positivePart_principal_eq_finrank` in
`blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` §6 — body sorry
remains; no `\leanok` change owed (managed by `sync_leanok` phase).

The other declarations in the file already carry the appropriate
`\leanok` markers from prior iters.

## Net result

- **5 sorries → 4 sorries**.
- 0 axioms introduced (zero-axiom-build streak preserved).
- HARD BAR: MET (`instIsLocallyNoetherianProjectiveLineBar` axiom-clean).
- Push-beyond avenues structurally documented for iter-195+ pickup.
