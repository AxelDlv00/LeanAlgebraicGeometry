# Blueprint Writer Directive — p3b-realign

## Target chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Read first (load-bearing)
- `.archon/analogies/p3b-presheafcech.md` — the api-alignment analysis this directive
  implements. READ IT IN FULL before editing; it gives the exact Mathlib idioms and the
  decisions you must encode.
- `references/stacks-cohomology.tex` — the verbatim source for all math content
  (`lemma-cech-map-into` L1138, `lemma-homology-complex` L1199,
  `lemma-injective-trivial-cech` L1407). Keep `% SOURCE QUOTE` discipline.

## Context (why this edit)
The §"Presheaf-level Čech machinery" subsection was written last (iter-011) routing
`lem:injective_cech_acyclic` through presheaf enough-injectives + a Čech δ-functor
universality identification. A fresh mathlib-analogist pass (`p3b-presheafcech.md`) found
this is (a) **mis-aligned** — it would author a bespoke `j_!` extension-by-zero functor that
duplicates Mathlib's `PresheafOfModules.free`, and (b) **over-engineered** — the headline
result `injective_cech_acyclic` does NOT need enough-injectives or the δ-functor; a direct
route via `Injective.injective_of_adjoint` + the free-presheaf resolution bypasses both
expensive (and Mathlib-absent) bricks. Your job: realign the subsection to the analogist's
design and DROP the two unnecessary blocks.

## SCOPE — edit ONLY these blocks
The §"Presheaf-level Čech machinery" subsection (currently `def:cech_free_presheaf_complex`
through `lem:cech_delta_functor_presheaves`) and `lem:injective_cech_acyclic`.

**Do NOT touch** (out of scope, leave verbatim): `def:standard_affine_cover`,
`lem:cech_acyclic_affine` (P3 — locked), `lem:ses_cech_h1`, `lem:affine_serre_vanishing`,
`lem:cech_to_cohomology_on_basis`, `lem:cech_augmented_resolution`,
`lem:higher_direct_image_presheaf`, `lem:open_immersion_pushforward_comp`,
`lem:cech_term_pushforward_acyclic`, `lem:cech_computes_cohomology`, and all P1/P2 blocks.

## Required changes

