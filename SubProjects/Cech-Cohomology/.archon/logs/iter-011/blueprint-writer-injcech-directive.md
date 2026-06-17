# Blueprint Writer Directive

## Slug
injcech

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Strategy context

This consolidated chapter (`% archon:covers CechHigherDirectImage.lean`) is the critical-path
chapter for the project goal `cech_computes_higherDirectImage`. Its load-bearing brick is the P3b
minimal torsor-free Čech↔derived bridge. The lemma `lem:injective_cech_acyclic` ("injective
`O_X`-modules are Čech-acyclic") is the irreducible step that compares the explicit Čech complex to
the injective-resolution-defined right-derived functors. Its current proof block ENDS with a
placeholder sentence — "The presheaf-level Čech machinery this rests on … is developed as part of
the chapter's foundational content" — but NO declarations for that foundational content exist in the
blueprint. A prover receiving this block has no blueprinted sub-lemmas to call. Your job is to add
those sub-lemma declarations so the lemma becomes formalization-ready, and to wire `\uses{}`
correctly. This is a pure decomposition/completion task on ONE chapter; do not touch the surrounding
mathematics or the other (already-correct) blocks except the two specific edits named below.

## Required content

Add the following NEW declaration blocks to `Cohomology_CechHigherDirectImage.tex`, placed
**immediately before** the existing `\begin{lemma}…\label{lem:injective_cech_acyclic}` block (around
line 612), in this dependency order. All source material is in `references/stacks-cohomology.tex` —
READ the cited line ranges and transcribe verbatim `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` text
per the chapter's existing citation style (you can see the style on the neighbouring
`lem:injective_cech_acyclic` and `lem:ses_cech_h1` blocks).

1. **`\definition` `\label{def:cech_free_presheaf_complex}`** — the complex \(K(\mathcal{U})_\bullet\)
   of presheaves of `O_X`-modules associated to an open cover \(\mathcal{U}\): in degree \(p\) the
   direct sum \(\bigoplus_{i_0\ldots i_p} (j_{i_0\ldots i_p})_{!}\, \mathcal{O}_U|_{U_{i_0\ldots i_p}}\)
   (extension by zero / "shriek" of the restricted structure sheaf), with the Čech differential.
   `\lean{AlgebraicGeometry.cechFreePresheafComplex}` [expected].
   Source: `references/stacks-cohomology.tex`, `lemma-cech-map-into` (≈L1138–1198).

2. **`\lemma` `\label{lem:cech_complex_hom_identification}`** — for any presheaf of `O_X`-modules
   \(\mathcal{F}\), there is a natural identification
   \(\operatorname{Hom}_{\mathcal{O}_X}(K(\mathcal{U})_\bullet, \mathcal{F}) =
   \check{\mathcal{C}}^\bullet(\mathcal{U}, \mathcal{F})\) of cochain complexes. This is the adjunction
   between the shriek functors and restriction applied termwise.
   `\lean{AlgebraicGeometry.cechComplex_hom_identification}` [expected].
   `\uses{def:cech_free_presheaf_complex, def:cech_complex}`.
   Source: `references/stacks-cohomology.tex`, `lemma-cech-map-into` (≈L1138–1198).

3. **`\lemma` `\label{lem:cech_free_complex_quasi_iso}`** — the complex \(K(\mathcal{U})_\bullet\) is
   quasi-isomorphic to \(\mathcal{O}_U[0]\) (concentrated in degree 0), i.e. the augmented complex
   \(\cdots \to K(\mathcal{U})_1 \to K(\mathcal{U})_0 \to \mathcal{O}_U \to 0\) is exact as a complex
   of presheaves. (Stalkwise / sectionwise this is the standard contractibility of the Čech complex
   of the constant cover; over a fixed open it reduces to a homotopy on the free modules.)
   `\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}` [expected].
   `\uses{def:cech_free_presheaf_complex}`.
   Source: `references/stacks-cohomology.tex`, `lemma-homology-complex` (≈L1199–1284).

4. **`\lemma` `\label{lem:cech_delta_functor_presheaves}`** — the Čech cohomology functors
   \(\check{H}^p(\mathcal{U}, -)\) on \(\mathrm{PMod}(\mathcal{O}_X)\) are canonically isomorphic, as
   a δ-functor, to the right-derived functors of the left-exact \(\check{H}^0(\mathcal{U}, -)\). (This
   is what makes "vanishing on injectives" equivalent to "derived-functor acyclicity".)
   `\lean{AlgebraicGeometry.cech_delta_functor_presheaves}` [expected].
   `\uses{lem:cech_complex_hom_identification, lem:cech_free_complex_quasi_iso, lem:presheaf_modules_enough_injectives}`.
   Source: `references/stacks-cohomology.tex`, `lemma-cech-cohomology-delta-functor-presheaves`
   (≈L1066) and `lemma-cech-cohomology-derived-presheaves` (≈L1287–1398).

