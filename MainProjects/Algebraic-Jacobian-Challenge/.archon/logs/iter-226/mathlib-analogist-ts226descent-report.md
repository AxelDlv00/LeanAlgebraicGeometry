# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ts226descent

## Iteration
226

## Question
(A) Does Mathlib provide morphism gluing/descent for `SheafOfModules` (compatible local homs ⇒
unique glued hom)? (B) A "locally-iso ⇒ iso" criterion for sheaf-of-module morphisms? (C) A
dual/internal-hom-commutes-with-open-immersion-restriction idiom? (D) Does building
`exists_tensorObj_inverse` and `tensorObj_assoc_iso` via A+B+C genuinely AVOID the abandoned
stalk-⊗ commutation "d.2", or does the descent route secretly re-require a stalkwise/
filtered-colimit-⊗ statement?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| A — SheafOfModules morphism descent | NEEDS_MATHLIB_GAP_FILL (small bridge; primitive exists for `Sheaf J A`) | informational |
| B — locally-iso ⇒ iso | ALIGN_WITH_MATHLIB (idiom present; one connector to build) | informational |
| C — dual/internal-hom vs restriction | NEEDS_MATHLIB_GAP_FILL (bespoke, low/med; pieces in hand) | informational |
| D — does the route avoid d.2 | PROCEED — route CONFIRMED, avoids d.2 | informational |

## Answers per question (with citations)

**A. Morphism descent.** Mathlib has the genuine primitive for `Sheaf J A`, not for
`SheafOfModules R`:
- `CategoryTheory.Presheaf.IsSheaf.hom` (`Mathlib/CategoryTheory/Sites/SheafHom.lean:207`):
  the hom presheaf `presheafHom F G` (`:46`) into a sheaf is itself a sheaf ⇒ morphisms are
  determined locally and a compatible family glues. Packaged as
  `CategoryTheory.sheafHom F G : Sheaf J (Type _)` (`:236`) with
  `sheafHomSectionsEquiv : (sheafHom F G).1.sections ≃ (F ⟶ G)` (`:241`).
- Separatedness: `CategoryTheory.eq_of_zeroHypercover_target`
  (`Mathlib/CategoryTheory/MorphismProperty/Local.lean:189`).
- Closest module-level OBJECT descent: `SheafOfModules.QuasicoherentData.bind`
  (`Mathlib/Algebra/Category/ModuleCat/Sheaf/Quasicoherent.lean:358`) — glues quasicoherent
  *data* across `J.CoversTop`. Confirms the machinery exists for module sheaves, but only for
  the QC-presentation structure, not arbitrary objects from a cocycle.
- **Gap**: no `SheafOfModules R`-level "hom is a sheaf" wrapper. Bridge: glue the underlying
  ab-morphism via `SheafOfModules.toSheaf R` (`.../ModuleCat/Sheaf.lean:89`, faithful+additive)
  + `sheafHom`, then promote to `𝒪_X`-linear with `PresheafOfModules.homMk` (R-linearity is a
  sectionwise equation, survives gluing). ~30–60 LOC.

**B. Locally-iso ⇒ iso.** Present and idiomatic:
- `CategoryTheory.Sheaf.isLocallyBijective_iff_isIso`
  (`Mathlib/CategoryTheory/Sites/LocallyBijective.lean:84`): for `f : F ⟶ G` of `Sheaf J A`,
  `IsLocallyInjective f ∧ IsLocallySurjective f ↔ IsIso f`.
- SheafOfModules wiring already there: `IsLocallyInjective`/`IsLocallySurjective` defined
  (`.../ModuleCat/Sheaf.lean:190,195`); `SheafOfModules.toSheaf` reflects isos (live use:
  `isIso_iff_of_reflects_iso _ (SheafOfModules.toSheaf R)`,
  `.../ModuleCat/Sheaf/Localization.lean:44`); `(forget R).ReflectsIsomorphisms` (`Sheaf.lean:80`).
