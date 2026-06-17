# Blueprint Writer Report

## Slug
p3b-realign

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Subsection intro (§"Presheaf-level {\v C}ech machinery")
- **Revised** the opening paragraph: dropped the description routing through a
  right-derived \(\delta\)-functor and enough-injectives; restated the argument as the
  direct two-part route (free resolution + section {\v C}ech complex; injective
  transfer via the sheafification adjunction). Now references
  `def:section_cech_complex`, `lem:injective_of_adjoint`, `lem:mod_pmod_adjunction`.

### A. `def:cech_free_presheaf_complex` (`\lean{AlgebraicGeometry.cechFreePresheafComplex}`)
- **Rewrote** the body. Removed the bespoke `j_!`/"shriek functor
  `(j_!G)(W)=G(W)` if `W⊆U` else 0" prose. The summand is now realized as
  `\operatorname{free}(\mathbf{y}\,U_{i_0…i_p})` — the free presheaf of modules on the
  Yoneda representable of the open — with its defining universal property
  `Hom(free(𝐲 V), F) ≅ F(V)` (free–forgetful adjunction + Yoneda) stated explicitly.
  `K(𝒰)_•` is now a chain complex in `\mathrm{PMod}(\mathcal{O}_X)`, degree `p` =
  `⨁ free(𝐲 U_{i_0…i_p})`, differentials = `free` applied to the representable
  index-dropping maps `𝐲 U_{i_0…i_{p+1}} → 𝐲 U_{i_0…î_j…i_{p+1}}` (inclusions of
  opens), alternating sum. No named `j_!` introduced. Kept the
  `lemma-cech-map-into` `% SOURCE`/`% SOURCE QUOTE`.

### B. NEW `def:section_cech_complex` (`\lean{AlgebraicGeometry.sectionCechComplex}`)
- **Added** the section {\v C}ech complex `Č•(𝒰,F)`: a `CochainComplex` of
  `\mathcal{O}_X(U)`-modules, degree `p` = `∏ F(U_{i_0…i_p})` (evaluation of `F`), with
  the alternating Čech restriction differential. Includes a sentence flagging it as
  **distinct** from the relative `CechComplex` (`def:cech_complex`, the pushforward
  complex `∏ (f|_{U_…})_*(F|_{U_…})` in `QCoh(S)`), so no third notion is forked.
  `% SOURCE`/`% SOURCE QUOTE` from `stacks-cohomology.tex` (definition of
  `\check{\mathcal{C}}^\bullet`, L879–910). `\uses{def:cech_complex}`.

### C. `lem:cech_complex_hom_identification` (`\lean{AlgebraicGeometry.cechComplex_hom_identification}`)
- **Revised** statement + proof. Now states `Hom(K(𝒰)_•, F) ≅ Č•(𝒰,F)` against the
  new section complex (B). `\uses{def:cech_free_presheaf_complex, def:section_cech_complex}`.
  Proof rewritten to use the free–forgetful adjunction + Yoneda + evaluation in place
  of the shriek adjunction. Kept the `lemma-cech-map-into` source quotes.

### D. `lem:cech_free_complex_quasi_iso` (`\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}`)
- **Revised** proof prose only: added that homology in `\mathrm{PMod}(\mathcal{O}_X)`
  is computed **objectwise** (kernels/cokernels open-by-open), so exactness is checked
  sectionwise; updated the "shriek presheaves" phrase to the `free(𝐲 V)` description.
  Statement and the explicit `h(s)_{i_0…} = (i_0=i_fix)·s_{i_1…}` homotopy unchanged.
  Kept the `lemma-homology-complex` quotes.

### E. `lem:injective_cech_acyclic` (`\lean{AlgebraicGeometry.injective_cech_acyclic}`)
- **Rewrote** the proof to the direct two-part route:
  1. Injective sheaf ⟹ injective presheaf via `injective_of_adjoint` applied to the
     sheafification adjunction (`mod_pmod_adjunction`), sheafification exact ⇒
     mono-preserving.
  2. Vanishing: `Hom(-,I)` exact carries the exact augmented free resolution (D) to an
     exact section complex (C), so `Ȟ^p(𝒰,I)=0` for `p>0`, `Ȟ^0 = I(U)`.
  Explicitly notes it uses neither enough-injectives nor the δ-functor. Also trimmed
  the statement-block `% SOURCE` to just `lemma-injective-trivial-cech` (dropped the
  now-off-route `lemma-cech-cohomology-derived-presheaves` pointer and its δ-functor
  `% SOURCE QUOTE`). Kept the `lemma-injective-trivial-cech` statement quote and the
  two `% SOURCE QUOTE PROOF` blocks (both verbatim, both on the new route).

