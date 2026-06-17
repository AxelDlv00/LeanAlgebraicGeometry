# Mathlib Analogist Report

## Mode
api-alignment

## Slug
p5a-01xj

## Iteration
011

## Question
For the P5a layer of the Čech↔higher-direct-image comparison (the four to-be-built lemmas
`higherDirectImage_isSheafify_presheafCohomology`, `cechAugmented_exact`,
`higherDirectImage_openImmersion_comp`, `cechTerm_pushforward_acyclic`), what is Mathlib's idiom
(existing API to reuse, or the construction path if absent), where does the proposed shape risk a
parallel API, and what is the cost of misalignment? Give a self-contained route for (1)/(2) that
does NOT rely on the dropped presheaf δ-functor formalism.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1 — absolute `Hⁱ(open,F)` for `Scheme.Modules` | NEEDS_MATHLIB_GAP_FILL | major (fork risk) |
| Q2 — `Rⁱf_* = sheafify(presheaf cohomology)` (01XJ) | NEEDS_MATHLIB_GAP_FILL | informational |
| Q3 — derived composition / `j_*`-acyclicity | NEEDS_MATHLIB_GAP_FILL (+ ALIGN on route) | informational |
| Q4 — augmented Čech resolution exactness | NEEDS_MATHLIB_GAP_FILL | informational |
| Q5 — `…presheafCohomology` parallel-API risk | ALIGN_WITH_MATHLIB (direction) | major (proposal-stage) |

Nothing P5a is shipped yet (all four lemmas are to-be-built), so there is no Must-fix-this-iter row;
the fork risks are proposal-stage (`## Major`).

## Answers to the five alignment questions

**Q1 — Sheaf cohomology on an open of `X.Modules`.** Mathlib *does* have sheaf cohomology, but in a
different category: `CategoryTheory.Sheaf.H n` (`Sites/SheafCohomology/Basic.lean:58`, `Ext` from the
constant `ℤ`-sheaf), the presheaf-of-cohomology `Sheaf.cohomologyPresheaf`/`cohomologyPresheafFunctor`
(`…/Basic.lean:99,90`) with `Sheaf.H' F n X = Hⁿ(X,F)` (`…/Basic.lean:105`), and the global-sections
functor `Sheaf.Γ` (`Sites/GlobalSections.lean:64`) — **all for `Sheaf J AddCommGrpCat`, valued in
abelian groups via `Ext`, with `[HasSheafify]`+`[HasExt]`.** There is **no** `Hⁱ(open, F)` for
`Scheme.Modules`/`SheafOfModules`, and `Sheaf.H` is not even connected to `Γ.rightDerived` (it is the
`Ext` definition). So the idiomatic surrogate is one of: (a) route the O_X-module through
`toPresheaf : X.Modules ⥤ TopCat.Presheaf Ab X` (`AlgebraicGeometry/Modules/Sheaf.lean:72`) to the
underlying abelian sheaf and reuse Mathlib's `Sheaf.H'`, plus the standard "O_X-module cohomology =
abelian-sheaf cohomology" comparison; or (b) `((Γ on X.Modules).rightDerived i)` with
`[HasInjectiveResolutions X.Modules]`. **Best is to not materialise a standalone `Hⁱ(open,F)` at all**
(see Recommendation) — the only absolute cohomology that then appears is `Hᵏ` of an explicit
`ModuleCat`-complex `I^•(f⁻¹V)`, which Mathlib already has.

**Q2 — `Rⁱf_* = sheafify(V ↦ Hⁱ(f⁻¹V,F))`.** No Mathlib lemma relates `Functor.rightDerived` of
pushforward to a sheafified cohomology presheaf. It must be built, but **not** as a δ-functor: the
reusable engine is "cohomology sheaf = sheafify of the objectwise (presheaf-level) cohomology",
available because sheafification preserves finite limits (`SheafOfModules.toSheaf`,
`Algebra/Category/ModuleCat/Sheaf/Limits.lean:118`; evaluation `:98`) and, being a left adjoint,
colimits — hence homology — and `X.Modules` is `Abelian` (`Modules/Sheaf.lean:48`). Combined with "a
sheaf is zero iff its sections vanish on a basis", this yields the affine-local vanishing criterion the
project actually consumes.

**Q3 — Derived composition / open-immersion acyclicity.** Mathlib has **no** Grothendieck/Leray
spectral sequence, **no** `R(g∘f)_* ≅ Rg_*∘Rf_*`, and **no** `Functor.rightDerived` of a *composite of
functors* (verified by exhaustive grep; `NatTrans.rightDerived_comp` is derived-of-`α≫β` for nat-trans,
not functor composition). The project's blueprint route for `higherDirectImage_openImmersion_comp`
part (2) **already avoids** this gap: it builds the `f_*`-acyclic resolution `j_* I^•` and feeds the
project's own P4 `Functor.rightDerivedIsoOfAcyclicResolution` (`AcyclicResolution.lean:893`). Mathlib
*does* supply the relevant injective-preservation hook — `Functor.PreservesInjectiveObjects` +
`preservesInjectiveObjects_of_adjunction_of_preservesMonomorphisms`
(`Preadditive/Injective/Preserves.lean:30,49`) — so "`(j_s)_*` preserves injectives" (pullback is
exact) is a one-liner. The *vanishing* `R^q j_* = 0` (relative affine vanishing) is genuinely not in
Mathlib. Also note `pushforward f ⋙ (j_s)_* = (g_s)_*` holds by `pushforwardComp` (`rfl`,
`Modules/Sheaf.lean:210,214`), so no bespoke `R(g∘f)` comparison is needed.

**Q4 — Augmented-resolution exactness.** No Čech-resolution-of-sheaves API in Mathlib; build it with
the standard `HomologicalComplex.ExactAt`/`QuasiIso` idiom (exact in positive degrees / augmentation a
quasi-iso to `F[0]`), checking exactness locally and reducing over an affine basis to the project's P3
`CechAcyclic.affine` (`CechAcyclic.lean:74`). This is **independent of P3b**: P3b's
`cechFreePresheafComplex` (free *presheaves* of modules, injective-acyclicity lane) is a different
object; `cechAugmented_exact` is the sheaf-side complex `Cᵖ = ∏ (j_s)_*(F|_{U_s})` bottoming out at P3.

**Q5 — Parallel-API risks.** The one real risk is the `…presheafCohomology` name/shape forking
Mathlib's `Sheaf.cohomologyPresheaf`/`Sheaf.H'`. The four `\lean{}` names are fine as project
*theorems*; the danger is only if P5a introduces a new module-valued cohomology *definition*. Keep them
as lemmas about `(pushforward f).rightDerived` and explicit `ModuleCat`-complex homology; if a
presheaf-cohomology object is ever named, make it defeq to the underlying-abelian-sheaf
`cohomologyPresheaf`.

