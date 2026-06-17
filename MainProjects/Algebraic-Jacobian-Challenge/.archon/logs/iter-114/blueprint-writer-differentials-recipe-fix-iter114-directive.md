# Blueprint Writer Directive

## Slug
differentials-recipe-fix-iter114

## Target chapter
blueprint/src/chapters/Differentials.tex

## Strategy context

This is a **follow-up dispatch** to `blueprint-writer-differentials-iter114` (which landed earlier this same iter). That writer faithfully transcribed the iter-113 prover's 3-step closure recipe for `\lem:relative_kaehler_isSheafUniqueGluing` into the chapter. The recipe was subsequently audited by `mathlib-analogist-affine-basis-sheaf-bridge-iter114` (also this iter) and found to contain a **mathematically not-well-defined step** in Step 1.

Specifically, the analogist's Decision 5 finding (`must-fix`):

> Step (1) "project compatible Ω-families to compatible O_X-families via the universal derivation `d`" is **not well-defined**: `d : O_X → Ω_{X/S}` is a multilinear derivation, not invertible; you cannot recover `sf_i` from "a section in `O_X(U_i)`" via `d`'s left inverse because `d` has no left inverse.

The correct recipe (per analogist's `Recommendation` section, grounded in verified Mathlib names) uses **base-change compatibility of Kähler differentials on the affine basis** + **hand-rolled cofinality descent** against `isSheaf_iff_isSheafOpensLeCover` (or, equivalently here, the unique-gluing framework). The cofinality descent is the genuine Mathlib-gap step (no off-the-shelf lemma closes it; the analogist confirmed this).

## Required content

Replace **only the proof body** of `\lem:relative_kaehler_isSheafUniqueGluing` (currently at chapter L35–L86) with the corrected recipe below. **Do not touch** the lemma's statement block (L20–L33), and do not touch any other chapter content (the earlier iter-114 writer's other edits are sound and should remain intact).

### Corrected proof body to land

The new proof block should be approximately:

