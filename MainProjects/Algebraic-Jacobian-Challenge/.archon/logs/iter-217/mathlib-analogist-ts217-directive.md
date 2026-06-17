# Mathlib-analogist directive (iter-217)

## Mode: api-alignment

## Question (decision-critical feasibility check before committing prover budget)

The project must build, project-side and axiom-clean, a **presheaf-level pushforward
adjunction for `PresheafOfModules`**, in order to close the single open substrate
linchpin `tensorObj_restrict_iso` (tensor commutes with restriction along an open
immersion). We call this ingredient **H1**. Before we spend a multi-iter
`mathlib-build` round on it, confirm H1 is genuinely buildable from current Mathlib,
and identify the exact primitives and the cheapest path.

The intended construction (from the iter-216 prover's decomposition):

- Build a presheaf-level adjunction `PresheafOfModules.pushforward β ⊣
  PresheafOfModules.pushforward φ`, mirroring the **sheaf**-level
  `SheafOfModules.pushforwardPushforwardAdj`.
- Conclude `pushforward β ≅ pullback φ` via `Adjunction.leftAdjointUniq` (since
  `pushforward β` is then a left adjoint of `pushforward φ`, and `pullback φ` is the
  abstract left adjoint of `pushforward φ`).
- The build is said to require presheaf-level `pushforwardNatTrans` and
  `pushforwardCongr` (claimed Mathlib-absent), whereas presheaf-level `pushforwardId`
  and `pushforwardComp` are claimed to already exist.

## What I need from you (be concrete, cite on-disk Mathlib paths + decl names)

1. **Does the sheaf-level template exist as claimed?** Locate
   `SheafOfModules.pushforwardPushforwardAdj` (and any `pushforwardNatTrans` /
   `pushforwardCongr` it uses). Give file path + signature. Is it really an
   adjunction `pushforward _ ⊣ pushforward _` from which `leftAdjointUniq` gives the
   pullback comparison?

2. **What presheaf-level pushforward/pullback API actually exists** for
   `PresheafOfModules` at the pinned commit? Confirm or refute each claim:
   - `PresheafOfModules.pushforward` (along a morphism of presheaves of rings) exists?
   - `PresheafOfModules.pullback` exists and is defined as the left adjoint of
     pushforward (so a sectionwise formula is genuinely unavailable)?
   - `pushforwardId`, `pushforwardComp` exist at the presheaf level?
   - `pushforwardNatTrans`, `pushforwardCongr` — genuinely absent at the presheaf
     level, or present under another name?
   - Is there an existing presheaf-level adjunction (e.g.
     `PresheafOfModules.pullbackPushforwardAdjunction` or similar) that already gives
     `pullback φ ⊣ pushforward φ`? If so, the whole H1 build may be a re-derivation —
     flag that loudly (ALIGN_WITH_MATHLIB) and name the decl.

3. **Cheapest path verdict.** Given what exists, what is the minimal set of
   project-side declarations needed to obtain `pushforward β ≅ pullback φ`? Is the
   `leftAdjointUniq` route the right idiom, or does Mathlib already expose the
   comparison? Estimate LOC and name any sub-step that risks bottoming out (i.e. itself
   needs a further Mathlib-absent primitive — the iter-214 `d.1` failure mode).

4. **Sanity on the H2 presheaf lift** (secondary): the project also needs
   `(PresheafOfModules.restrictScalars α).Monoidal` built app-wise from the ModuleCat-
   level `restrictScalarsMonoidalOfRingEquiv` (already closed) via
   `Functor.Monoidal.ofLaxMonoidal`. Confirm `Functor.Monoidal.ofLaxMonoidal` exists
   and that PresheafOfModules isos are reflected by `toPresheaf` (app-wise iso ⇒ iso),
   so this lift is genuinely bounded/no-gap as claimed.

## Output

Per your descriptor: a ranked, cited verdict (PROCEED / ALIGN_WITH_MATHLIB /
NEEDS_MATHLIB_GAP_FILL) with on-disk paths and decl names, written to
`task_results/mathlib-analogist-ts217.md` and a persistent `analogies/<slug>.md`. The
single most valuable output is a yes/no on "is H1 buildable from current Mathlib
without a further absent primitive, and if so via exactly which decls".
