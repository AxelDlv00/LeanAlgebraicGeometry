# Blueprint Writer Directive

## Slug

differentials-iter117

## Target chapter

blueprint/src/chapters/Differentials.tex

## Strategy context (iter-117 post-trim)

`Differentials.lean` has been heavily trimmed in iter-117 by the
refactor subagent. The post-trim file contains only:

1. `relativeDifferentialsPresheaf` (definition, body present, no
   sorry).
2. `relativeDifferentialsPresheaf_obj_kaehler` (theorem, body
   present, no sorry).
3. `smooth_iff_locally_free_omega` (theorem, refactored to use the
   **presheaf** form, body `sorry` — to be closed in a future
   prover round via the Mathlib bridge
   `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`).

DELETED from `Differentials.lean`:

- The sheaf condition for `relativeDifferentialsPresheaf` (the
  iter-112+ `_isSheafUniqueGluing_type`, `_isSheafOpensLeCover_type`,
  `_isSheaf_type`, `_isSheaf` chain, and the sheaf-bundled
  `relativeDifferentials`).
- The universal derivation `universalDerivation` (depended on the
  deleted sheaf form).
- All cotangent-exact-sequence machinery: `cotangentExactSeqAlpha`,
  `cotangentExactSeqBeta`, `cotangentExactSeqBeta_hη`,
  `cotangentExactSeq_structure`, `cotangent_exact_sequence`.
- `cotangent_at_section`.
- `serre_duality_genus` and the supporting `moduleKPresheafOfModules*`
  / `moduleKSheafOfModules` family (used only by Serre duality).

The chapter `Differentials.tex` must match. Trim the chapter
correspondingly.

## Required content

The chapter must now describe **only** the surviving Lean content.
The recommended structure:

### Section 1: The relative cotangent presheaf

- Keep `def:relative_kaehler_presheaf` (the
  `relativeDifferentialsPresheaf` definition block) — this declaration
  is unchanged in Lean.
- Keep `\begin{remark}[Comparison with Mathlib's ring-level
  $\Omega_{B/A}$]` (the `rem:kahler_compatibility` block) — still
  accurate.
- ADD a new lemma block for `relativeDifferentialsPresheaf_obj_kaehler`
  (currently described in the chapter only implicitly via the
  comparison remark; promote to a numbered lemma with a `\lean{...}`
  hint matching the Lean name
  `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler`).
  Proof: "by `rfl`, after unfolding the
  `relativeDifferentials'` Mathlib construction."

### Section 2: Smoothness and local freeness of Ω (refactored)

- REWRITE the existing
  `\section{Smoothness criterion for $\Omega_{X/S}$}` to match the
  new presheaf-form statement of `smooth_iff_locally_free_omega`. The
  refactored Lean signature is:

  ```lean
  theorem smooth_iff_locally_free_omega (f : X ⟶ S)
      (hfp : AlgebraicGeometry.LocallyOfFinitePresentation f) (n : ℕ) :
      AlgebraicGeometry.IsSmoothOfRelativeDimension n f ↔
        ∀ (x : X), ∃ (U : X.Opens), x ∈ U.1 ∧ IsAffineOpen U ∧
          let R := X.ringCatSheaf.presheaf.obj (.op U)
          let M := (relativeDifferentialsPresheaf f).presheaf.obj (.op U)
          Module.Free (↑R) (↑M) ∧ Module.rank (↑R) (↑M) = n
  ```

- The chapter should present this as the **textbook smoothness
  criterion** for finitely-presented morphisms, with a proof sketch
  detailed enough for a prover. Suggested structure:

  - **Statement informally**: "A locally-of-finite-presentation
    morphism `f : X → S` is smooth of relative dimension `n` if and
    only if the relative cotangent presheaf `Ω_{X/S}` is locally free
    of rank `n` on an affine basis of `X`."

  - **Forward direction**: on every affine open `U ⊆ X` with
    `f(U) ⊆ V` affine in `S`, the smoothness hypothesis
    `IsSmoothOfRelativeDimension n f` translates via
    `AlgebraicGeometry.isSmoothOfRelativeDimension_iff` [verified]
    (`Mathlib.AlgebraicGeometry.Morphisms.Smooth`) to the algebra-side
    property
    `Algebra.IsStandardSmoothOfRelativeDimension n
    A B` for `A = O_S(V)`, `B = O_X(U)`. This produces a free basis
    on `Ω_{B/A}` of rank `n` via
    `Algebra.IsStandardSmoothOfRelativeDimension.basis_kaehlerDifferential`
    [verified] together with
    `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
    [verified] (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`).
    By the definition of `relativeDifferentialsPresheaf` on affine
    opens (Lemma~\ref{lem:relative_kaehler_presheaf_obj} restating
    the iter-117 added `relativeDifferentialsPresheaf_obj_kaehler`),
    `Ω_{X/S}(U) = Ω_{B/A}` and the basis transfers verbatim.

  - **Converse direction**: assume locally on the affine basis the
    presheaf section `(relativeDifferentialsPresheaf f).presheaf.obj
    (.op U) = Ω_{B/A}` is a free `B`-module of rank `n`. By
    `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`
    [verified] (`Mathlib.RingTheory.Smooth.StandardSmoothOfFree`),
    this is equivalent to `B` being standard-smooth as an
    `A`-algebra **conditional on the formal-smoothness hypothesis
    `Subsingleton (Algebra.H1Cotangent A B)`**. The genuine
    deformation-theoretic content of the converse is this
    formal-smoothness condition; the project's local-freeness
    hypothesis combined with the locally-of-finite-presentation
    hypothesis on `f` supplies the H1Cotangent vanishing.
    Combined with
    `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`
    [verified] this gives
    `Algebra.IsStandardSmoothOfRelativeDimension n A B`, which lifts
    to `IsSmoothOfRelativeDimension n f` chart-by-chart via
    `isSmoothOfRelativeDimension_iff` (the same translation lemma in
    the reverse direction).

  - **Mathlib name summary**: the three [verified] closure lemmas
    are
    `Algebra.IsStandardSmoothOfRelativeDimension.basis_kaehlerDifferential`,
    `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`,
    `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`,
    `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`,
    and the algebra-to-scheme bridge
    `AlgebraicGeometry.isSmoothOfRelativeDimension_iff`.