```latex
\begin{proof}
  \uses{def:relative_kaehler_presheaf, def:universal_derivation}
  Write $F = (\Omega_{X/S})^{\sharp}$ for the underlying type-valued
  presheaf and fix a compatible family
  $(sf_i)_{i \in \iota}$ with $sf_i \in \Omega_{X/S}(U_i)$ as above.
  The proof reduces the unique-gluing claim to an affine-basis-restricted
  sheaf condition that the project supplies by hand, with no off-the-shelf
  Mathlib bridge available.

  \emph{Step 1: Affine-basis sheaf condition.} The scheme $X$ admits the
  canonical basis of affine opens
  \texttt{AlgebraicGeometry.Scheme.isBasis\_affineOpens} [verified]
  (\texttt{Mathlib.AlgebraicGeometry.AffineScheme}). For each affine
  $V_\alpha = \Spec B_\alpha \subseteq X$ lying over an affine
  $W_\alpha = \Spec A_\alpha \subseteq S$ and each basic open
  $D(g) \subseteq V_\alpha$ (for $g \in B_\alpha$), the presheaf
  satisfies
  \[
    F(D(g)) \;=\; \Omega_{B_\alpha[1/g]/A_\alpha}
    \;\cong\; \Omega_{B_\alpha/A_\alpha} \otimes_{B_\alpha} B_\alpha[1/g],
  \]
  where the isomorphism is the canonical localisation map of
  K\"ahler differentials provided by
  \texttt{KaehlerDifferential.isLocalizedModule\_map} [verified]
  (\texttt{Mathlib.RingTheory.Etale.Kaehler}) applied with multiplicative
  submonoid $\mathrm{Submonoid.powers}\,g$ and target ring
  $B_\alpha[1/g]$. Equivalently the bare existence of this iso is packaged
  as
  \texttt{KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale}
  [verified] applied to $A_\alpha \to B_\alpha \to B_\alpha[1/g]$
  (valid because $B_\alpha \to B_\alpha[1/g]$ is formally \'etale, by
  \texttt{Algebra.FormallyEtale.of\_isLocalization} [verified]).

  Under this identification, the restriction of $F$ to the basis of basic
  opens of $V_\alpha$ matches the basis-restriction of Mathlib's
  quasi-coherent module sheaf $\widetilde{\Omega_{B_\alpha/A_\alpha}}$ on
  $V_\alpha = \Spec B_\alpha$. The sheaf $\widetilde{\,\cdot\,}$ is
  built-in as
  \texttt{AlgebraicGeometry.Modules.tilde} [verified]
  (\texttt{Mathlib.AlgebraicGeometry.Modules.Tilde}); its
  \texttt{isSheaf} field provides the sheaf property as part of the
  construction (internally via
  \texttt{TopCat.Presheaf.isSheaf\_iff\_isSheaf\_comp} applied to
  \texttt{structureSheafInType}). In particular, on the basis of basic
  opens of each affine chart $V_\alpha$ the presheaf $F$ already
  satisfies the equalizer-products / unique-gluing characterisation of
  the sheaf condition — internally to that affine chart.

  \emph{Step 2: Hand-rolled cofinality descent.} For the family
  $U \colon \iota \to \mathrm{Opens}(X)$ refine to a basis-indexed cover
  $U' \colon \iota' \to \mathrm{Opens}(X)$ by intersecting each $U_i$ with
  the affine basis: for each $i$ and each affine $V_\alpha$ that meets
  $U_i$ and each basic open $D(g) \subseteq V_\alpha \cap U_i$, include
  $D(g)$ in the refined family. The refined cover $U'$ is *cofinal* in
  the original cover $U$ inside the \texttt{OpensLeCover}-comma category
  over $\bigvee_i U_i$ — every member of $U'$ sits inside some member of
  $U$, and the basic-open basis is dense in the Opens-topology
  (\texttt{AlgebraicGeometry.Scheme.isBasis\_affineOpens} +
  \texttt{Opens.isBasis\_iff\_nbhd}).

  By Step~1, the family $(sf_i)$ pulls back along the refinement
  $\bigsqcup_j U' j \to \bigsqcup_i U_i$ to a compatible family on
  $U'$ that lies entirely on basic opens of affine charts; by the
  $\widetilde{\,\cdot\,}$-sheaf property on each $V_\alpha$, this
  refined-family compatibility produces a unique gluing on
  $\bigvee_j U' j = \bigvee_i U_i$, yielding a unique section
  $s \in F(\bigvee_i U_i)$. Cofinality in the \texttt{OpensLeCover}
  category guarantees that the equalizer-products condition on $U'$
  transfers back to the original $U$. The structural target of this
  cofinality step is the four-fold equivalent characterisation
  \texttt{TopCat.Presheaf.isSheaf\_iff\_isSheafOpensLeCover} [verified]
  + \texttt{TopCat.Presheaf.isSheaf\_iff\_isSheafUniqueGluing\_types}
  [verified]; the present lemma is stated in the unique-gluing form
  because it is the form the iter-113 Lean target asks for, but the
  load-bearing descent argument is the same in any of the four
  equivalent forms.

  \emph{Step 3: Uniqueness.} If $s, s' \in F(\bigvee_i U_i)$ both
  restrict to $sf_i$ on each $U_i$, then $s - s'$ restricts to zero
  on each $U_i$; by Step~1's affine-basis identification this
  $s - s'$ restricts to zero on each basic open $D(g) \subseteq U' j$
  of the refined cover; by the $\widetilde{\,\cdot\,}$-sheaf property
  on each affine chart, $s - s' = 0$ on the supremum
  $\bigvee_j U' j = \bigvee_i U_i$. The equivalent uniqueness
  argument runs through
  \texttt{TopCat.Presheaf.Sheaf.eq\_of\_locally\_eq} [verified]
  (\texttt{Mathlib.Topology.Sheaves.SheafCondition.UniqueGluing})
  applied to the structure sheaf and reduced via
  \texttt{KaehlerDifferential.span\_range\_derivation} [verified]
  (\texttt{Mathlib.RingTheory.Kaehler.Basic}) to spanning generators.
\end{proof}
```