## Major

Proposal-stage alignment obligations (no shipped code yet):

- **Q5 / Q1 — do not fork a module cohomology.** When the blueprint-writer/scaffolder lands
  `higherDirectImage_isSheafify_presheafCohomology`, state it as a theorem about
  `(pushforward f).rightDerived` and the homology of the explicit `ModuleCat`-complex `I^•(f⁻¹V)` (or
  the underlying-abelian-sheaf `Sheaf.H'`), never as a fresh `Hⁱ(open,F)` definition over
  `Scheme.Modules`. A forked cohomology would carry zero lemmas (Serre vanishing,
  restriction-compatibility, basis-local vanishing all re-proved) and could never consume Mathlib's
  `Sheaf.H`/`Ext` API.

## Informational

- **Q2/Q3/Q4 are NEEDS_MATHLIB_GAP_FILL** — these are genuine upstream gaps (no derived sheaf
  cohomology for modules, no Grothendieck SS, no Čech-resolution-of-sheaves), not project failures.
  The construction paths are spelled out in `analogies/p5a-01xj.md`.
- **Route lock:** P5a should be the lane that produces the two hypotheses of the already-built P4
  `rightDerivedIsoOfAcyclicResolution`: `cechAugmented_exact ⟶ hexact : ∀ n, K.ExactAt (n+1)` and
  `cechTerm_pushforward_acyclic ⟶ [∀ n, (pushforward f).IsRightAcyclic (Cᵖ)]`. This keeps the whole
  comparison inside the project's existing acyclic-resolution engine — no Grothendieck SS, no
  δ-functor, no Mathlib sheaf-cohomology import on the critical path.
- **`cechTerm_pushforward_acyclic` shrink levers:** acyclicity is closed under products (reduce `Cᵖ` to
  one factor), and `pushforward f ⋙ (j_s)_* = (g_s)_*` by `pushforwardComp` (`rfl`); the only
  irreducible non-Mathlib step is the Serre-vanishing/local-on-base reduction.
- **Cross-lane dependency (not a P5a blocker):** every P5a lemma inherits
  `[HasInjectiveResolutions X.Modules]`, for which **Mathlib provides no instance** (verified: no
  `HasInjectiveResolutions`/`EnoughInjectives`/`IsGrothendieckAbelian` instance for any
  sheaf-of-modules category). Only the P3b lane can eventually discharge it; P5a proceeds with it as a
  hypothesis, matching `higherDirectImage`'s signature.
- **Obsolete blueprint sentence:** block `:1511–1516` still says the comparison is built via a
  "presheaf-level Čech δ-functor formalism over O_X-modules" — that machinery is dropped; the
  blueprint-writer should replace it with the objectwise-homology + sheafification-exactness route
  (Q2).

## Persistent file
- `analogies/p5a-01xj.md` — design-rationale + verified Mathlib map captured for next iter's
  blueprint-writer and scaffolder.

Overall verdict: P5a has no drop-in Mathlib API (all four lemmas are NEEDS_MATHLIB_GAP_FILL), but its
proposed route already aligns with the buildable idioms — funnel into the project's P4 acyclic-resolution
engine, reuse Mathlib's sheafification-preserves-homology and preserves-injectives hooks, and avoid
forking a module-valued sheaf cohomology (the only real parallel-API risk).
