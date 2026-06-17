# Blueprint-writer directive — redesign `lem:cech_acyclic_affine` to the SECTION-complex form + decompose L1

You edit ONLY `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`. You may spawn a
reference-retriever into `references/**` only if you genuinely lack a source (you should not — all
sources are present). Do NOT add or remove `\leanok` (deterministic `sync_leanok` owns it).

## Background — why this redesign (read first)
Read `analogies/l1-bridge.md` (just written by a Mathlib-analogist) in full. It establishes that the
L1 categorical→module bridge for `lem:cech_acyclic_affine`, **as currently stated** (vanishing of the
*relative* complex `CechComplex f 𝒰 F`, which wraps each term in `pushforward f`), is NOT formalizable
as one lane: the outer `pushforward f` is a right adjoint that does not preserve homology, and
affine-pushforward exactness is absent from Mathlib (its "Q4", the decisive blocker).

**The planner has decided (Q4):** re-state `lem:cech_acyclic_affine` to vanish the **absolute section
Čech complex** `Č•(𝒰, F)` = `def:section_cech_complex` (`AlgebraicGeometry.sectionCechComplex`, already
built, `CochainComplex Ab ℕ`), NOT the relative pushforward complex. This is correct and safe because:
- The Stacks route that consumes `cech_acyclic_affine` — `lem:injective_cech_acyclic`,
  `lem:ses_cech_h1`, `lem:cech_to_cohomology_on_basis` (01EO), `lem:affine_serre_vanishing` (02KG) —
  is entirely about the **absolute** section Čech complex / Čech cohomology on the affine, never the
  relative pushforward complex.
- The relative complex's acyclicity (needed only for P5b) is supplied later via `affine_serre_vanishing`
  + `cech_term_pushforward_acyclic` (P5a), which do not call `cech_acyclic_affine` directly.
- On the standard cover by basic opens `D(s_i)` of `Spec R`, the section-complex terms are
  `F(⨅_k D(s_{σ k})) = F(D(∏_k s_{σ k})) = F(D(s_σ)) = M_{s_σ}` (away-localisation), so the localisation
  route (`exact_of_isLocalized_span` + the done `CombinatorialCech.Dependent.depDiff_exact`) applies
  directly with NO pushforward in the way.

## TASK 1 — Re-state `lem:cech_acyclic_affine` (around L510) to the section-complex form
- Change the conclusion from vanishing of the relative `CechComplex f 𝒰 F` to vanishing of the
  **section Čech complex** of `def:section_cech_complex` for the standard affine cover: for
  `R : CommRingCat`, `F : (Spec R).Modules` quasi-coherent, `s : ι → R` with
  `Ideal.span (Set.range s) = ⊤` (finite `ι`), and `p ≥ 1`,
  `Ȟᵖ(𝒰, F) = 0` where `𝒰` is the standard cover by `D(s_i)` and `Ȟᵖ` is the cohomology of the
  **section** complex `Č•(𝒰, F)`.
- Replace `def:cech_complex` with `def:section_cech_complex` in the statement `\uses{...}`.
- Drop the `f : Spec R ⟶ S` / `[IsAffineHom f]` framing from the prose (no relative morphism; the
  statement is intrinsic to `Spec R`). Keep the existing verbatim SOURCE QUOTE(s) (Stacks
  02KE/02KG/01HV) — they describe the absolute affine Čech vanishing, consistent with the new form.
- Update the `\lean{...}` pin: the to-be-re-signed Lean target. Keep the constant + dependent
  `CombinatorialCech.*` / `CombinatorialCech.Dependent.*` bundle (those helpers are unchanged and still
  used). For the top-level decl, you MAY propose a clearer name such as
  `AlgebraicGeometry.sectionCech_affine_vanishing` and note in a `% NOTE:` comment that the Lean
  decl will be re-signed next iter (planner refactor); keep the OLD name
  `AlgebraicGeometry.CechAcyclic.affine` in the `\lean{...}` list too for now so coverage is not lost
  until the refactor lands. (The deterministic sync handles `\leanok`; you do not.)