### Specific gotchas the new proof must avoid

- **Do NOT** write "the universal derivation $d$ projects compatible $\Omega$-families to compatible $\mathcal O_X$-families" or anything of that form. `d` is not invertible; this step is not well-defined. The analogist's audit identified this as the must-fix.
- **Do NOT** route the recipe through `PresheafOfModules.DifferentialsConstruction.isUniversal'` or `ModuleCat.Derivation.desc` as a primary step. Those lemmas are useful but operate on a single ring map; they do not provide the cover-gluing descent the lemma needs.
- **Do** route through the affine-basis identification (`KaehlerDifferential.isLocalizedModule_map` + `AlgebraicGeometry.Modules.tilde`) and the **hand-rolled cofinality descent** against the refinement cover. This is the analogist's verified-Mathlib-names recipe.
- **Do NOT** claim there is an off-the-shelf Mathlib lemma packaging "sheaf-on-affine-basis-of-Scheme ⇒ sheaf". The analogist confirmed this is `NEEDS_MATHLIB_GAP_FILL` — the project must hand-construct the cofinality descent. State this explicitly in Step 2's prose (a one-line `[gap]` callout is appropriate; the iter-115 prover must build this descent inline).

### Other content this directive does NOT change

- The earlier iter-114 writer's other edits (proof of `\thm:relative_kaehler_isSheaf` rewritten as Option (i) delegation; three stale `% NOTE (iter-112 review)` blocks removed; `\thm:serre_duality_genus` prose relaxation; `\def:relative_kaehler_sheaf` quasi-coherence softening) are sound and should be left intact.
- The `\lem:relative_kaehler_isSheafUniqueGluing` **statement block** (chapter L20–L33) is correct as-is. Only the proof block (L35–L86) needs replacement.
- Other chapter sections (Universal property; Cotangent exact sequence; Smoothness section; Serre duality section) are not in scope.

## Out of scope

- Do **NOT** edit any other chapter.
- Do **NOT** touch the Lean file (`AlgebraicJacobian/Differentials.lean`). The iter-113 docstring at L148–L167 in the Lean file is also wrong per the analogist, but fixing it is the iter-115 prover's job (refactor agents own `.lean` edits, not writers; and even refactors are off the schedule this iter).
- Do **NOT** add or remove `\leanok` markers anywhere. The existing markers (statement-line `\leanok` on the new lemma, statement-line `\leanok` on the theorem, etc.) are correct as the earlier writer placed them.
- Do **NOT** dispatch a reference-retriever; all Mathlib names used in the corrected recipe are already verified by the analogist.

## References

- `references/challenge.lean`: authoritative source for the 9 protected declarations.
- `analogies/affine-basis-sheaf-bridge.md` — the analogist's persistent design-rationale file for this exact question. Read it for context if needed.

## Expected outcome

After your edits:

- `\lem:relative_kaehler_isSheafUniqueGluing`'s proof block reads as the analogist-corrected recipe: affine-basis identification via `KaehlerDifferential.isLocalizedModule_map` + tilde + hand-rolled cofinality descent against the four-form sheaf-condition equivalents.
- All other earlier-this-iter writer edits are intact (Option (i) delegation in `\thm:relative_kaehler_isSheaf`; stale NOTE removals; Serre prose; QC softening).
- Chapter is still valid LaTeX.
- A short `[gap]` callout in Step 2 explicitly states "no off-the-shelf Mathlib lemma for `Scheme.PresheafOfModules`-sheaf-from-affine-basis; the cofinality descent is hand-rolled this iter" — so the iter-115 prover and future readers see the honest accounting.
