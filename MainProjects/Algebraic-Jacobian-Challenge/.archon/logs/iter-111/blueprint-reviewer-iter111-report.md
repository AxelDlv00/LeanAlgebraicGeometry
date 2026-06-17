# Blueprint Review Report

## Slug
iter111

## Iteration
111

## Top-level summaries

### Incomplete parts
- `Differentials.tex` / `\thm:relative_kaehler_isSheaf` (L20–47): the proof sketch is detailed
  enough to give the prover the shape of the argument, but Step~1 ("Reduction to the affine
  basis of abelian-group sections") under-specifies the **basis-to-opens descent direction**.
  The Lean entry point named for the unique-gluing criterion is
  `TopCat.Presheaf.IsSheaf.isSheafUniqueGluing` (verified existing in Mathlib), but that
  lemma's actual signature converts `IsSheaf → IsSheafUniqueGluing` — i.e.\ the wrong
  direction for the recipe. The blueprint claims the descent step extends "the affine-basis
  sheaf condition" to "all open covers" by this lemma, but Mathlib does not appear to expose
  a direct "presheaf-is-sheaf-on-a-basis ⇒ presheaf-is-sheaf" lemma; the prover will need
  either a non-trivial bridge (TopCat.Sheaf.OnBasis machinery, not named in the sketch) or
  a different recipe. This is the riskiest under-specification for the iter-111 L122 dispatch.

### Proofs lacking detail
- `Differentials.tex` / `\thm:relative_kaehler_isSheaf` Step~2: the "localisation compatibility"
  step names `KaehlerDifferential.isLocalizedModule_map` ✓ and `KaehlerDifferential.tensorKaehlerEquiv`,
  but the actual Mathlib declaration is `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale`
  (carries a `FormallyEtale` hypothesis). Localisations are formally étale, but the proof
  sketch elides this hypothesis. The prover may waste time looking for an unconditional
  `tensorKaehlerEquiv`.
- `Differentials.tex` / `\thm:relative_kaehler_isSheaf` Step~2 final paragraph: the sentence
  "tensoring a B-module with the standard sheaf condition for $\mathcal{O}_V$ over the cover
  $\{D(f_i)\}$ preserves exactness when the cover is finite (or, equivalently, the B-module
  $\Omega_{B/A}$ admits a quasi-coherent extension…)" gives two equivalent recipes but pins
  neither to a concrete Mathlib lemma name. The prover has to invent the descent step from
  scratch. Either route needs a specific named target.
- `Differentials.tex` / `\thm:relative_kaehler_isSheaf` Step~3 last sentence: "the
  unique-gluing axiom on the original cover follows from the refinement's universality" is
  hand-wavy; "refinement's universality" is not a named Mathlib lemma and the prover will
  not know whether `Presieve.IsSheafFor` refinement machinery, `IsSheafUniqueGluing` extension
  machinery, or a project-local helper is intended.

### Lean difficulty quality
- `Differentials.tex` / `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_isSheaf}`
  (target of iter-111 L122 dispatch): signature is unambiguous (the prover sees the
  existing Lean stub at `Differentials.lean:113`); the underspecification flagged above is
  about proof-sketch ingredients, not target shape. Marginal — the target itself is OK.
- All other `\lean{...}` hints scanned: target shapes are clear; no further Lean-difficulty
  findings.

### Multi-route coverage
- Single route per directive. PASS — no multi-route gap to flag.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - L1198 references `Modules/Monoidal.lean:173` for `instIsMonoidal_W` (sorry-line
    convention). Consistent with the directive's authoritative L173. Informational only:
    other chapters (Picard_Functor, Picard_LineBundle) still use L166 (declaration-line);
    see cross-chapter notes.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **HARD GATE blocker for iter-111 L122 dispatch.** `\thm:relative_kaehler_isSheaf`
    proof-sketch Step~1 names `TopCat.Presheaf.IsSheaf.isSheafUniqueGluing` for the
    basis-to-opens descent, but that Mathlib lemma's direction is `IsSheaf → IsSheafUniqueGluing`,
    not the converse the recipe needs. The descent from "sheaf-on-affine-basis" to
    "sheaf-on-arbitrary-open-cover" is the load-bearing step and has no named Mathlib target.
  - `\thm:relative_kaehler_isSheaf` Step~2 names `KaehlerDifferential.tensorKaehlerEquiv`
    but the actual Mathlib declaration is `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale`
    (a `FormallyEtale` hypothesis applies automatically to localisations, but the prose
    omits this).
  - `\thm:relative_kaehler_isSheaf` Step~2 last paragraph ("tensoring a B-module with the
    standard sheaf condition for $\mathcal{O}_V$ over the cover $\{D(f_i)\}$ preserves
    exactness when the cover is finite") and Step~3 last sentence ("refinement's
    universality") are non-named recipes; the prover has to invent the descent.
  - Other declarations on this chapter (L74–172, L184–225) and the dormant-by-design
    lemmas at L126–145 are out of scope per directive.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true
- **correct**: true
- **notes**:
  - L25, L36 NOTE reference `AlgebraicJacobian/Modules/Monoidal.lean:166` for
    `instIsMonoidal_W`; the directive's authoritative line is L173 (the `sorry` itself).
    L166 is the `instance` keyword line — both are valid pointers to the same decl, but
    the within-blueprint convention is inconsistent (see Cohomology_MayerVietoris.tex
    L1198 using L173). Informational only — not blocking the prover dispatch.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - L10 NOTE: "$\mathrm{instIsMonoidal\_W}$ (\texttt{Modules/Monoidal.lean:166})" —
    inconsistent line ref vs directive (L173) and vs Cohomology_MayerVietoris.tex L1198
    (L173). Informational, not blocking.
  - L88 closing paragraph: "exposes \texttt{sorryAx} chains rooted at
    \texttt{Picard/LineBundle.lean:93,\,82} ... \texttt{Modules/Monoidal.lean:166}".
    The `:93` is `Pic.pullback`'s declaration line — internally consistent with the
    note in Picard_LineBundle.tex L62. The `:82` matches the directive (L82 for the
    $\mu$-iso). The `:166` is the L166-vs-L173 inconsistency. Informational only.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**: -

## Cross-chapter notes

- **Line-reference convention drift for `instIsMonoidal_W`.** Three chapters
  (`Picard_Functor.tex` L10/L88, `Picard_LineBundle.tex` L25) use
  `Modules/Monoidal.lean:166` (declaration-line convention). One chapter
  (`Cohomology_MayerVietoris.tex` L1198 in the iter-108 status remark) uses `:173`
  (sorry-line convention). The directive's named-Mathlib-gap list also uses `:173`.
  Picking one and applying it consistently across the blueprint would remove the drift;
  this is informational, not blocking.

- All `\uses{...}` cross-references that I spot-checked resolve to existing labels
  (`def:Pic_functor`, `def:Scheme_LineBundle`, `def:Scheme_HModule`,
  `def:Scheme_toModuleKSheaf`, `def:Scheme_HModule_prime`, `def:IsAlbanese`,
  `thm:nonempty_jacobianWitness`, `thm:cotangent_exact_sequence`, etc.). No broken
  `\uses{...}` detected.

- The `Differentials.tex` proof of `\lem:cotangent_exact_structure` (L106-117) uses
  `\uses{lem:cotangent_exact_seq_beta_hη}` and the cited label `lem:cotangent_exact_seq_beta_hη`
  is defined at L147-156 — internally consistent. The other cited prose-only labels in
  that `\uses{}` (`lem:sheafOfModules_epi_of_epi_presheaf`,
  `lem:sheafOfModules_exact_iff_stalkwise`, `lem:derivation_postcomp_comp`) all resolve
  to the prose-only lemmas at L126-145 — intentionally not formalised this iter per
  directive's Known-issues guidance.

## Strategy-modifying findings (if any)

None.

## Severity summary

- **must-fix-this-iter** — one entry:
  - `Differentials.tex` is `complete: partial` on the proof of
    `\thm:relative_kaehler_isSheaf` (the iter-111 L122 dispatch target). Per the HARD
    GATE rule in the dispatcher notes, the prover for
    `AlgebraicJacobian/Differentials.lean:113` (`relativeDifferentialsPresheaf_isSheaf`)
    **must be deferred** to iter-112 and a blueprint-writer dispatched THIS iter to
    sharpen the proof block on three points:
    (a) name the actual Mathlib lemma effecting the **basis-to-opens descent** direction
        (sheaf-on-affine-basis ⇒ sheaf-on-arbitrary-open) — `IsSheaf.isSheafUniqueGluing`
        is the *wrong direction*; the writer needs to find or specify a different bridge
        (e.g.\ via `TopCat.Sheaf.OnBasis` / `Presheaf.SheafOnBasis` machinery, or via
        `isSheafOpensLeCover`/`isSheafPairwiseIntersections` + a basis refinement step);
    (b) replace `KaehlerDifferential.tensorKaehlerEquiv` with the actual
        Mathlib name `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale` (and note
        the `FormallyEtale` hypothesis applies because localisations are formally étale);
    (c) replace the unnamed "tensoring preserves exactness on a finite cover" /
        "refinement's universality" hand-waves in Step~2 and Step~3 with concrete
        Mathlib lemma names.

- **soon** — none.

- **informational** — line-reference convention drift for `instIsMonoidal_W`
  (`Modules/Monoidal.lean:166` vs `:173`) across three chapters
  (`Picard_Functor.tex` L10 / L88, `Picard_LineBundle.tex` L25). Picking one and
  applying it consistently would remove the drift; not blocking any prover dispatch.

Overall verdict: 13 chapters audited, 1 must-fix-this-iter blocking the iter-111
prover dispatch on `Differentials.lean:113` (`relativeDifferentialsPresheaf_isSheaf`)
plus low-impact line-ref drift across three chapters; the rest of the blueprint is
in good shape for the project's framework-conditional end-state.
