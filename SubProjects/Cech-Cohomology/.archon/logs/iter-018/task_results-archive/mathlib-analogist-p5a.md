# Mathlib Analogist Report

## Mode
api-alignment

## Slug
p5a

## Iteration
017

## Question
Open a prover lane next iter for `lem:higher_direct_image_presheaf` (Stacks 01XJ):
`Rⁱ f_* F = sheafify(V ↦ Hⁱ(f⁻¹V, F))` for `F : X.Modules`. Confirm/refute each of
four building blocks on TODAY's Mathlib (exact decl + namespace, or ABSENT), render a
PROCEED / ALIGN-WITH-MATHLIB / NOT-FEASIBLE-YET verdict, give the API skeleton + infra
split, and say whether the iter-011 design in `analogies/p5a-01xj.md` still holds.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1 standalone module-valued `Hⁱ(open,F)` | NEEDS_MATHLIB_GAP_FILL (avoid materialising; use basis-local form) | informational |
| Q2 `Rⁱf_* = sheafify(objectwise Hⁱ)` | NEEDS_MATHLIB_GAP_FILL (build; engine present) | informational |
| Q3 `rightDerived pushforward` + `[HasInjectiveResolutions X.Modules]` | PROCEED (carry as hypothesis) | informational |
| Q4 `Hⁱ(U,F)` functorial / open-immersion comp | ALIGN_WITH_MATHLIB (acyclic-resolution route, not spectral seq) | high |
| **Overall: open the 01XJ lane** | **PROCEED** | — |

## Building-block confirmation (directive Q1–Q4)

**Q1 — abstract `Rⁱf_* = sheafify(…)` for `Sheaf J AddCommGrp`:** No packaged
derived-functor↔sheafification comparison exists for *either* category. The
AddCommGrpCat-valued presheaf cohomology `V ↦ Hⁱ(V,F)` IS shipped — `Sheaf.H` /
`cohomologyPresheafFunctor` / `Sheaf.H'` at `CategoryTheory/Sites/SheafCohomology/Basic.lean:58,90,105` — but only for `Sheaf J AddCommGrpCat` (gated `[HasSheafify][HasExt]`), NOT for `Scheme.Modules`. There is nothing to "port"; the comparison is buildable, not portable.

**Q2 — sheafification of `(Presheaf/Sheaf)OfModules`, exactness/limit preservation:**
PRESENT and stronger than iter-011 cited.
- `PresheafOfModules.sheafification : PresheafOfModules R₀ ⥤ SheafOfModules R` — `Algebra/Category/ModuleCat/Presheaf/Sheafification.lean:54`; left adjoint via `PresheafOfModules.sheafificationAdjunction`.
- `PreservesFiniteLimits (sheafification α)` — same file `:190` (and `:181` for the composite with `toSheaf`).
- `SheafOfModules.toSheaf` + `PreservesFiniteLimits` — `Algebra/Category/ModuleCat/Sheaf/Limits.lean` (`instPreservesFiniteLimits…ToSheaf`).
A left adjoint preserving finite limits preserves finite limits AND all colimits ⇒ preserves homology in the abelian `X.Modules`. This is the exact engine for "cohomology sheaf = sheafify(objectwise homology)".

**Q3 — `rightDerived pushforward`, `HasInjectiveResolutions X.Modules`:**
- `Functor.rightDerived` — `CategoryTheory/Abelian/RightDerived.lean:108`. PRESENT.
- `pushforward` / `pushforwardComp` (with `_hom_app_app = 𝟙` by `rfl`) — `AlgebraicGeometry/Modules/Sheaf.lean:151,210,214`. PRESENT.
- `[HasInjectiveResolutions X.Modules]`: **no Mathlib instance** for any sheaf-of-modules category (instances exist only for `ModuleCat R`, `AddCommGrpCat`, `Ind C`, `HomologicalComplex`). BUT a complete discharge *chain* now exists (see "New finding"). P5a does not need the instance — it carries the typeclass as a hypothesis exactly as `higherDirectImage`/`cech_computes_higherDirectImage` do.