## TASK 2 — Decompose the L1 bridge into a `\uses`-linked chain of sub-lemmas
Replace the single long L1 proof paragraph with a structured proof that cites three sub-lemma/def
blocks (create each as its own `\begin{lemma}`/`\begin{definition}` block, placed just before
`lem:cech_acyclic_affine` or in a clearly-marked L1 subsection). Use `analogies/l1-bridge.md` for the
exact Mathlib API. For each block: title, `\label{}`, a proposed `\lean{}` name (the decl does not
exist yet — it is a build target; that is fine, tex may precede Lean), `\uses{}`, SOURCE lines where
the content is from Stacks (read the local source and quote verbatim), and an informal proof.

1. **`def:qcoh_sections_localized`** (section = localisation; the analogist's Q1). For quasi-coherent
   `F` on `Spec R` and `g : R`, the sections `F(D(g))` form the away-localisation `M_g` of
   `M = Γ(Spec R, F)`; concretely `IsLocalizedModule (Submonoid.powers g) (restriction map)`. Note the
   analogist's gap: Mathlib has `IsLocalizedModule … (tilde.toOpen M (basicOpen g)).hom` and
   `tilde.toOpen_res` for `tilde M`, but the step `F ≅ tilde (Γ F)` for an arbitrary quasi-coherent
   `F` needs globalising local `QuasicoherentData` (Stacks 01I8, ~100–150 LOC project-side). State
   this as a sub-lemma to build; cite `references/stacks-schemes.tex` 01HV(4)–(5) and the gap.
2. **`lem:section_cech_homology_exact`** (homology ↔ exactness; the analogist's Q3). For the section
   complex on the standard cover, `IsZero (homology p)` reduces to `Function.Exact` of the underlying
   localised-module maps, via `exactAt_iff_isZero_homology` + `moduleCat_exact_iff` (Mathlib,
   confirmed) and the term/differential identification of (1). State that the identification of the
   abstract section complex with the concrete localised-module complex `∏_σ M_{s_σ}` (+ the δ/c maps
   discharging `hu`/`hsh`/`hcomm`) is the bulk (~250–400 LOC); the non-circular route is reflection on
   the localisation equivalence's essential image, NOT plain "Γ preserves homology" (which is circular).
3. The **assembly**: feed each positive-degree node through `exact_of_isLocalized_span (Set.range s) hs`
   (localising at `Away (s r)`) and close with `CombinatorialCech.Dependent.depDiff_exact`. Wire
   `\uses{def:section_cech_complex, def:qcoh_sections_localized, lem:section_cech_homology_exact,
   AlgebraicGeometry.CombinatorialCech.Dependent.depDiff_exact}` (use label refs, not Lean names, in
   `\uses` where a label exists).

## TASK 3 — Keep the downstream consumers consistent
The blocks `lem:affine_serre_vanishing`, `lem:cech_to_cohomology_on_basis`, `lem:cech_augmented_resolution`
already `\uses{lem:cech_acyclic_affine}`. Confirm their prose still reads correctly with the section-complex
form (it should — they always meant absolute Čech vanishing). Adjust any sentence that explicitly says
the *relative* complex is what `cech_acyclic_affine` vanishes.

## Out of scope
- Do NOT touch the other lanes' blocks (`def:cech_free_presheaf_complex`, `def:cover_structure_presheaf`,
  `lem:cech_free_complex_quasi_iso`, `lem:cech_complex_hom_identification`, `def:section_cech_complex`) —
  they were just finalized and gate-cleared.
- Do NOT add `\leanok`. Do NOT touch the protected `cech_computes_higherDirectImage`.

## Report back
List the re-stated block, the new sub-lemma/def blocks with their labels + proposed `\lean{}` names,
the updated `\uses{}` edges, and confirm no `\uses{}` is left dangling. Flag any Strategy-modifying
findings.