5. **`\lemma` `\label{lem:presheaf_modules_enough_injectives}`** — the category
   \(\mathrm{PMod}(\mathcal{O}_X)\) of presheaves of `O_X`-modules has enough injectives. State the
   proof route through Mathlib's Grothendieck-category engine: a Grothendieck abelian category has
   enough injectives, and a presheaf category valued in modules is Grothendieck abelian; so the only
   project-side obligation is the `IsGrothendieckAbelian` instance for the presheaf-of-modules
   category. `\lean{AlgebraicGeometry.presheafModules_enoughInjectives}` [expected].
   In its proof, cite the two Mathlib anchors below by `\uses{}`.

### Mathlib dependency anchors (mark these `\mathlibok`)

Add two small `\mathlibok` anchor blocks (state the result in the project's notation, `\lean{}` the
real Mathlib declaration, mark `\mathlibok`) that `lem:presheaf_modules_enough_injectives` uses:

- **`\label{lem:grothendieck_enough_injectives}`** — every Grothendieck abelian category has enough
  injectives. `\lean{CategoryTheory.IsGrothendieckAbelian.enoughInjectives}` [verified — confirmed
  present in `Mathlib.CategoryTheory.Abelian.GrothendieckCategory.EnoughInjectives`].
- **`\label{lem:module_cat_grothendieck}`** — `ModuleCat R` is a Grothendieck abelian category.
  `\lean{instIsGrothendieckAbelianModuleCat}` [verified — confirmed present in
  `Mathlib.Algebra.Category.ModuleCat.AB`].

(Note for the writer: the `IsGrothendieckAbelian (PresheafOfModules …)` instance itself is NOT yet in
Mathlib — it is the single project-side instance the enough-injectives lemma reduces to. State it as
the to-build core of `lem:presheaf_modules_enough_injectives`; do NOT mark that lemma `\mathlibok`.)

### Two edits to existing blocks

A. **`lem:injective_cech_acyclic` proof** (≈L683–704): replace the closing placeholder sentence ("The
   presheaf-level Čech machinery this rests on … is developed as part of the chapter's foundational
   content.") with prose that explicitly invokes the new sub-lemmas, and update the proof's
   `\uses{def:cech_complex}` to
   `\uses{def:cech_complex, lem:cech_complex_hom_identification, lem:cech_free_complex_quasi_iso, lem:cech_delta_functor_presheaves, lem:presheaf_modules_enough_injectives}`.
   The existing verbatim `% SOURCE QUOTE PROOF:` blocks are correct — keep them.

B. **`lem:cech_to_cohomology_on_basis`** (≈L837+): its `\lean{}` hint is
   `cech_eq_cohomology_of_basis` but the statement now concludes pure vanishing (`H^p(U,F)=0` for
   `p>0`). Add one sentence of prose to the statement body clarifying that the formal target is a
   vanishing statement under conditions (1)–(3), NOT an explicit iso `Ȟ^p ≅ H^p`. (Do not rename the
   `\lean{}` — that is a scaffolder/review decision; just clarify the intended return shape.)

## References
- `references/stacks-cohomology.tex` — the Stacks "Cohomology" chapter. Cited line ranges above
  (`lemma-cech-map-into` ≈L1138, `lemma-homology-complex` ≈L1199, `lemma-cech-cohomology-delta-functor-presheaves`
  ≈L1066, `lemma-cech-cohomology-derived-presheaves` ≈L1287). READ these and transcribe verbatim
  source quotes for each new block.

## Out of scope
- Do NOT touch any block other than the 5 new declarations (+ 2 `\mathlibok` anchors) and the two
  edits A/B named above. All other blocks were audited `correct` this iter.
- Do NOT add `\leanok` to anything (deterministic sync owns it). `\mathlibok` ONLY on the two named
  Mathlib anchor blocks.
- Do NOT reintroduce any `\uses` edge from `lem:cech_to_cohomology_on_basis` (or its sub-lemmas) back
  to `lem:affine_serre_vanishing` — the non-circularity must be preserved.
- Keep the minimal torsor-free scope: do NOT add `lemma-cech-h1` (torsor H¹) or
  `lemma-kill-cohomology-class`.