### A. `def:cech_free_presheaf_complex` (`\lean{AlgebraicGeometry.cechFreePresheafComplex}`)
Rewrite the Lean realization. The blueprint summand `(j_{i_0…i_p})_! (\mathcal O_X|_{U_{i_0…i_p}})`
must be realized as `(PresheafOfModules.free _).obj (yoneda.obj U_{i_0…i_p})` — Mathlib's free
presheaf-of-modules on the representable `yoneda U`. On `V` this is the free `R(V)`-module on
`Hom(V,U)` = `R(V)` if `V ⊆ U` else `0`, i.e. exactly extension-by-zero of `O_X|_U`.
- REMOVE the bespoke `j_!`/"shriek functor `(j_!G)(W)=G(W)` if `W⊆U` else 0" prose. Replace
  with: "this extension-by-zero presheaf is, canonically, `(PresheafOfModules.free).obj
  (yoneda U)` (Mathlib), whose defining property `Hom(free(yoneda U),F) ≅ F(U)` is
  `freeAdjunction` + Yoneda."
- Realize `K(𝒰)_•` as a `ChainComplex X.PresheafOfModules ℕ`, degree `p` =
  `⨁_{i_0…i_p} (free).obj (yoneda U_{i_0…i_p})`, differentials = `(free).map` of the
  representable index-dropping maps `yoneda U_{i_0…i_{p+1}} → yoneda U_{i_0…î_j…i_{p+1}}`
  (inclusions of opens), alternating sum. Category = `X.PresheafOfModules`
  (`= PresheafOfModules X.ringCatSheaf.val`); do NOT introduce a named `j_!`.
- Keep the `% SOURCE`/`% SOURCE QUOTE` for `lemma-cech-map-into` (the math); the `free(yoneda)`
  realization is a Lean-alignment note, not a new source claim.

### B. NEW `\definition` `def:section_cech_complex`
Add (immediately after A) a definition of the **presheaf-section Čech complex**
`Č•(𝒰,F)` — the object `Hom(K_•,F)` lands in. It is a `CochainComplex (ModuleCat (O_X(U))) ℕ`
(or `ModuleCat (R.obj (op U))`), degree `p` = `∏_{i_0…i_p} F(U_{i_0…i_p})` (sections, via
`PresheafOfModules.evaluation`), with the alternating Čech differential.
- `\lean{AlgebraicGeometry.sectionCechComplex}`.
- Make it explicit this is **distinct from** the relative `CechComplex` (`def:cech_complex`),
  which is the pushforward complex `∏ (f|_{U_…})_*(F|_{U_…})` in `S.Modules`. This is a
  separate, simpler object of sections. Add one sentence flagging the distinction so no third
  notion is forked downstream.
- Source: the section Čech complex is standard (Stacks `lemma-cech-map-into` discussion); cite
  `references/stacks-cohomology.tex` accordingly.

### C. `lem:cech_complex_hom_identification` (`\lean{AlgebraicGeometry.cechComplex_hom_identification}`)
Restate as: `Hom_{X.PresheafOfModules}(K(𝒰)_•, F) ≅ Č•(𝒰,F)` (the new section complex B),
natural in `F`. Proof via `(freeAdjunction _).homEquiv (yoneda.obj U) F` + the Yoneda section
iso + `PresheafOfModules.evaluation`, taken over the multi-index product. Update
`\uses{def:cech_free_presheaf_complex, def:section_cech_complex}`. Keep the
`lemma-cech-map-into` source quotes.

### D. `lem:cech_free_complex_quasi_iso` (`\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}`)
Keep the statement (`K(𝒰)_•` resolves `O_𝒰[0]`; homology = `O_𝒰` in degree 0 else 0).
Adjust the proof prose only if needed to note: homology of `PresheafOfModules` is computed
**objectwise**, and the sectionwise extended complex over each open `W` is contractible by the
explicit homotopy `h(s)_{i_0…} = (i_0 = i_fix) · s_{i_1…}`. Keep `lemma-homology-complex` quotes.

### E. `lem:injective_cech_acyclic` (`\lean{AlgebraicGeometry.injective_cech_acyclic}`) — REWRITE PROOF
Replace the proof with the direct two-part route (analogist decision 6):
1. **Injective sheaf ⟹ injective presheaf.** Apply `CategoryTheory.Injective.injective_of_adjoint`
   to the adjunction whose right adjoint is the inclusion `Scheme.Modules.toPresheafOfModules X
   : X.Modules ⥤ X.PresheafOfModules` and whose left adjoint is sheafification (which preserves
   monomorphisms, being exact): `PresheafOfModules.sheafificationAdjunction`. So an injective
   `I : X.Modules` has injective image in `X.PresheafOfModules`.
2. **Vanishing.** `K(𝒰)_• → O_𝒰` is an exact augmented complex (D); for injective `I`,
   `Hom(-,I)` is exact, hence `Hom(K_•,I) = Č•(𝒰,I)` (C) is exact in positive degrees, i.e.
   `Ȟ^p(𝒰,I) = 0` for `p>0`. This is Stacks `lemma-injective-trivial-cech` and uses NEITHER
   enough-injectives NOR the δ-functor identification.
- Update the proof `\uses{}` to:
  `{def:cech_complex, def:section_cech_complex, lem:cech_complex_hom_identification,
    lem:cech_free_complex_quasi_iso, lem:injective_of_adjoint, lem:mod_pmod_adjunction}`
  (the last two are the anchors in F). **Drop** `lem:presheaf_modules_enough_injectives` and
  `lem:cech_delta_functor_presheaves`.
- Keep the `lemma-injective-trivial-cech` source quote.

### F. NEW `\mathlibok` anchors (replace the dropped ones)
Add two Mathlib dependency anchors (statement + `\lean{}` + `\mathlibok`, NO `% SOURCE`):
- `lem:injective_of_adjoint` / `\lean{CategoryTheory.Injective.injective_of_adjoint}` —
  "if `L ⊣ R`, `L` preserves monos, and `J` is injective, then `R.obj J` is injective."
- `lem:mod_pmod_adjunction` / `\lean{PresheafOfModules.sheafificationAdjunction}` —
  "sheafification is left adjoint to the inclusion `toPresheafOfModules`" (verify the exact
  Mathlib name via `lean_loogle`/`lean_leansearch`; if `sheafificationAdjunction` needs the
  identity ring map `α = 𝟙`, state it in that specialized form, or use the
  `instIsRightAdjoint…toPresheafOfModules` witness — pick the name that typechecks and name it
  in your report).
Mark these `\mathlibok` ONLY (they are genuine Mathlib re-exports). Do NOT mark anything else.

### G. REMOVE the now-unused blocks
Delete (they are off the critical path and no Lean will be built for them):
- `lem:presheaf_modules_enough_injectives`
- `lem:cech_delta_functor_presheaves`
- the two `\mathlibok` anchors that only fed enough-injectives:
  `lem:grothendieck_enough_injectives`, `lem:module_cat_grothendieck`.
**Before deleting each**, grep the whole chapter to confirm no surviving block `\uses{}` it
(after your edits A–F). If any in-scope block still references one, re-point it per A–F. If an
OUT-OF-scope block references one, STOP and report it instead of deleting (do not edit
out-of-scope blocks). Report exactly what you removed.

## Constraints
- NEVER add or touch `\leanok` (deterministic sync owns it). `\mathlibok` ONLY on the F anchors.
- Keep every retained `% SOURCE` / `% SOURCE QUOTE` verbatim and in original language.
- Math-only prose; no Lean tactic code; no project-history narrative.
- After editing, run `leandag build --json` and confirm `unknown_uses: []`, `conflicts: []`,
  acyclic. Report the result.

## Report
List every block added / rewritten / removed, the final `\uses{}` of
`lem:injective_cech_acyclic`, the exact Mathlib `\lean{}` names you used for the F anchors (and
how you verified them), and any "Strategy-modifying findings".
