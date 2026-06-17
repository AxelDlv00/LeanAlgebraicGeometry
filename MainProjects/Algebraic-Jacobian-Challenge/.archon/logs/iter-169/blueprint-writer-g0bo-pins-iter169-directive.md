# blueprint-writer — Add `\lean{...}` pins for iter-168 new infra + refresh stale section

## Slug
g0bo-pins-iter169

## Target chapter
`blueprint/src/chapters/AbelianVarietyRigidity.tex` (consolidated chapter; covers `Genus0BaseObjects.lean` via the top-of-chapter `% archon:covers` directive).

## Background

`iter-168` landed substantive new infrastructure in `AlgebraicJacobian/Genus0BaseObjects.lean`:

1. `projectiveLineBarAffineCover` (L196) — the 2-chart affine open cover of `ProjectiveLineBar.left` via `Proj.affineOpenCoverOfIrrelevantLESpan` with `ι := Fin 2`, `f := ![X 0, X 1]`, `m := ![1, 1]`. Axiom-clean.

2. The chart-ring iso machinery (NEW iter-168 sub-build, not yet mentioned in the chapter):
   - `homogeneousLocalizationAwayToMvPoly` (L280) — forward map `Away 𝒜 (X i) →+* MvPolynomial Unit kbar`.
   - `mvPolyToHomogeneousLocalizationAway` (L303) — inverse map.
   - `homogeneousLocalizationAwayIso` (L378) — the `RingEquiv` packaging.
   These together build a chart-ring iso `Away 𝒜 (X i) ≃+* k̄[u]` where `u = X (otherFin i) / X i`. The forward direction (`aux_right` round-trip) is axiom-clean; the reverse round-trip (`aux_left`) is currently `sorry`.

3. `projectiveLineBar_isReduced` (L719) — NEW axiom-clean substantive closure. Uses `IsReduced.of_openCover` over `projectiveLineBarAffineCover.openCover` + `IsDomain (HomogeneousLocalization.Away 𝒜 (X i))` via `Function.Injective.isDomain` on `algebraMap = .val` (injective by `HomogeneousLocalization.val_injective`).

Per `lean-vs-blueprint-checker g0bo-iter168` (iter-168 report), these are flagged as **major** missing `\lean{...}` coverage; the chapter currently does not pin them or explain why they exist as part of the genus-0 roadmap.

Additionally, the same checker flagged TWO stale `.lean` docstrings (those are Lean-side edits, OUT OF YOUR WRITE-DOMAIN — listed here only for context so you understand why the chapter is being updated now).

## What to do

### Scope (write-domain enforced)

You may edit **ONLY** `blueprint/src/chapters/AbelianVarietyRigidity.tex`. Do NOT edit any `.lean` file (the stale docstrings are out of scope for you).

### Edits to make

Add these new `\lean{...}` pin blocks. Choose appropriate `\label{...}` IDs (consistent with existing chapter convention, e.g. `def:projlinebar_affine_cover`, `def:proj_chart_ring_iso`, `lem:projlinebar_isReduced`) and place them in the most natural section of the chapter — likely a NEW subsection under `def:genus0_base_objects` titled something like "Chart cover and chart-ring iso (formalisation infrastructure)" or similar.

For each new pinned declaration:
- A short informal-prose paragraph (2-6 lines) explaining the mathematical content. Match the project's notation; use macros from `blueprint/src/macros/common.tex`.
- A `\lean{AlgebraicGeometry.<name>}` block with the appropriate label.
- For the chart-ring iso, briefly explain that it identifies the homogeneous-localization away ring with a one-variable polynomial ring — i.e. the standard "affine chart of $\mathbb{P}^1$ is $\mathbb{A}^1$" identification expressed at the homogeneous-localization level.

**Specific blocks to add:**