### Sections to DELETE

Remove entirely:

- `\section{The sheaf of relative differentials}` covering the
  sheaf condition (`lem:relative_kaehler_isSheafUniqueGluing`,
  `thm:relative_kaehler_isSheaf`, `def:relative_kaehler_sheaf`).
  These declarations no longer exist in Lean.
- `\section{Universal derivation}` covering
  `def:universal_derivation`.
- `\section{The cotangent exact sequence}` covering the
  cotangent-exact-sequence machinery
  (`def:cotangentExactSeqAlpha`,
  `def:cotangentExactSeqBeta`,
  `lem:cotangent_exact_structure`,
  `thm:cotangent_exact_sequence`,
  and the surrounding helper lemmas
  `lem:sheafOfModules_exact_iff_stalkwise`,
  `lem:sheafOfModules_epi_of_epi_presheaf`,
  `lem:derivation_postcomp_comp`,
  `lem:cotangentExactSeqBeta_hη`).
- `\section{Cotangent space at a section}` covering
  `thm:cotangent_at_section`.
- `\section{Serre duality genus equality}` covering
  `thm:serre_duality_genus` and any supporting `moduleK*` blocks.

After deletion, the chapter should be a focused ~3-section
exposition: introduction + presheaf of differentials + smoothness
criterion. Total chapter length should drop from current ~400+ lines
to ~120–180 lines.

### ADD: out-of-scope disclosure section at the end

Append a short final section titled `\section{Content out of
autonomous-loop scope}` listing the trimmed declarations and the
Mathlib infrastructure their reinstatement would require. Each
bullet should be one or two sentences, naming the trimmed concept,
the missing Mathlib piece, and one cross-reference (Hartshorne
chapter or Stacks tag) for forward-looking reference. Bullets:

- **Sheaf condition for $\Omega_{X/S}$**: no off-the-shelf Mathlib
  bridge packages "`Scheme.PresheafOfModules`-sheaf-on-affine-basis
  ⇒ sheaf on $X$". The cofinality descent against
  `TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover` is hand-rolled
  work outside autonomous-loop scope. Cross-reference: Hartshorne
  II.5 (sheaves from affine charts).

- **Cotangent exact sequence**:
  $f^*\Omega_{Y/S} \to \Omega_{X/S} \to \Omega_{X/Y} \to 0$
  for a composition $X \to Y \to S$. The exactness conjunct requires
  `SheafOfModules.exact_iff_stalkwise` (Mathlib gap; the algebra-side
  ingredients exist but the sheaf-side wrapper does not). Cross-
  reference: Hartshorne II.8.

- **Cotangent space at a section**: corollary of the smoothness-iff,
  pulled back along the section. Trimmed because `Scheme.Modules.pullback`
  on the sheaf-bundled `relativeDifferentials` was the natural Lean
  framing; a presheaf-form analogue would require a separate
  formulation against `PresheafOfModules.pullback`. Out of
  autonomous-loop scope.

- **Serre duality genus identity**:
  $\dim_k H^0(C, \Omega_{C/k}) = \dim_k H^1(C, \mathcal O_C)$ on a
  smooth proper geometrically integral curve. Mathlib `b80f227`
  has no dualizing sheaf, no trace morphism for proper morphisms,
  and no Zariski coherent cohomology of `O_X`-modules. Cross-
  reference: Hartshorne III.7.

## Out of scope

- Do NOT keep any declaration block whose `\lean{...}` target was
  deleted by the refactor.
- Do NOT modify `Genus.tex` (separate concern).
- Do NOT modify any other chapter.
- Do NOT add `\notready` markers; the project's marker convention is
  documented in CLAUDE.md and `\leanok` is managed deterministically
  by `sync_leanok`.

## References

- `STRATEGY.md` — see the "What ships unconditionally" and "What is
  being removed this loop" sections for the trim rationale.
- The refactor agent's task_result `task_results/refactor-trim-iter117.md`
  will contain the exact diff of what was deleted; consult it
  before finalising your chapter if there is ambiguity about which
  Lean declarations survive.
- Hartshorne II for the cotangent / differentials background.
- `Mathlib.RingTheory.Smooth.StandardSmoothCotangent` and
  `Mathlib.RingTheory.Smooth.StandardSmoothOfFree` for the verified
  closure lemmas.

## Expected outcome

A focused, textbook-quality chapter on the relative cotangent
presheaf and the smoothness criterion. The proof sketch for
`thm:smooth_iff_locally_free_omega` is a paragraph-per-direction
exposition naming five verified Mathlib lemmas, sufficient for a
prover to formalize without further blueprint-writer rounds. The
out-of-scope disclosure section honestly documents what was
trimmed and the Mathlib infrastructure its reinstatement would
need.