- **Connector to build**: turn the project's "`M.restrict f` iso on an open cover" (restriction
  along an open *immersion*, base ring → `𝒪_U`) into site-level locally-bijective on
  `Opens.grothendieckTopology X`. Tractable.

**C. Dual/internal-hom vs restriction.** No direct lemma (Mathlib has no module-sheaf internal
hom/dual). But the enabler is present — it is the H2 half of the closed `tensorObj_restrict_iso`:
- `ModuleCat.restrictScalarsEquivalenceOfRingEquiv`
  (`Mathlib/Algebra/Category/ModuleCat/ChangeOfRings.lean:285`) — restrictScalars along a ring
  iso is an equivalence (`:303`), additive (`:325`), linear (`:335`). Open-immersion restriction
  is a sectionwise ring iso (`f.appIso`), so commutes with `Hom(-,-)`/dual up to iso.
- Build `(dual M)|_U ≅ dual_{𝒪_U}(M|_U)` by the `tensorObj_restrict_iso` recipe
  (`pushforwardPushforwardAdj`/`pullbackPushforwardAdjunction` + this equivalence carrying Hom).

**D. Does the route avoid d.2? YES — confirmed.**
- `tensorObj_restrict_iso` (`TensorObjSubstrate.lean:1822`) is CLOSED and d.2-FREE: it uses the
  pushforward/pullback adjunction + `restrictScalars` strong-monoidality, never a stalk or a
  filtered-colimit-⊗.
- The local isos feeding the associator/inverse come from `tensorObj_restrict_iso` +
  `tensorObj_unit_iso` + `tensorObjIsoOfIso` on trivialising opens — the exact pattern of the
  already-CLOSED `tensorObj_isLocallyTrivial` (`:1912`). No stalk.
- A (gluing) and B (locally-iso⇒iso) are morphism statements about (ab-)sheaves; neither
  computes a tensor stalk, so the d.2 statement `(F⊗ᵖM)_x ≅ F_x⊗_{R_x}M_x` is never invoked.
- Why the current `tensorObj_assoc_iso` needs d.2: route (d) manipulates the *iterated
  sheafification* `sheafify(η ▷ P)` directly, forcing the whiskered-unit-in-`W` step
  (`isLocallyInjective_whiskerLeft_of_W`) = d.2. The descent route never forms that morphism.
  NOTE this also rules out the "canonical-presheaf-construction" shortcut (associator =
  `sheafify(presheaf associator)`, eval = `sheafify(internalHomEval)`): it re-hits the same
  `M ◁ η`/`η ▷ P` whiskering = d.2. **Only the gluing route escapes.**
- **Residual risk (NOT d.2)**: local isos must agree on overlaps (cocycle) to glue — standard
  line-bundle cocycle bookkeeping (`O⊗O⊗O ≅ O` / `O⊗O ≅ O` intertwining transition units).
  Bounded work, different in kind from the abandoned ~300–500 LOC stalk-⊗ build.

## Informational

- `Linv := dual L` is now nameable (dual landed iter-225), so `exists_tensorObj_inverse` is no
  longer blocked "at step 1". Its remaining needs map onto A (build/glue the eval), B (eval is a
  local iso ⇒ global iso), C (`dual L` locally trivial). The iter-218 "object descent missing"
  blocker is superseded — the descent the route actually needs is MORPHISM descent (A), for
  which Mathlib supplies the primitive (`Sites.SheafHom`).
- Recommended build order: B-connector → A-bridge → C → assemble both group-law facts and
  delete the vestigial whiskering/d.2 apparatus. Detail in the persistent file.

## Persistent file
- `analogies/ts226descent.md` — full decision blocks, citations, and recommended build order.

Overall verdict: the descent re-route is sound and genuinely retires the abandoned d.2 stalk-⊗
gap — every required bridge (A morphism-amalgamation, B locally-iso⇒iso, C dual-vs-restriction)
rests on an existing Mathlib primitive and none re-enters stalk-⊗; the only non-Mathlib content
is a bounded overlap-cocycle check.