1. `def:projlinebar_affine_cover` — pinning `AlgebraicGeometry.projectiveLineBarAffineCover`.
   - Prose: "The two-chart affine open cover of $\overline{\mathbb{P}^1}$ via the standard $D_+(X_0)$ and $D_+(X_1)$, built by specialising Mathlib's `Proj.affineOpenCoverOfIrrelevantLESpan` to the index set $\{0, 1\}$ with weights $(1, 1)$."

2. `def:proj_chart_ring_iso` — pinning `AlgebraicGeometry.homogeneousLocalizationAwayIso`.
   - Prose: "For $i \in \{0, 1\}$, the chart-$i$ ring of $\overline{\mathbb{P}^1}$ — i.e. the degree-zero part of the localization of $\overline{k}[X_0, X_1]$ at $X_i$ — is isomorphic to the one-variable polynomial ring $\overline{k}[u]$ where $u = X_{1-i}/X_i$. This is the standard 'affine chart of $\mathbb{P}^1$ is $\mathbb{A}^1$' identification expressed at the homogeneous-localization level."
   - Add a `% NOTE:` LaTeX comment after the prose flagging that the iso's reverse round-trip (`aux_left`) is currently a residual sorry on the Lean side; the iso ships sorry-tainted until that residual closes.

3. `lem:projlinebar_isReduced` — pinning `AlgebraicGeometry.projectiveLineBar_isReduced`.
   - Prose: "$\overline{\mathbb{P}^1}$ is reduced. Proof: by the two-chart affine cover, it suffices to show each chart ring is reduced. The chart-$i$ ring embeds (via the canonical injection $\mathrm{val} : \mathrm{Away}\,\mathcal{A}\,X_i \to \mathrm{Localization}(\mathrm{Away}\,X_i)$) into a polynomial localization, which is a domain — hence each chart ring is a domain, hence reduced."

4. **Pin the residual aux** — also add a minor `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_left}` pin (as `lem:proj_chart_ring_iso_aux_left` or similar) inside the chart-ring iso block. Brief prose: "The reverse round-trip of the chart-ring iso (currently scaffold `sorry` on the Lean side; analogist's surjective-cancel route is the recommended closure path)." This makes the iso's incomplete status visible in the blueprint, which is the honest framing.

### What NOT to do

- Do NOT add `\leanok` or `\mathlibok` markers. Markers are managed by the `sync_leanok` phase (for `\leanok`) and the review agent (for `\mathlibok`). Your output should pin declarations and prose, leaving markers alone.
- Do NOT edit any other chapter.
- Do NOT touch the existing pins for `def:genus0_base_objects` / `def:gaTranslationP1` / `lem:gmScaling_fixes_zero` / the ℙ¹-point pins — they are already correct per the iter-168 blueprint-checker.
- Do NOT add a chapter outline for the gmScalingP1 chart-side morphism construction itself; that infrastructure (chart-side ring maps, glue) is iter-169's prover lane and the chapter prose for it already exists at `def:gaTranslationP1` (where the prose explains the chartwise definition `(x, λ) ↦ λx`).

### Out-of-scope but flagged for the planner (do NOT act on these, the directive lists them for context)

- The lean-vs-blueprint-checker `g0bo-iter168` flagged two stale `.lean` docstrings (`projectiveLineBar_isReduced` at L708-718 and the section-(E) header at L680-696 in `Genus0BaseObjects.lean`). These are Lean-side edits handled by the iter-169 prover lane's hygiene pass, NOT by you.

## Verification before exit

After landing the new blocks, re-read your output and confirm:
- Each new `\lean{...}` pin targets exactly one Lean declaration (use the fully qualified namespace, e.g. `AlgebraicGeometry.projectiveLineBarAffineCover`).
- Every block has a `\label{...}` consistent with chapter conventions.
- No `\leanok` or `\mathlibok` added (markers untouched).
- The new blocks fit naturally in the chapter narrative (likely a new subsection under `def:genus0_base_objects`).
- No existing block was deleted or moved.

Write your report to `task_results/blueprint-writer-g0bo-pins-iter169.md` with: which blocks were added, the labels chosen, and the section placement.
