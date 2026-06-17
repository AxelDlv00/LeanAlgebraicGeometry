# Blueprint Writer Report

## Slug
mv-iter110

## Status
COMPLETE — both blueprint-reviewer-iter110 must-fix issues addressed (L1198 stale 3-tuple gap list → refreshed to 6+1 surface; L1196 substep mis-numbering → re-aligned with the L1167–1176 introduction). Optional `IsLocalizedModule.prodMap` mention added at both L1176 (substep introduction) and L1198 (implementation-status remark).

## Target chapter
blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Changes Made

### 1. L1196 substep re-numbering (fix #2 in directive)
- **Revised** the `\begin{remark}[Implementation status (iter-108 escape-valve)]` prose at `rem:basicOpenCover_step2_status` so that downstream substep references match the introduction at L1167–1176.
  - Before: "Substeps~(i) and~(ii) … (the inclusion $V_x \subseteq U$ and the restriction-of-section identity …), together with substep~(iii) (the image-Finset bridge and the per-coord `IsLocalization.Away` certificate …)" — this shifted labels by one slot relative to the introduction, since per L1167–1176 the image-Finset bridge is (i), restriction-of-section is (ii), and per-coord `IsLocalization.Away` is (iii).
  - After: "Substeps~(i)–(iii) of the Mathlib-API recipe above — the image-Finset bridge of substep~(i), the restriction-of-section identity $V_x \cap D(f) = D(f|_{V_x})$ of substep~(ii), and the per-coord `IsLocalization.Away` certificate via `IsAffineOpen.isLocalization_of_eq_basicOpen` of substep~(iii) — are committed as inline `have`-declarations at lines 1786–1834, together with the auxiliary inclusion $V_x \subseteq U$ that feeds substep~(iii) …".
  - Followed reconciliation option (b) per directive: introduction at L1167–1176 is the source of truth; only the downstream attribution was changed.
  - The "inclusion $V_x \subseteq U$" was re-categorised as an auxiliary side-condition feeding (iii), not a numbered substep — it is not in the L1167–1176 enumeration.

### 2. L1198 named-gap surface refresh (fix #1 in directive)
- **Revised** the trailing parenthetical of `rem:basicOpenCover_step2_status` that previously enumerated the project's Mathlib-gap surface as the 3-tuple `(instIsMonoidal_W, h_exact, nonempty_jacobianWitness)`.
  - Replaced with the post-iter-109 6-entry surface, with a one-clause locator for each entry:
    - `instIsMonoidal_W` (varying-ring `stalk_tensorObj` gap; `Modules/Monoidal.lean:173`)
    - `cotangentExactSeq_structure.h_exact` (sheaf-of-modules exactness criterion; `Differentials.lean:636`)
    - `nonempty_jacobianWitness` (Hilbert/Quot schemes + finite-group quotients; `Jacobian.lean:179`)
    - `PicardFunctor.representable` (gated on Phase~C3; `Picard/Functor.lean:181`)
    - `SheafOfModules.pullback_tensorObj` (the $\mu$-iso of the missing varying-ring `Monoidal` instance; `Picard/LineBundle.lean:82`)
    - `SheafOfModules.pullback_oneIso` (the $\epsilon$-iso of the same; `Picard/LineBundle.lean:96`)
  - The disclosure that the present `BasicOpenCech.lean:1846` `h_loc_exact` sits *outside* that surface (as a budget-deferral, not a Mathlib gap) is preserved verbatim in spirit and reinforced as "the budget-deferral … which sits outside that surface".

### 3. `IsLocalizedModule.prodMap` informational mention (optional ask in directive)
- **Revised** L1176 (substep~(iv) of the introduction) to add a one-clause mention: "with `IsLocalizedModule.prodMap` furnishing the binary-product specialisation" alongside `IsLocalizedModule.pi`. Fits naturally; aligns the prose with the actual iter-109 mechanization plan.
- **Revised** L1198 (implementation-status remark, substep~(iv) recap) likewise: `IsLocalizedModule.prodMap` is now mentioned in the trailing-transport sentence and added to the "Mathlib at the project's pin already contains …" list (between `.pi` and the adapter).

## Cross-references introduced
None. All cross-references in the modified region (`rem:basicOpenCover_step2_status`, references to `thm:Scheme_basicOpenCover_finset_inf_isLocalization` and the `IsAffineOpen.isLocalization_of_eq_basicOpen` Mathlib API piece) were already present; no new `\label{...}` or `\uses{...}` introduced.

## Macros needed (if any)
None. All commands used (`\texttt`, `\emph`, `\mathcal`, `\bigcap`, `\subseteq`, `\to`, `\check`, etc.) and the `$\mu$` / `$\epsilon$` greek letters in the new prose are stock LaTeX / standard math mode.

## Reference-retriever dispatches (if any)
None. The directive supplied the full 6+1 surface with file/line locators; no external source needed.

## Notes for Plan Agent

- **`rem:basicOpenCover_step2_status` title vs. content drift.** The remark's title still says "(iter-108 escape-valve)" but the body now mentions iter-109 partial scaffolding (already present pre-iter-110) and an iter-110 named-deferral surface count. The directive's "out of scope" disallowed restructuring beyond the two precision edits, so I left the title alone — but the plan agent may wish to update the title to "(iter-108 escape-valve, iter-110 status refresh)" in a future iter for consistency.
- **`paragraph{Status (iter-108 / Archon canonical iter-108)}` at L1205.** This is the load-bearing transient-`sorry` enumeration paragraph in the Mayer-Vietoris chapter. It references the six labelled sorries at lines 1120 / 1212 / 1536 / 1564 / 1754 / 1846 of `BasicOpenCech.lean` and explicitly tags the iter as "iter-108 / Archon canonical iter-108". This is informational status (file compiles, downstream consumer flows through), not part of the named-gap surface, and the directive's "out of scope" list specifically named those line numbers as off-limits sub-routes. It should still be reviewed at some point for whether "iter-108" is the right tag in an iter-110 chapter — but I did not touch it this round.
- **`stalk_tensorObj` is described at L1198 as the "varying-ring `Monoidal` instance" missing piece, and `pullback_tensorObj` / `pullback_oneIso` as the $\mu$-iso / $\epsilon$-iso of the same.** This phrasing assumes the reader of this chapter knows the term "varying-ring `Monoidal` instance" — which is a Picard-chapter / Modules-chapter concept. The L1198 phrasing here is intentionally brief (per directive: refresh, don't enumerate body-deep). Plan agent may decide to add a `\uses{...}` pointer to the Picard or Modules chapter from this remark in a future iter, but the directive explicitly forbade cross-chapter edits.

## Strategy-modifying findings
None. Both fixes are pure prose-precision edits against the canonical 6+1 named-deferral surface that the directive supplied; no surfaced strategy-level inconsistency.
