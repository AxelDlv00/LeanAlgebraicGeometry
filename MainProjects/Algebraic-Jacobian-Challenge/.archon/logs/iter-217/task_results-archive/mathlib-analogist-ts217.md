# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ts217

## Iteration
217

## Question
Confirm H1 — a presheaf-level `PresheafOfModules.pushforward β ⊣ pushforward φ`, from which
`Adjunction.leftAdjointUniq` yields `pushforward β ≅ pullback φ` (the linchpin of
`tensorObj_restrict_iso`) — is genuinely buildable from current Mathlib without a further absent
primitive, and identify the exact decls and cheapest path. (Full directive in
`logs/iter-217/mathlib-analogist-ts217-directive.md`.)

## Headline answer
**YES — H1 is buildable from current Mathlib, without bottoming out.** It needs exactly three new
presheaf-side decls, each a mechanical de-sheafification of an existing sheaf-level decl that already
manipulates presheaf (`.val`) data, plus one `leftAdjointUniq` call against an **already-existing**
adjunction. ~70-90 LOC, one bounded `mathlib-build` round.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Sheaf-level template `pushforwardPushforwardAdj` exists & is a real `pushforward ⊣ pushforward` | PROCEED | informational |
| 2a. Re-deriving `pullback ⊣ pushforward` (already in Mathlib as `pullbackPushforwardAdjunction`) | ALIGN_WITH_MATHLIB | high |
| 2b. Presheaf `pushforwardNatTrans` / `pushforwardCongr` genuinely absent | NEEDS_MATHLIB_GAP_FILL | informational |
| 3. `leftAdjointUniq` route + 3 new decls; no sub-step bottoms out | PROCEED | informational |
| 4. H2 monoidal lift (`ofLaxMonoidal` + `isoMk`) bounded/no-gap | PROCEED | informational |

## Major

- **Do NOT re-derive the `pullback ⊣ pushforward` adjunction.** It exists as
  `PresheafOfModules.pullbackPushforwardAdjunction` (`Presheaf/Pullback.lean:50`), and
  `(pushforward φ).IsRightAdjoint` is a proven instance (`:97-98`), so `pullback φ` genuinely exists.
  H1 consumes this as `adj2` in `Adjunction.leftAdjointUniq` (`Adjunction/Unique.lean:36`,
  `(adj1 : F ⊣ G) (adj2 : F' ⊣ G) : F ≅ F'`). The project already uses
  `pullbackPushforwardAdjunction` elsewhere (`QuotScheme.lean:416`, `Differentials.lean:52`), and the
  in-file comment at `TensorObjSubstrate.lean:1124` already cites `Pullback.lean:44` — so this is a
  "stay aligned" flag, not a shipped-divergence fix.

## Informational

**Decision 1 — sheaf template is real.** `SheafOfModules.pushforwardPushforwardAdj`
(`Sheaf/PushforwardContinuous.lean:226`) is a genuine `pushforward φ ⊣ pushforward ψ` built from
`adj : F ⊣ G` + compat hyps `H₁`/`H₂` (`:219-221`), assembled from sheaf-level `pushforwardId`
(`:67`), `pushforwardComp` (`:101`), `pushforwardCongr` (`:73`), `pushforwardNatTrans` (`:154`). Its
triangle identities (`:235-247`) are pure sectionwise rewrites on `.val.presheaf.map` — no
sheaf-specific content, so the whole proof de-sheafifies. The concrete open-immersion consumer
`Scheme.Modules.restrictAdjunction` (`AlgebraicGeometry/Modules/Sheaf.lean:340`) calls it directly
with `f.isOpenEmbedding.isOpenMap.adjunction` and discharges `H₁`/`H₂` in 6 lines (`:346-353`) via
`f.appIso`; **those exact lines are the presheaf `H₁`/`H₂` proofs.**

**Decision 2 — presheaf API inventory (verified by grep + hover on the pinned tree):**
- `PresheafOfModules.pushforward` — EXISTS, `Presheaf/Pushforward.lean:86`.
- `PresheafOfModules.pullback` — EXISTS, `Presheaf/Pullback.lean:44`, `= (pushforward φ).leftAdjoint`
  (opaque abstract left adjoint, no sectionwise formula — confirms iter-208 correction).
- `pushforwardId`, `pushforwardComp` — EXIST, `Presheaf/Pushforward.lean:125, 135`.
- `pushforwardNatTrans`, `pushforwardCongr` — ABSENT at presheaf level (only `Sheaf/…:154, 73`).
- `pullbackPushforwardAdjunction` — EXISTS (see Major).

**Decision 3 — cheapest path (the minimal decl set).** No sub-step is itself a Mathlib-absent
primitive (contrast iter-214 `d.1`, which needed new R_x-linear stalk infra):
1. `PresheafOfModules.pushforwardNatTrans` — mirror `Sheaf/…:154-167` minus `.val` (~15-25 LOC).
2. `PresheafOfModules.pushforwardCongr` — mirror `Sheaf/…:73-77` via `PresheafOfModules.isoMk`
   (`Presheaf.lean:118`) + `ModuleCat.restrictScalarsCongr` (`ModuleCat/ChangeOfRings.lean:158`,
   EXISTS) (~6-10 LOC).
3. `PresheafOfModules.pushforwardPushforwardAdj` — mirror `Sheaf/…:226-247` using presheaf
   `pushforwardId`/`pushforwardComp` + (1),(2); underlying `adj` = `IsOpenMap.adjunction`
   (`TopCat/Opens.lean:307`, EXISTS); `H₁`/`H₂` = `Modules/Sheaf.lean:346-353` ported (~40 LOC).
4. `pushforward β ≅ pullback φ := Adjunction.leftAdjointUniq (3) (pullbackPushforwardAdjunction φ.hom)`
   (~2 LOC).

**Decision 4 — H2 lift confirmed bounded.** `Functor.Monoidal.ofLaxMonoidal`
(`Monoidal/Functor.lean:696`) exists; app-wise iso ⇒ presheaf iso via `PresheafOfModules.isoMk`
(`Presheaf.lean:118`); `toPresheaf` reflects isos (`Sheafification.lean:41-43`). With the closed
ModuleCat-level `restrictScalarsMonoidalOfRingEquiv`, the presheaf lift is genuinely no-gap, as the
project's iter-216 note claims.

## Persistent file
- `analogies/ts217.md` — full decision blocks, decl citations, and the recommendation captured for
  future iters.

Overall verdict: **PROCEED — H1 is buildable now**; commit the `mathlib-build` budget. Build the
three presheaf decls by de-sheafifying `Sheaf/PushforwardContinuous.lean`, then close with
`leftAdjointUniq` against the existing `pullbackPushforwardAdjunction` (do not re-derive it).
