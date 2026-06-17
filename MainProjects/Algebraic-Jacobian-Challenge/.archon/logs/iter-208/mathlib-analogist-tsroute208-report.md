# Mathlib Analogist Report

## Mode
api-alignment

## Slug
tsroute208

## Iteration
208

## Question
The mate-δ route for `tensorObj_restrict_iso` is definitively blocked (needs the
absent `(PresheafOfModules.pullback φ).Monoidal`). Which re-route is the
bounded, Mathlib-idiomatic one — (A) open-immersion sectionwise /
base-change-along-a-ring-iso, or (B) add `IsLocallyTrivial` and glue local isos
— and do the prerequisites exist at `b80f227` or are they an absent multi-file
build? Give exact decl names (present/absent) and a blunt closability verdict.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Route (A) open-immersion sectionwise | PROCEED (after one bounded helper) | recommended route |
| Route (B) line-bundle glue | DIVERGE (do NOT take) | informational |
| δ-route `(pullback φ).Monoidal` | NEEDS_MATHLIB_GAP_FILL (multi-file) | confirmed abandon |

## Answer 1 — which route is bounded

**Route (A) is the bounded, idiomatic route.** The pivotal fact: along an open
immersion, `Scheme.Modules.restrict` is the *concrete, definitionally
sectionwise* `restrictFunctor` (`restrict_obj`/`restrict_map` are `rfl`), and the
ring comparison is the structure-sheaf **isomorphism** `f.appIso`. So "extension
of scalars" is base change along a ring **iso** — trivially an iso via the
already-present `restrictScalarsEquivalenceOfRingEquiv`. No `extendScalars`
monoidality is ever needed. The lemma is moreover **true for arbitrary `M, N`**
(tensor commutes with open restriction; no local-freeness), which is why the
δ-route over-paid.

**Route (B) is worse and should be dropped.** Its `IsLocallyTrivial` hypotheses
are mathematically unnecessary for *this* lemma (over-constrains the signature),
and Mathlib has **no `SheafOfModules` iso-gluing primitive** — "glue local isos"
is a cocycle chore strictly heavier than (A)'s global-morphism-checked-locally.

## Answer 2 — exact decl names, tagged present/absent at `b80f227`

PRESENT (load-bearing for Route A):
- `AlgebraicGeometry.Scheme.Modules.restrict_obj` / `restrict_map`
  — `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:328,331` (both `rfl`;
  `Γ(M.restrict f, U) = Γ(M, f ''ᵁ U)` — "pullback-along-open-immersion is
  sectionwise restriction").
- `AlgebraicGeometry.Scheme.Hom.appIso` — `Mathlib/AlgebraicGeometry/OpenImmersion.lean:190`
  (`Γ(Y, f ''ᵁ U) ≅ Γ(X, U)`, a `CommRingCat` iso; the ring iso `restrictFunctor`
  reindexes along, Sheaf.lean:320).
- `ModuleCat.restrictScalarsEquivalenceOfRingEquiv`
  — `Mathlib/Algebra/Category/ModuleCat/ChangeOfRings.lean:285` ("base change
  along a ring iso is an equivalence" — the directive's requested lemma).
- `AlgebraicGeometry.Scheme.Modules.Hom.isIso_iff_isIso_app`
  — `Sheaf.lean:132` (`IsIso φ ↔ ∀ U, IsIso (φ.app U)` — the requested
  "iso on sections ⇒ iso" criterion); plus `instance [IsIso φ] : IsIso (φ.app U)`
  (Sheaf.lean:137).
- `TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso` — `Mathlib/Topology/Sheaves/Stalks.lean:652`
  (+`app_isIso_of_stalkFunctor_map_iso`:618, `stalkFunctor_map_unit_toSheafify_isIso`
  Sheafify.lean:137) — stalkwise iso-check fallback.
- `AlgebraicGeometry.Scheme.Modules.restrictStalkNatIso` — `Sheaf.lean:425`
  (restriction commutes with stalks).
- `AlgebraicGeometry.Scheme.Modules.restrictFunctorIsoPullback` — `Sheaf.lean:371`.
- `SheafOfModules.sheafificationCompPullback` / `pullbackIso`
  — `Mathlib/Algebra/Category/ModuleCat/Sheaf/PullbackContinuous.lean:117,105`.
- `PresheafOfModules.isoMk` — `Mathlib/Algebra/Category/ModuleCat/Presheaf.lean:118`
  (sectionwise → presheaf iso assembly).

ABSENT (the single bounded gap, + the dead-route walls):
- **Sectionwise unfolding of `PresheafOfModules.pullback φ`** — `pullback` is
  `(pushforward φ).leftAdjoint` (`Presheaf/Pullback.lean:44`), opaque on
  `.obj`/`.map`. No presheaf-level "pullback along open immersion ≅ sectionwise
  restriction" (no presheaf analogue of `restrictFunctorIsoPullback`). **This is
  the one project-side gap for Route A — but bounded (~30–60 LOC).** Precedent:
  `analogies/kaehler-tensorequiv-presheafpullback.md` Decision 5 hit the
  identical opacity, estimated ~30–60 LOC for the unfolding helper, and the lane
  succeeded in building a `pullback`-based base-change iso.
- `(PresheafOfModules.pullback φ).Monoidal` / any monoidal structure on
  `SheafOfModules` — the δ-route wall (multi-file `extendScalars`-monoidality
  lift). ABSENT.
- Stalk-of-presheaf-tensor = tensor-of-stalks as a packaged ModuleCat-sheaf
  lemma — ABSENT (only needed if the stalkwise iso-check fallback is used).

## Answer 3 — blunt closability verdict

**YES — closable by a `prove`-mode round on Route (A); do NOT pause TS.** It
does *not* also bottom out in absent multi-file monoidal infra. The one
prerequisite is bounded and single-file: a sectionwise identification of
`PresheafOfModules.pullback φ.hom` along the open-immersion ring map (the
`appIso` reindex). Sequence it as two prover objectives: (1) the ~30–60 LOC
presheaf-pullback-along-open-immersion unfolding helper, then (2) the main body
— keep the existing `restrictFunctorIsoPullback` + `sheafificationCompPullback`
steps, discharge the presheaf residual with `PresheafOfModules.isoMk` +
`restrictScalarsEquivalenceOfRingEquiv` (sections agree by `restrict_obj` `rfl`,
scalar rings identified by `appIso`), iso-checked via `Hom.isIso_iff_isIso_app`
if a morphism-then-iso shape is used. The blueprint rewrite should drop the δ /
`extendScalars`-monoidality framing and the `IsLocallyTrivial` hypotheses for
this lemma (true for arbitrary `M, N`); the iter-207 `restrictScalarsLaxMonoidal`
instance (file lines 105-178) is dead weight unless another consumer uses it.

## Persistent file
- `analogies/tsroute208.md` — full route comparison + decl inventory captured
  for future iters.

Overall verdict: re-route to (A) — bounded, single-file gap (presheaf-pullback
sectionwise unfolding, ~30–60 LOC), then a `prove`-mode round closes it; (B) is
heavier and over-constrains, and the δ-route stays correctly abandoned.
