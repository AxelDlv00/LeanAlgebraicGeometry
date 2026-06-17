# Mathlib Analogist Report

## Mode
api-alignment

## Slug
keystone-descent

## Iteration
041

## Question
Does the Route B keystone close from the DONE pieces, or is a sheaf-gluing / Čech-H⁰ ingredient
genuinely missing? Concretely: can `qcoh_section_isLocalizedModule (F) [IsQuasicoherent F] (f) :
IsLocalizedModule (powers f) ρ_f` be assembled *non-circularly* from exactly the 5 DONE
declarations, or does it need an extra input?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| D1 — the glue step (algebraic span-cover descent vs sheaf-axiom equalizer) | NEEDS_MATHLIB_GAP_FILL | critical |
| D2 — Mathlib shortcut supplying `α` / "iso-on-cover" without the keystone | NEEDS_MATHLIB_GAP_FILL | informational |
| D3 — the other 4 DONE pieces as per-tile inputs to the correct route | PROCEED | informational |

**Overall directive verdict: NEEDS_INGREDIENT.** The circularity is REAL. `h j` is un-dischargeable
from the 5 DONE pieces; the descent shape on global sections is wrong (circular). The missing
ingredient is the sheaf-axiom equalizer gluing (Stacks 01HV(4)).

## Answer to the three ranked questions

**1. Confirm/refute the circularity — CONFIRMED.**
Instantiate `isLocalizedModule_of_span_cover` with `M = Γ(X,F)`, `N = Γ(D(f),F)`, `g = ρ_f`,
`s = {gⱼ}`. The per-`j` hypothesis is about the **abstract** localized module
`IsLocalizedModule.map (powers gⱼ) (mkLinearMap … Γ(X,F)) (mkLinearMap … Γ(D(f),F)) ρ_f :
LocalizedModule (powers gⱼ) Γ(X,F) → LocalizedModule (powers gⱼ) Γ(D(f),F)`.
The tile lemma only gives `IsLocalizedModule (powers f)` of the **sheaf-section** map
`Γ(D(gⱼ),F) → Γ(D(gⱼf),F)`. Bridging needs two commuting R-linear equivalences
`α : LocalizedModule (powers gⱼ) Γ(X,F) ≅ Γ(D(gⱼ),F)` and
`β : LocalizedModule (powers gⱼ) Γ(D(f),F) ≅ Γ(D(gⱼf),F)`.
Via `IsLocalizedModule.iso`, `α` is *definitionally* "`ρ_{gⱼ}` is `IsLocalizedModule (powers gⱼ)`" =
**the keystone at `gⱼ`**; `β` is the keystone for the open `D(f)` at `gⱼ`. Neither is DONE. The
descent therefore reduces "keystone at `f`" to "keystone at every `gⱼ`" — the same statement, zero
progress. No Mathlib idiom makes `α` available without the keystone (no "sections of a
sheaf-of-modules over a basic open localise" lemma exists in Mathlib; confirmed by grep + the
Handoff comment at `QcohTildeSections.lean:586`).

**2. The missing ingredient + cheapest Mathlib-aligned build.**
The ingredient is the **sheaf-axiom gluing exact sequence localised at `f`** (Stacks 01HV(4)), NOT
the algebraic local-global principle. Build:
- **[reuse, DONE]** B1 (`qcoh_finite_presentation_cover`) + B4 (`presentationModulesRestrictBasicOpen`)
  + `section_isLocalizedModule_of_presentation` + `restrict_obj` give, per cover element `gᵢ` and
  overlap `gᵢgⱼ`, the per-tile localisations `Γ(D(gᵢ),F)_f ≅ Γ(D(gᵢf),F)`,
  `Γ(D(gᵢgⱼ),F)_f ≅ Γ(D(gᵢgⱼf),F)` (the tiles are tilde, so this is **non-circular** — only the
  tiles, never the global object).
- **[new, small]** the 2-term equalizer `0→Γ(X,F)→∏Γ(D(gᵢ),F)→∏Γ(D(gᵢgⱼ),F)` as `Function.Exact`
  (sheaf condition of `(Spec R).Modules`; this is degree 0/1 of the project's own `sectionCechComplex`,
  or Mathlib's sheaf equalizer) — and likewise for the cover of `D(f)`.
- **[new, Mathlib]** localise the X-cover equalizer at `f` with **`IsLocalizedModule.map_exact`**
  (`Mathlib.Algebra.Module.LocalizedModule.Exact` — localisation preserves `Function.Exact`).
- **[new, bookkeeping]** intertwine the localised equalizer with the `D(f)`-cover equalizer via the
  per-tile isos; kernel comparison gives `Γ(X,F)_f ≅ Γ(D(f),F)`.
The project's P3 section-Čech bridge (`sectionCech_objD_apply`, `qcohRestriction_eq_comparison`, the
`phi`/`phiL` ladder, `sectionToModuleAddEquiv` in `CechAcyclic.lean`) is the **template** for the
last step — but it is wired for the *global* tilde sheaf `~M` and the full positive-degree complex;
the keystone needs only **degree 0/1** for a **general qcoh `F` whose tiles are tilde**. Build that
degree-0/1 specialisation; do not try to reuse `sectionCech_homology_exact` directly (it is `~M`-only).
The "iso checked on a cover" alternative is **strictly worse**: it bottoms out on the same
keystone-at-`gⱼ` AND additionally needs the dormant `tilde_restrict_basicOpen` base-change wall
(Route P, absent from Mathlib per `analogies/o1i8-route.md:80`).

**3. Verdict: NEEDS_INGREDIENT.** The 5 pieces do not suffice; `isLocalizedModule_of_span_cover` is
the wrong glue for the keystone. Keep the other four as per-tile inputs; replace the glue with the
sheaf-axiom equalizer route. Estimate ~150–300 LOC, fiddly but with **no** mathematical wall.

## Must-fix-this-iter
- D1: the planned keystone proof must NOT route through `isLocalizedModule_of_span_cover` applied to
  `(M=Γ(X,F), N=Γ(D(f),F), g=ρ_f)` — that per-`j` obligation is the keystone-at-`gⱼ` in disguise
  (circular). Any prover directive instructing "discharge `h j` via the tile lemma" is unsatisfiable
  and should be rewritten to the sheaf-axiom equalizer glue (build in §2). Equivalently: do not let
  `bridge.md`'s B6 ("section comparison is `restrict_obj`-rfl") stand — it conflated the
  geometric tile identity (rfl) with the abstract↔geometric keystone identity (not rfl).

## Informational
- D2 / D3 rationale and the full circularity derivation are captured in `analogies/keystone-descent.md`.
- The Handoff comment (`QcohTildeSections.lean:559-604`) already correctly names this exact statement
  ("Γ(D(f),F)=Γ(X,F)_f, Stacks 01HV(4)/01I8 … absent from Mathlib") as "the single genuine remaining
  blocker" — this report confirms that the span-cover descent does **not** circumvent it.

## Persistent file
- `analogies/keystone-descent.md` — circularity derivation, the sheaf-axiom glue, B6 assessment, build.

Overall verdict: the keystone span-cover descent on global sections is **circular** (per-`j` ≡
keystone-at-`gⱼ`); proceed instead via the **sheaf-axiom equalizer localised at `f`**
(`IsLocalizedModule.map_exact` + the DONE tile lemma per cover/overlap element), reusing 4 of the 5
DONE pieces and discarding `isLocalizedModule_of_span_cover` as the glue.