**Q4 — `Hⁱ(U,F)` functorial in `V` / open-immersion composition:**
Idiom: state exactness via `HomologicalComplex.ExactAt`/`QuasiIso`; the open-immersion
composition `pushforward f ⋙ (jₛ)_* = (gₛ)_*` holds by `pushforwardComp` (`rfl`);
"(jₛ)_* preserves injectives" via `Functor.preservesInjectiveObjects_of_adjunction_of_preservesMonomorphisms` (`CategoryTheory/Preadditive/Injective/Preserves.lean:49`). **No** Grothendieck/Leray spectral sequence and **no** `R(g∘f) ≅ Rg∘Rf` exist (re-confirmed absent; only `NatTrans.rightDerived_comp` for `α≫β`) — and the design correctly avoids needing them by routing through the project's P4 acyclic-resolution engine (`Functor.rightDerivedIsoOfAcyclicResolution`, `AcyclicResolution.lean:227`).

## New finding (changed since iter-011): `[HasInjectiveResolutions X.Modules]` is now one instance away
Mathlib added a full chain:
`IsGrothendieckAbelian C → EnoughInjectives C` (`GrothendieckCategory/EnoughInjectives.lean:374`, `@[stacks 079H]`) `→ HasInjectiveResolutions C` (`Abelian/Injective/Resolution.lean:343,345`, gated `[Abelian][EnoughInjectives]`). The sole missing link to inhabit the typeclass is a single instance `IsGrothendieckAbelian (SheafOfModules R)` (ABSENT). This converts the long-standing P3b "build enough-injectives" goal into one isolated, well-scoped instance (needs `Abelian` ✓ + AB5/`HasColimits` + `HasSeparator`). It does **not** gate P5a, but it de-risks the entire conditional-result family and is the cleanest path to making the Čech results unconditional.

## Recommended API skeleton (order of composition)
1. State 01XJ in the **basis-local vanishing** form, never materialising a standalone `Hⁱ(open,F)`: `(pushforward f).rightDerived k G ≅ 0  ↔  ∀ affine V, the k-th homology of the ModuleCat complex `(f_* I^•)(V)` vanishes`.
2. Build "cohomology sheaf = sheafify(objectwise homology)" from `PresheafOfModules.sheafification`/`SheafOfModules.toSheaf` (PreservesFiniteLimits) + left-adjoint colimit preservation + `Abelian X.Modules`.
3. Add "a sheaf of modules is 0 iff its sections vanish on a basis".
4. Bottom out at the affine Serre-vanishing analytic core (shared with `CechAcyclic.affine`).

## Infra split (project-side new vs Mathlib-provided)
- **Mathlib-provided:** sheafification + finite-limit/colimit preservation (Q2), `Functor.rightDerived` (Q3), `pushforward`/`pushforwardComp` `rfl` (Q4), injective-preservation along the open-immersion adjunction (Q4), abelian structure on `X.Modules`.
- **Project-side new:** the three lemmas in the skeleton (steps 2–4). Step 4 (affine Serre vanishing / local-on-base) is the irreducible analytic core Mathlib does not supply — and it is **shared** with the existing `CechAcyclic.affine` blocker, so no new analytic debt is incurred beyond what the project already owes.

## Informational
- The iter-011 design in `analogies/p5a-01xj.md` **still holds in full** — every cited declaration verified present, every ABSENT item re-confirmed absent.
- 01XJ (`higher_direct_image_presheaf`, the sheafification statement) is a **distinct** statement from the protected `cech_computes_higherDirectImage` (the Čech↔derived comparison). Opening it as a parallel lane does not touch the frozen signature.

## Persistent file
- `analogies/p5a.md` — iter-017 re-validation + new typeclass-chain finding, cross-linking `analogies/p5a-01xj.md`.

Overall verdict: PROCEED — open the 01XJ lane next iter carrying `[HasInjectiveResolutions X.Modules]` as a hypothesis; use the basis-local form, lean on the now-present sheafification/finite-limit engine, and the only project-side analytic debt is the affine Serre-vanishing step already shared with `CechAcyclic.affine`.