### F. NEW `\mathlibok` anchors
- **Added** `lem:injective_of_adjoint` / `\lean{CategoryTheory.Injective.injective_of_adjoint}` `\mathlibok`.
- **Added** `lem:mod_pmod_adjunction` / `\lean{PresheafOfModules.sheafificationAdjunction}` `\mathlibok`.

### G. REMOVED (directive-authorized; off the critical path)
- `lem:presheaf_modules_enough_injectives` (lemma + proof)
- `lem:cech_delta_functor_presheaves` (lemma + proof)
- `lem:grothendieck_enough_injectives` (`\mathlibok` anchor)
- `lem:module_cat_grothendieck` (`\mathlibok` anchor)
Before deleting I grepped the chapter and the whole `blueprint/src/` tree: the only
references were the four blocks themselves, the subsection intro (rewritten), and the
`injective_cech_acyclic` proof (rewritten). No out-of-scope block referenced any of
them.

## Final `\uses{}` of `lem:injective_cech_acyclic`
- Statement block: `\uses{def:cech_complex}` (unchanged).
- Proof block: `\uses{def:cech_complex, def:section_cech_complex,
  lem:cech_complex_hom_identification, lem:cech_free_complex_quasi_iso,
  lem:injective_of_adjoint, lem:mod_pmod_adjunction}` — exactly the directive's set.

## F-anchor Mathlib `\lean{}` names and verification
- `CategoryTheory.Injective.injective_of_adjoint` — verified via `lean_loogle`
  `"injective_of_adjoint"`: exact match, module
  `Mathlib.CategoryTheory.Preadditive.Injective.Basic`, signature
  `{L : C ⥤ D} {R : D ⥤ C} [L.PreservesMonomorphisms] (adj : L ⊣ R) (J : D)
   [Injective J] : Injective (R.obj J)`.
- `PresheafOfModules.sheafificationAdjunction` — verified via `lean_leansearch`:
  exact definition in module
  `Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification`, signature carries
  `(α : R₀ ⟶ R.val)`; for a scheme `α = 𝟙` (the identity ring map), which the anchor
  states in that specialized form. (The companion right-adjoint witness
  `instIsLeftAdjointSheafOfModulesSheafification` was also confirmed present.)

## leandag result
`leandag build --json` (exit 0): `unknown_uses: []`, `conflicts: []`, no cycles
(acyclic — a cycle would error the build). `mathlib_ok: 9` (net unchanged: −2 removed
anchors, +2 new anchors). None of the edited/new nodes
(`def:section_cech_complex`, `lem:injective_of_adjoint`, `lem:mod_pmod_adjunction`,
`def:cech_free_presheaf_complex`, `lem:cech_complex_hom_identification`,
`lem:injective_cech_acyclic`) appear isolated. LaTeX environments balanced
(lemma 18/18, definition 12/12, proof 16/16).

## References consulted
- `references/stacks-cohomology.tex` — verbatim quotes: `lemma-cech-map-into`
  (free complex `K(𝒰)_•`, L1137–1196, retained), the section `\check{\mathcal{C}}^\bullet`
  definition (L879–910, new B), `lemma-homology-complex` (L1198–, retained),
  `lemma-injective-trivial-cech` (L1407–1431, retained statement + proof quotes); also
  the `j_{p!}` discussion (L1095–1135) used to confirm the `free(𝐲 V)` = extension-by-zero
  identification.

## Macros needed (if any)
None. `\mathbf{y}` (Yoneda) uses the standard `\mathbf`; no new macro introduced.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The Lean scaffolds `AlgebraicGeometry.sectionCechComplex`,
  `AlgebraicGeometry.cechFreePresheafComplex`,
  `AlgebraicGeometry.cechComplex_hom_identification`,
  `AlgebraicGeometry.cechFreeComplex_quasiIso`,
  `AlgebraicGeometry.injective_cech_acyclic` are not yet built in
  `CechHigherDirectImage.lean` (they show as `unmatched`/unbuilt in leandag, which is
  expected). The realigned blueprint now targets `X.PresheafOfModules`,
  `PresheafOfModules.free`, `yoneda`, `PresheafOfModules.evaluation`,
  `freeAdjunction`, and the two F-anchor Mathlib results — i.e. the scaffolder should
  build `cechFreePresheafComplex` as a `ChainComplex X.PresheafOfModules ℕ` and avoid
  authoring any bespoke `j_!`.
- `sectionCechComplex` lands in `ModuleCat (R.obj (op U))` (sections), deliberately
  separate from the relative `CechComplex` in `S.Modules`; keep them distinct in Lean
  as the blueprint now flags.

## Strategy-modifying findings
None.
