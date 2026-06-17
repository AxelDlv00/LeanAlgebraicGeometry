# Mathlib Analogist Report

## Mode
api-alignment

## Slug
fbc-qc

## Iteration
240

## Question
Does Mathlib already have a direct, idiomatic statement that the pushforward of a
quasi-coherent sheaf along an AFFINE morphism is quasi-coherent (equivalently
`(Spec φ)_* (M^~) ≅ (restrictScalars φ M)^~`), letting `FlatBaseChange.lean` conclude the
localization/quasi-coherence of the pushforward WITHOUT the manual per-`D(a)`
`IsLocalizedModule` (`hloc`) transport that keeps hitting the `Module.compHom` carrier wall?

## Answer (short)
**YES — the exact idiom exists**, but in a Mathlib NEWER than the project's pin. The
project should pivot the lane. Even bump-free, the carrier wall is fixable: the upstream
mechanism is `algebraize [φ.hom]` (honest `Algebra`/`IsScalarTower` instances), **not**
`Module.compHom` — and `algebraize [φ.hom]` is verified to run at the project's own sorry.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Route: manual `hloc` transport vs `isIso_fromTildeΓ_pushforward` | ALIGN_WITH_MATHLIB | critical |
| Scalar mechanism: `Module.compHom` letI vs `algebraize [φ.hom]` | ALIGN_WITH_MATHLIB | critical |

## Key finding (cited, LSP-verified)

`Mathlib.AlgebraicGeometry.Modules.Tilde` (upstream master) contains the precise dictionary:

- `AlgebraicGeometry.isIso_fromTildeΓ_pushforward (M : (Spec S).Modules) [IsIso M.fromTildeΓ] : IsIso ((pushforward (Spec.map φ)).obj M).fromTildeΓ`
  — "affine pushforward of a quasi-coherent sheaf is quasi-coherent". Added **2026-05-31, PR #37189**.
- `isLocalizing_pushforward_of_isLocalizing` (its engine), `isIso_fromTildeΓ_iff_isLocalizing`,
  and the `IsLocalizing` predicate `∀ f : R, IsLocalizedModule (.powers f) (M.obj.map (basicOpen f).leTop.op).hom`
  — which is *literally* the project's `hloc` hypothesis.

The upstream engine proof is three lines, and its carrier-handling step is:
```
algebraize [φ.hom]
exact fun f => IsLocalizedModule.restrictScalars_powers f _ (h := h (φ f))
```
`IsLocalizedModule.restrictScalars_powers` is the SAME lemma the project already built as
`IsLocalizedModule.powers_restrictScalars` (`FlatBaseChange.lean:452`), stated against
`[Algebra R A] [IsScalarTower R A M]` — exactly the instances `algebraize` provides.

### What is / isn't in the project's pin (`b80f227`, between 2026-03-04 and 2026-05-31)
Verified via `lean_multi_attempt` in `FlatBaseChange.lean`:
- PRESENT: `isIso_fromTildeΓ_iff` (✓ type-checked), `isIso_fromTildeΓ_of_presentation` (✓, #36124),
  `tilde.functor`/`tilde.adjunction`/`modulesSpecToSheaf`/`fromTildeΓ`, and the `algebraize`
  tactic (✓ runs at the sorry, installs `Algebra ↑R ↑R' := φ.hom.toAlgebra`).
- ABSENT (all from #37189): `IsLocalizing`, `isIso_fromTildeΓ_iff_isLocalizing`,
  `isLocalizing_pushforward_of_isLocalizing`, `isIso_fromTildeΓ_pushforward`,
  `pushforwardCompModulesSpecToSheafIso` — confirmed "Unknown identifier/constant".

So the loooge/leanfinder hit is real, but the project cannot `exact` it today.

## Must-fix-this-iter

- **Decision 2 (carrier wall) — `FlatBaseChange.lean:564-572`**: replace the
  `Module.compHom _ φ.hom` `letI` mechanism with **`algebraize [φ.hom]`**. This installs the
  `Algebra ↑R ↑R'` (+ scalar-tower) instances that `IsLocalizedModule.powers_restrictScalars`
  (the project's own lemma) requires, which `Module.compHom` does not. VERIFIED: `algebraize [φ.hom]`
  runs cleanly at the sorry (line 572). This is the documented 4-iter wall and the directive's
  exact hint — the answer is `algebraize`/`Algebra`/`IsScalarTower`, not `Module.compHom`.

- **Decision 1 (route) — `FlatBaseChange.lean:535` (`pushforward_spec_tilde_iso`)**: stop proving
  the pushforward `hloc` from scratch; align to `isIso_fromTildeΓ_pushforward`. Preferred:
  **bump Mathlib** past 2026-05-31 (#37189), after which the whole def is ~3 lines:
  ```
  haveI : IsIso (tilde M).fromTildeΓ := isIso_fromTildeΓ_iff.mpr ((tilde.functor R').obj_mem_essImage M)
  haveI := isIso_fromTildeΓ_pushforward (φ := φ) (tilde M)
  exact (asIso (Scheme.Modules.fromTildeΓ _)).symm ≪≫ (tilde.functor R).mapIso (gammaPushforwardTildeIso φ M)
  ```
  (line 1 already type-checks in the pin; lines 2–3 need the bump). If the bump is infeasible,
  port the short `IsLocalizing` chain — the project already owns `powers_restrictScalars` and the
  per-open `gammaPushforwardIsoAt`; the only genuinely new work is (a) `algebraize` (above) and
  (b) upgrading `gammaPushforwardIsoAt` to **natural-in-the-open** (= upstream
  `pushforwardCompModulesSpecToSheafIso`) so it can drive `isLocalizing_iff_of_iso`. That naturality
  is the "gammaPushforwardIsoAt-naturality-in-open" NEXT already noted in memory.

## Informational

- The project's `pushforward_spec_tilde_iso_of_isLocalizedModule` +
  `fromTildeΓ_app_isIso_of_isLocalizedModule` are a correct, axiom-clean re-derivation of
  upstream's `IsLocalizing → IsIso fromTildeΓ` (`isIso_fromTildeΓ_iff_isLocalizing` mpr) and
  remain useful in the bump-free port. They are NOT wasted by a bump either — they just become
  redundant with `isIso_fromTildeΓ_iff_isLocalizing`.
- Mathlib's quasi-coherence on `Spec R` is `IsIso M.fromTildeΓ` (counit-iso = `essImage tilde`),
  NOT the abstract over-category `SheafOfModules.IsQuasicoherent`; the project is already aligned
  to the `fromTildeΓ` formulation, which is the one with usable API.

## Persistent file
- `analogies/fbc-qc.md` — design-rationale captured for future iters.

Overall verdict: ALIGN_WITH_MATHLIB — the exact dictionary (`isIso_fromTildeΓ_pushforward`,
#37189, 2026-05-31) exists upstream but post-dates the pin; pivot via a Mathlib bump (preferred)
or a short port, and immediately replace the dead `Module.compHom` mechanism with `algebraize [φ.hom]`.
