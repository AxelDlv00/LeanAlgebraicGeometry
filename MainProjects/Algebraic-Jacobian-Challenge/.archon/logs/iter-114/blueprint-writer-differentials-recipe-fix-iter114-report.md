# Blueprint Writer Report

## Slug
differentials-recipe-fix-iter114

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Differentials.tex

## Changes Made

- **Revised** proof body of `\lem:relative_kaehler_isSheafUniqueGluing` (label `lem:relative_kaehler_isSheafUniqueGluing`, was at chapter L35–L86, now L35–L133). Replaced the three-step recipe whose Step 1 used the universal derivation $d \colon \mathcal O_X \to \Omega_{X/S}$ as if it had a left inverse (mathematically not-well-defined, per the iter-114 Mathlib analogist's must-fix audit) with the analogist-corrected affine-basis + cofinality-descent recipe. New proof body has structure:
  - **Step 1 (Affine-basis sheaf condition):** identifies $F = (\Omega_{X/S})^{\sharp}$ on the basis of basic opens $D(g) \subseteq V_\alpha = \mathrm{Spec}\,B_\alpha$ of each affine chart with the basis-restriction of Mathlib's quasi-coherent module sheaf $\widetilde{\Omega_{B_\alpha/A_\alpha}}$ via `KaehlerDifferential.isLocalizedModule_map` (with `Submonoid.powers g`) — or equivalently via `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale` applied to the formally-étale localisation map `B_\alpha → B_\alpha[1/g]` (formally-étale by `Algebra.FormallyEtale.of_isLocalization`). The sheaf $\widetilde{\,\cdot\,}$ is `AlgebraicGeometry.Modules.tilde`; its built-in `isSheaf` field furnishes the sheaf property on each $V_\alpha$.
  - **Step 2 (Hand-rolled cofinality descent):** refines the original family $U \colon \iota \to \mathrm{Opens}(X)$ to a basis-indexed cover $U'$ via $U_i \cap V_\alpha \cap D(g)$, notes cofinality of $U'$ in $U$ inside the `OpensLeCover`-comma category (using `AlgebraicGeometry.Scheme.isBasis_affineOpens` + `Opens.isBasis_iff_nbhd`), gluing the restricted compatible family via the $\widetilde{\,\cdot\,}$-sheaf property on each $V_\alpha$ and transferring back along cofinality. Structural target named: `TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover` + `TopCat.Presheaf.isSheaf_iff_isSheafUniqueGluing_types` (four-form equivalents — the lemma is stated in unique-gluing form for the Lean target).
  - **Explicit `[gap]` callout** (between Steps 2 and 3, as directive required): "No off-the-shelf Mathlib lemma packages `Scheme.PresheafOfModules`-sheaf-on-affine-basis ⇒ sheaf on X; the cofinality descent above is hand-rolled this iter, and the iter-115 prover must build it inline" — with citation to the iter-114 Mathlib analogist's audit (`Functor.IsCoverDense`, `IsDenseSubsite`, 1-hypercover-dense infrastructure all considered and rejected as off-the-shelf bridges).
  - **Step 3 (Uniqueness):** if $s, s' \in F(\bigvee_i U_i)$ both restrict to $sf_i$ on each $U_i$, then $s - s'$ restricts to zero on each $U_i$, hence (by Step 1 affine-basis identification) on each $D(g) \subseteq U'_j$, hence on $\bigvee_j U'_j = \bigvee_i U_i$ by $\widetilde{\,\cdot\,}$-sheaf property on each affine chart. Equivalent uniqueness argument runs through `TopCat.Presheaf.Sheaf.eq_of_locally_eq` reduced via `KaehlerDifferential.span_range_derivation` to spanning generators.

## Cross-references introduced
None new. The `\uses{def:relative_kaehler_presheaf, def:universal_derivation}` clause on the proof block is preserved from before; both labels already exist in this chapter (L15 and L132).

## Macros needed (if any)
None. All identifiers (`\Spec`, `\struct{X}`, `\Omega_{X/S}`, `\Jac`, `\widetilde`, etc.) were already in use elsewhere in this chapter.

## Reference-retriever dispatches (if any)
None. Per the directive, all Mathlib names used in the corrected recipe are already verified by the iter-114 analogist (see `analogies/affine-basis-sheaf-bridge.md`). No retriever needed.

## Notes for Plan Agent

- **Preserved as instructed:** the lemma statement block (L20–L33, including statement-line `\leanok`) is untouched; the `\thm:relative_kaehler_isSheaf` proof block (now L143ff., the Option (i) delegation written by the earlier iter-114 writer); the QC-softening in `\def:relative_kaehler_sheaf`; the Serre-duality prose; and all stale-NOTE removals from the earlier writer remain intact. The `cotangent_exact_structure` proof body's iter-086/087 NOTE (chapter L180) was *not* in scope and remains untouched (it concerns a different open obligation tracked separately).
- **Lean docstring not touched:** the iter-113 docstring at `AlgebraicGeometry/Differentials.lean` L148–L167 still describes the wrong recipe; per the directive, fixing the Lean-side comment is the iter-115 prover's job. The plan agent may want to flag this in the iter-115 prover's directive so the prover knows the docstring will need updating alongside the proof.
- **No off-the-shelf bridge — load-bearing fact for iter-115 prover.** The `[gap]` callout in Step 2 is honest about the descent being hand-rolled; the iter-115 prover should be told *not* to look for a Mathlib lemma that closes the affine-basis-to-X gap, and should plan budget for building the cofinality descent inline. The analogist's recommendation in `analogies/affine-basis-sheaf-bridge.md` (Recommendation §2) explicitly confirms that switching to `PresheafOfModules.sheafification` or to a `tilde`-glue-on-affine-cover construction would not bypass this gap — both alternatives have comparable workload.
- **Chapter still valid LaTeX:** `\begin{proof}` / `\end{proof}` balanced, all `\texttt{...}` and math-mode braces balanced, no dangling sectioning commands.

## Strategy-modifying findings
(none)

The chapter content is now consistent with the iter-114 analogist's verified-Mathlib-names recipe. No strategy-level adjustment is required beyond what the iter-114 strategic-critic + analogist audits have already surfaced (the iter-113 unique-gluing pivot remains the correct framework; only the *recipe* described in the proof body needed correction).
