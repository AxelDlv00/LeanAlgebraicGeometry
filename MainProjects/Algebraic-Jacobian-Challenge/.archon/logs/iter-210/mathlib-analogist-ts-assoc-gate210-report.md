# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ts-assoc-gate210

## Iteration
210

## Question
Scope the `⊗_X` associator `(M⊗N)⊗P ≅ M⊗(N⊗P)` to INVERTIBLE objects (all the
relative-Picard group law consumes). (1) Is it buildable from PRESENT Mathlib
WITHOUT `MonoidalClosed (PresheafOfModules R₀)`? (2) Which realization —
(1) local-trivialization gluing, (2) flat-exactness whiskerLeft, (3) `J.W.IsMonoidal`
on the flat subcategory? (3) Does realization (1) genuinely avoid the absorption-iso
wall, or does the gluing secretly re-invoke it?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Realization (2) flat-exactness whiskerLeft (recommended) | ALIGN_WITH_MATHLIB | major (in-proposal) |
| Realization (1) local-trivialization gluing | reject — NEEDS_MATHLIB_GAP_FILL | critical (renamed wall) |
| Realization (3) `J.W.IsMonoidal` on flat subcat | reject — divergent-with-cost | critical (the wall, packaged) |
| Re-scope `lem:tensorobj_assoc_iso` arbitrary → invertible | ALIGN_WITH_MATHLIB | major (in-proposal) |

**Direct answers.** Q1: **YES** — buildable without `MonoidalClosed`, via realization (2).
Q2: **realization (2)**. Q3: **NO, realization (1) does NOT avoid the wall** — it reduces to
the sorry'd `tensorObj_restrict_iso`, whose residual is flatness-independent and absent from
Mathlib.

## Major

Adopt for the re-scoped blueprint + prover round (nothing shipped yet — these are proposal-stage):

- **Re-scope `lem:tensorobj_assoc_iso` (blueprint L531–578) to invertible `M,N,P`.** Drop the
  current "arbitrary `M,N,P`, no flatness required" clause — that clause is exactly what forces
  the arbitrary-`F` whiskering-stability = `MonoidalClosed` wall flagged in its own `% NOTE`
  (L549–562). The consumers (`lem:tensorobj_isoclass_commgroup` L859,
  `thm:rel_pic_addcommgroup_via_tensorobj` L953) only ever associate invertible objects. Mirror
  Mathlib's `Module.Invertible` object-predicate scoping (`Mathlib.RingTheory.PicardGroup`).

- **Formalize the associator via realization (2), the flat-exactness whiskerLeft.** Build it as a
  3-step composite (η = `toSheafify` sheafification unit, `a = PresheafOfModules.sheafification`,
  `α` = presheaf associator):
  `(M⊗N)⊗P = a(a(M.val⊗ᵖN.val).val ⊗ᵖ P.val)`
  `≅[a(η◁P), P flat] a((M.val⊗ᵖN.val)⊗ᵖP.val)`
  `≅[a.mapIso α] a(M.val⊗ᵖ(N.val⊗ᵖP.val))`
  `≅[a(M▷η), M flat] a(M.val ⊗ᵖ a(N.val⊗ᵖP.val).val) = M⊗(N⊗P)`.
  The only non-`mapIso` content is the **bridge lemma** `J.W g → J.W (P ◁ g)` for FLAT `P`.
  All ingredients are PRESENT Mathlib (verified this iter):
  - `Module.Invertible.instProjective`, `Module.Invertible.instFinite`
    (`Mathlib.RingTheory.PicardGroup`) + `Module.Flat.of_projective`
    (`Mathlib.RingTheory.Flat.Basic`) → invertible ⇒ flat, the flatness hypothesis is FREE.
  - `Module.Flat.lTensor_preserves_injective_linearMap` (`Mathlib.RingTheory.Flat.Basic`) →
    flat preserves the sectionwise injectivity, giving local injectivity of `P ◁ g`.
  - `J.WEqualsLocallyBijective` / `Presheaf.IsLocallyInjective` / `IsLocallySurjective` /
    `GrothendieckTopology.instIsLocallyInjectiveToSheafify` (`Mathlib.CategoryTheory.Sites.*`,
    `Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification`) → the W-as-locally-bijective
    API to express the bridge; `η = toSheafify` is in `J.W` by `instIsLocallyInjectiveToSheafify`.
  Local surjectivity of `P ◁ g` is right-exactness of `⊗` (always holds). Estimated prover
  cost for the flat-whiskering bridge: ~30–80 LOC, NOT a multi-file build.

## Informational

- **Realization (1) is a renamed wall (the directive's Q3, answered NO).** Gluing local
  structure-sheaf associators requires identifying `((M⊗N)⊗P).restrict W` with the affine triple
  tensor — i.e. `tensorObj_restrict_iso` (`TensorObjSubstrate.lean:330`), which is a **typed
  `sorry`**. Its residual (file L357–398) is H1 (a presheaf-level `pushforward β ≅ pullback φ`
  adjunction; only the sheaf version `SheafOfModules.pushforwardPushforwardAdj` exists) + H2
  (`restrictScalars` along the ring iso `f.appIso` is strong monoidal; Mathlib has only LAX,
  `extendScalars` is the strong one). Both are absent from Mathlib AND **flatness-independent**
  (H2 concerns the open-immersion ring iso, not `M,N,P`), so scoping `M,N,P` to invertible does
  not lighten it. Crucially, the directive's cited "ALREADY PROVEN" precedent
  `lem:tensorobj_preserves_locally_trivial` / `tensorObj_isLocallyTrivial` is **not** actually
  proven: `lean_verify` reports `sorryAx` in its axiom set (its proof at L423 calls the sorry'd
  `tensorObj_restrict_iso`). It proves only EXISTENCE of local trivialisations and still inherits
  the hole — gluing two SPECIFIC objects into a global iso is strictly more and inherits the same.

- **Realization (3) is the wall, packaged.** `lean_leansearch` confirms
  `CategoryTheory.GrothendieckTopology.W.whiskerLeft` (`Mathlib.CategoryTheory.Sites.Monoidal`)
  carries `[inst_3 : CategoryTheory.MonoidalClosed A]` in its signature. Instantiating Mathlib's
  bundled `MorphismProperty.IsMonoidal J.W` (the gate of `CategoryTheory.Sheaf.monoidalCategory`)
  fills its `whiskerLeft` field from exactly this `MonoidalClosed`-gated lemma — for ALL objects,
  not just flat ones. So (3) cannot be scoped to flat without abandoning the bundled instance,
  at which point it collapses into realization (2) anyway. Reject.

- **Reversal signal: NOT triggered globally — lane stays alive.** Realization (2) is a genuine
  present-Mathlib escape, so this is NOT the iter-209 reversal trigger (do not pause the lane /
  pivot to Quot on these grounds). BUT the directive's *favored* realization (1) IS a renamed
  wall: the engine-fix blueprint-writer must point the associator at the flat-whiskering `J.W`
  bridge (realization 2), NOT at structure-sheaf gluing. If the prover round finds the
  flat-whiskering bridge ALSO bottoms out in a `MonoidalClosed`/strong-monoidal-pushforward
  obligation (it should not — the lTensor/locally-bijective ingredients above are all present),
  THAT would be the reversal trigger.

## Persistent file
- `analogies/ts-assoc-gate210.md` — design-rationale captured for future iters.

Overall verdict: re-scope the associator to invertible objects and build it via the
flat-exactness whiskerLeft (realization 2) — buildable from present Mathlib without
`MonoidalClosed`; realizations (1) and (3) both bottom out in absent Mathlib and must be rejected.
