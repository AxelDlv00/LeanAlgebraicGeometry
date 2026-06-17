# Mathlib Analogist Report

## Mode
api-alignment

## Slug
quot-transport

## Iteration
030

## Question
To finish gap1 (`IsIso M.fromTildeΓ` for `M : (Spec R).Modules`, `[M.IsQuasicoherent]`), transport
each slice presentation `q.presentation i : (M.over (q.X i)).Presentation` (for `D(r) ≤ q.X i`) to
`IsIso ((M|_{D(r)}).fromTildeΓ)` on `Spec R_r`. (1) Does Mathlib already provide gap1 or a
substantial fraction — a restriction/pullback functor on `(Spec R).Modules`, a presentation
pullback/restriction lemma? (2) Is the `q.X i` sieve-`over` route canonical, or is there a cleaner
slice-free path? (3) Is there a Mathlib idiom for restriction/pullback of `SheafOfModules` along a
scheme morphism, and `Presentation.pullback`/`.map`? (4) PROCEED or ALIGN-WITH-MATHLIB?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| A. Restriction-to-open functor on `(Spec R).Modules` exists (obstacle #1 claim) | PROCEED (claim is wrong) | informational |
| B. `over`-slice / `q.presentation i` route for the transport sub-step | PROCEED (canonical; timeout tameable) | informational |
| C. `over U ↔ Spec R_r` bridge (`overRestrictIso`) | NEEDS_MATHLIB_GAP_FILL | major |
| D. Section-localization descent (the real keystone) | NEEDS_MATHLIB_GAP_FILL | major |

## Direct answers to the four questions

**Q1 — does Mathlib provide gap1 / a fraction of it?**
- gap1 itself: **NO**. `isIso_fromTildeΓ_iff : IsIso M.fromTildeΓ ↔ (tilde.functor R).essImage M`
  (`Modules/Tilde.lean:340`); only `isIso_fromTildeΓ_of_presentation` (needs a **global**
  `M.Presentation`, `:398`) and the easy `presentationTilde`/`(tilde M).IsQuasicoherent` (`:373,394`).
  Source comment `Tilde.lean:310` states QCoh = essImage is deferred. Confirms `quot-qcoh-affine-globalization.md`.
- Restriction/pullback functor: **YES** (this is the substantial fraction). `Scheme.Modules.pullback`
  (`Modules/Sheaf.lean:167`) and a full open-immersion `Restriction` section: `restrictFunctor`
  (`:319`), `restrict`/`restrict_obj` (`:325,328`), `restrictFunctorIsoPullback` (`:371`),
  `restrictFunctorComp` (`:392`), `restrictStalkNatIso` (`:424`). The project already uses
  `Scheme.Modules.pullback (U i).ι` in `IsLocallyFreeOfRank` (`QuotScheme.lean:255`).
- Presentation transport: **YES** — `SheafOfModules.Presentation.map (F) (η : F.obj (unit R) ≅ unit S)`
  for colimit-preserving `F` (`Quasicoherent.lean:179`), plus `Presentation.ofIsIso` (`:132`).
  `pullback`/`restrictFunctor` are left adjoints sending `unit ↦ unit`, so `.map` applies.

**Q2 — is the sieve-`over` route canonical, or is there a slice-free path?**
- There is **no slice-free path** (Q2(i): NO). `IsQuasicoherent` is *defined* only via
  `QuasicoherentData` (`Quasicoherent.lean:201,249`), whose presentations live on the abstract slice
  `M.over (X i) = (pushforward (𝟙_)).obj M` (`PushforwardContinuous.lean:53`). Pulling a local
  presentation out of `[M.IsQuasicoherent]` **must** touch the slice.
- The slice route **is** the canonical idiom for that sub-step: `QuasicoherentData.bind`
  (`Quasicoherent.lean:360`) is the worked template — `Presentation.map e.inverse` with
  `e := pushforwardPushforwardEquivalence (Over.iteratedSliceEquiv g)`
  (`PushforwardContinuous.lean:305`, `Sites/Over.lean:469–489`).
- The **timeout is not structural**: `bind` defeats the same `(sheafToPresheaf (J.over …)).IsRightAdjoint`
  / `HasSheafify` synthesis blow-up with `set_option backward.isDefEq.respectTransparency false`
  (+ an `#adaptation_note`). The prover hit it because that option was not in force.
- Q2(ii): the project's engine **already** reduces `IsIso M.fromTildeΓ` to per-basic-open
  `IsLocalizedModule` (`isIso_fromTildeΓ_iff_isLocalizedModule_restrict`, `QuotScheme.lean:653`).
  That reduction is done; the residue is producing the per-basic-open localization, which is the
  descent (Decision D), not more naturality bookkeeping.

**Q3 — restriction/pullback of `SheafOfModules` along a scheme morphism + `Presentation.map`?**
- **YES** to all: `Scheme.Modules.pullback`/`restrictFunctor` (Q1), `SheafOfModules.pullback`
  (`Sheaf.lean:167–168` wraps it), and `Presentation.map` (Q1). Build on these, not a hand-rolled
  `over`-slice transport.

**Q4 — verdict: PROCEED, with a corrected decomposition.** The route is not the wrong shape, but the
plan mislocates the work. Build the two genuinely-missing lemmas (C, D); the rest is Mathlib glue.

## Major

- **C. The `over U ↔ Spec R_r` bridge is the load-bearing missing ingredient (`NEEDS_MATHLIB_GAP_FILL`).**
  `isIso_fromTildeΓ_of_presentation` needs `M : (Spec S).Modules` and a *geometric* presentation, but
  `q.presentation i` lives on the abstract slice `SheafOfModules ((Spec R).ringCatSheaf.over (q.X i))`.
  Mathlib has the constituents — `Scheme.Hom.opensFunctor` (`OpenImmersion.lean:87`), the
  basicOpen↔`Spec R_r` isos (`AffineScheme.lean:566–572`, `isLocalization_basicOpen`), the iterated
  slice equivs (`Sites/Over.lean`) — but **no** equivalence `J.over U ≃ Opens(U.toScheme)` carrying
  `R.over U ≅ U.toScheme.ringCatSheaf`, hence no `M.over U ≅ M.restrict U.ι`. Build `overRestrictIso`
  as the single lemma that touches the slice site (use `backward.isDefEq.respectTransparency false`).

- **D. The section-localization descent is the keystone, not the transport (`NEEDS_MATHLIB_GAP_FILL`).**
  Even granting `IsIso ((M|_{D(r)}).fromTildeΓ)` per `Spec R_r`, assembling the global-over-`R`
  statement the engine consumes (`∀ f, IsLocalizedModule (powers f) (Γ(M,⊤)→Γ(M,D f))`) needs the
  sheaf-equalizer + flat-localization descent (Hartshorne II.5.3 / Stacks 01HA): `M.isSheaf`,
  finite cover, `IsLocalization.flat`. `isLocalizedModule_basicOpen_of_presentation`
  (`QuotScheme.lean:686`) does NOT close it — that needs a *global* presentation of `M` on `Spec R`,
  not per-`D(r)` data. Same irreducible content flagged in `quot-qcoh-affine-globalization.md`.

## Informational

- A/B (PROCEED). Obstacle #1 ("no restriction functor on `(Spec R).Modules`") is **factually wrong**:
  `Scheme.Modules.restrictFunctor`/`pullback` live in `Modules/Sheaf.lean` (a Restriction section the
  prover apparently excluded from `{Presheaf, Sheaf, Tilde}`). The slice route is canonical for the
  transport sub-step and its timeout is tameable. Do not hand-roll a restriction functor.
- Recommended build order (detail in the persistent file): (1) `overRestrictIso` [C];
  (2) per-affine local-tilde via `Presentation.map` (iterated slice → `overRestrictIso` →
  `pullback` of `D(r) ≅ Spec R_r`) + `isIso_fromTildeΓ_of_presentation` [P1]; (3) section-localization
  descent [D]; (4) feed the existing `isIso_fromTildeΓ_iff_isLocalizedModule_restrict`.
- The standing memory `quot-quasicoherentdata-slice-transport-wall` is now partly stale: the wall is
  not "no restriction functor" but "no `over U ↔ Spec R_r` bridge + descent is the keystone", and the
  slice-statement timeout is dissolved by `set_option backward.isDefEq.respectTransparency false`.

## Persistent file
- `analogies/quot-gap1-transport.md` — design-rationale + four-step decomposition captured for future iters.

Overall verdict: PROCEED on a corrected decomposition — the `over`-slice route is the canonical (and
tameable) idiom for the presentation-transport sub-step and a restriction functor already exists, but
gap1's real work is the two new lemmas `overRestrictIso` (the `over U ↔ Spec R_r` bridge) and the
section-localization descent.
