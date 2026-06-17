# Lean ↔ Blueprint Check Report

## Slug

g0bo-iter166

## Iteration

166

## Files audited

- Lean: `AlgebraicJacobian/Genus0BaseObjects.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`
  (consolidated chapter, also covers `AbelianVarietyRigidity.lean` via `% archon:covers`)

## Per-declaration

Only two `\lean{...}` hooks in the chapter resolve into this file. (All other chapter hooks resolve into `AbelianVarietyRigidity.lean`.)

### `\lean{AlgebraicGeometry.ProjectiveLineBar}` (chapter: `def:genus0_base_objects`, L913)

- **Lean target exists**: yes — `def ProjectiveLineBar` at L108.
- **Signature matches**: yes. Returns `Over (Spec (.of kbar))`, encoded as `(ProjectiveLineBarScheme kbar).asOver (Spec (.of kbar))` where `ProjectiveLineBarScheme = Proj` of the standard ℕ-graded `MvPolynomial (Fin 2) kbar` (L94). The chapter pins "Mathlib: projective space, or `Proj` of the graded polynomial ring" (L922–923); the Lean uses the `Proj` route, consistent with the chapter's allowed alternatives. The `Over (Spec k̄)` overhead is exactly the chapter's working category.
- **Proof follows sketch**: N/A (a definition).
- **Notes**: The chapter's `def:genus0_base_objects` block *bundles* three definitions (`ProjectiveLineBar`, `Ga`, `Gm`) but pins only `ProjectiveLineBar` via `\lean{...}`. The chapter prose names `Ga` and `Gm` only with parenthetical "[expected]" annotations (L929, L934), which are not real `\lean{...}` hooks. The three distinguished `k̄`-points `0`, `1`, `∞` (L924) are described in prose but also unhooked. See "Blueprint adequacy" and the §iter-165 coverage gap below.

### `\lean{AlgebraicGeometry.gmScalingP1}` (chapter: `def:gaTranslationP1`, L944)

- **Lean target exists**: yes — `def gmScalingP1` at L437.
- **Signature matches**: yes. The Lean returns `ProjectiveLineBar kbar ⊗ Gm kbar ⟶ ProjectiveLineBar kbar`, i.e. a **bare** `Over (Spec k̄)`-morphism (not an `IsAction`/`MulAction` typeclass — consistent with the chapter's "(genuine total morphism, M\"obius scaling fixing $0$ and $\infty$)" framing, L957–959). The base-and-codomain shape matches the chapter's σ_×: `ℙ¹ × 𝔾_m → ℙ¹`.
- **Proof follows sketch**: N/A — body is `:= sorry` (L439). The chapter's chartwise prescription at L960–965 (`(x, λ) ↦ λx` on `𝔸¹ × 𝔾_m`; `u/λ` near `∞`; gluing via `Scheme.Cover.glueMorphisms`) is mathematically detailed enough to guide a prover, and the Lean docstring (L431–436) mirrors this exact prescription. **See "Red flags" — placeholder body on a chapter-pinned substantive declaration.**
- **Notes**: The chapter block bundles `gmScalingP1` (primary) and `gaTranslationP1` (demoted). Only `gmScalingP1` is in this file (and only `gmScalingP1` has a `\lean{...}` hook — `gaTranslationP1` is mentioned with the "[expected]" annotation only and is not yet declared in the Lean).

## Red flags

### Placeholder / suspect bodies

- **`AlgebraicGeometry.gmScalingP1` at L437–439**: body is `:= sorry`. The chapter's `def:gaTranslationP1` block pins this via `\lean{...}` AND substantively describes it (the total chartwise morphism, the two fixed points, the left-action laws — L955–972). Per the directive this is a **CRITICAL, deferred** scaffold (chartwise glue to be landed iter-167+), but by the verbatim must-fix-this-iter rule it is a placeholder body on a chapter-pinned substantive declaration. Surface it; the plan tracker already knows it is plan-marked deferred.
- **`AlgebraicGeometry.gm_grpObj` at L400**: body is `:= sorry`. **CRITICAL, deferred** (live consumer of the iter-167+ `morphism_P1_to_grpScheme_const` proof refactor — the `𝔾_m`-scaling shortcut applies `hom_additive_decomp_of_rigidity` with `W = Gm`). Not strictly pinned with a per-decl `\lean{...}` hook (the chapter only pins `Gm`'s parent definition via the bundle block — and that hook only names `ProjectiveLineBar`); but the chapter prose at L932–934 substantively claims `Gm` is the multiplicative group object with the group law $(x, y) \mapsto xy$, identity $1$, which is the content of `gm_grpObj`. Plan-marked deferred per the directive.
- **`AlgebraicGeometry.gmScalingP1_collapse_at_zero` at L452–456**: body is `:= sorry`. **CRITICAL, deferred**. Not pinned with a per-decl `\lean{...}` hook; the chapter prose at L969–972 and again at L1094–1097 / L1253–1260 substantively claims this fixed-point property ("$\sigma_\times(0, \lambda) = 0$ for all $\lambda$ … the $W$-axis restriction collapses"). The Lean signature precisely encodes the chapter's "$\mathtt{lift}(\mathtt{toUnit} \fatsemi 0,\ \mathbf 1) \fatsemi \sigma_\times = \mathtt{toUnit} \fatsemi 0$" shape (this is the `_hf` consumer of Cor 1.5). Plan-marked deferred per the directive.
- **`AlgebraicGeometry.ga_grpObj` at L335**: body is `:= sorry`. **Off-path scaffold** per the Lean docstring (L332–334) — `Ga` does not appear on the genus-0 critical path (the `𝔾_m`-scaling shortcut uses `W = Gm`, not `W = Ga`). The chapter classifies `Ga` and `gaTranslationP1` as the *demoted* additive route (L985–988, L1117–1118). Not pinned with a per-decl `\lean{...}` hook. Acceptable scaffold; included for completeness.
- **`AlgebraicGeometry.projectiveLineBar_geomIrred` at L175–177**: body is `:= sorry`. **Off live-consumer path for the genus-0 close**: Mathlib does not ship `GeometricallyIrreducible` for `Proj`, plan-marked acceptable for iter-165 per the Lean docstring. The chapter at L921–923 mentions "smooth proper geometrically irreducible curve of genus $0$" without a per-decl hook.
- **`AlgebraicGeometry.projectiveLineBar_smoothOfRelDim` at L182–184**: body is `:= sorry`. Same shape as `projectiveLineBar_geomIrred` — Mathlib does not ship `SmoothOfRelativeDimension 1` for `Proj`; plan-marked acceptable for iter-165.

### Excuse-comments

None. Every `sorry` is documented in its docstring as a plan-marked scaffold with an explicit iter rationale and clearly-named follow-up scope; the language is "scaffold body for iter-166+", "off-path for the genus-0 closure", or "deferred (CRITICAL)", not "we use a wrong def for now" / "will fix later" excuse-style.

### Axioms / Classical.choice on non-trivial claims

None. No `axiom` declarations in the file. (The file uses `noncomputable def`/`noncomputable section` for the `Proj`-side helpers, which is unrelated to the axiom-hygiene concern.)

## Unreferenced declarations (informational)

Per-decl `\lean{...}` coverage of this file in the chapter: **2/~34** top-level declarations are pinned (`ProjectiveLineBar`, `gmScalingP1`). Many of the unreferenced declarations are *structural* helpers that genuinely belong in the file but not the chapter (the `Scheme`/`Over` plumbing layer). The substantively-claim-carrying unreferenced declarations are:

- `ProjectiveLineBar.zeroPt` (L268, **new this iter**), `ProjectiveLineBar.onePt` (L274, **new this iter**), `ProjectiveLineBar.inftyPt` (L280, **new this iter**) — substantively claimed by the chapter at L924 ("the distinguished $\bar k$-points $0$, $1$, $\infty$"). These are exactly the iter-165 per-decl gap flagged previously; they remain **unhooked** in iter-166.
- `Ga` (L300), `Gm` (L365) — substantively claimed by the chapter at L927–934 (as the additive and multiplicative group objects). Chapter uses parenthetical "[expected]" annotations rather than `\lean{...}` hooks.
- `Gm.onePt` (L411) — the group-object unit of `Gm`, named "1" in the chapter at L933 alongside "identity $1$".
- `ga_grpObj` (L335), `gm_grpObj` (L400) — substantively claimed by the chapter at L928–929 and L932–934 (the group-object structures).
- `gmScalingP1_collapse_at_zero` (L452, **new this iter**) — substantively claimed by the chapter at L969–972 (the fixed-point property of σ_×) and again on the critical path at L1094–1097 / L1253–1260. This is the iter-165 per-decl gap flagged previously; remains **unhooked** in iter-166.

The remaining unreferenced declarations (the four canonical-`Over` instances, the underlying `Scheme` definitions `ProjectiveLineBarScheme` / `GaScheme` / `GmScheme`, the grading abbrev + its `GradedRing` instance, `projectiveLineBar_isProper`, `gm_isAffine`, the `IsAffineHom`/`LocallyOfFinitePresentation`/`IsReduced` instances on `Ga` and `Gm`, `ga_smooth` / `gm_smooth`, and the private `evalIntoGlobal`/`irrelevant_map_eq_top`/`pointOfVec` helpers) are plumbing/instances/private helpers and are acceptable as unhooked.

### Privacy of `pointOfVec` and supporting helpers (per directive (D))

- `ProjectiveLineBar.evalIntoGlobal` (L199) — `private noncomputable def`. ✓
- `ProjectiveLineBar.irrelevant_map_eq_top` (L207) — `private lemma`. ✓
- `ProjectiveLineBar.pointOfVec` (L234) — `private noncomputable def`. ✓

The chapter correctly does not expose any of these helpers; they are not named in chapter prose, and no `\lean{...}` block points at them. Privacy is correct.

### Unit-coordinate consistency check (per directive (A))

The Lean three k̄-points are built via `pointOfVec` with explicit evaluation vectors:

- `zeroPt = pointOfVec (fun i => if i = 0 then 0 else 1) 1 _`: `X₀ = 0`, `X₁ = 1`, unit coordinate `X₁`. That is **`[0 : 1]`** — the affine origin in the chart `x = X₀/X₁`. ✓
- `onePt = pointOfVec (fun _ => 1) 0 _`: `X₀ = 1`, `X₁ = 1`. That is **`[1 : 1]`** — the affine unit in the chart `x = X₀/X₁`. ✓
- `inftyPt = pointOfVec (fun i => if i = 0 then 1 else 0) 0 _`: `X₀ = 1`, `X₁ = 0`, unit coordinate `X₀`. That is **`[1 : 0]`** — the point at infinity (the unique point with `X₁ = 0`). ✓

The chapter (L924–926) describes the affine chart `x = X₀/X₁` ("$\mathbb A^1 = \mathbb P^1 \setminus \{\infty\}$, coordinate $x$") and the chart-near-$\infty$ with `u = 1/x`. In these conventions the Lean's `[0:1]`, `[1:1]`, `[1:0]` correspond exactly to `x = 0`, `x = 1`, `x = ∞` (the chapter's "distinguished $\bar k$-points $0$, $1$, $\infty$"). The unit-coordinate convention matches.

The construction technique itself — feeding a `Fin 2 → kbar` evaluation vector with a `IsUnit` certificate at one coordinate into `Proj.fromOfGlobalSections`, with the irrelevant-ideal-maps-to-top condition discharged by the unit-coordinate hypothesis — is mathematically faithful to the standard textbook account of `k̄`-points of `Proj k̄[X₀, X₁]` and is what the chapter would prescribe at this level of detail (though the chapter does not spell out the `Proj.fromOfGlobalSections` mechanism — that formalization detail correctly lives in the Lean docstring, L188–195, L229–233).

## Blueprint adequacy for this file

- **Coverage**: 2/~34 Lean declarations have a corresponding `\lean{...}` block. Unreferenced declarations: ~24 structural helpers (acceptable) + 8 substantive (flagged above — the three k̄-points, `Ga`/`Gm`/`Gm.onePt`, `ga_grpObj`/`gm_grpObj`, `gmScalingP1_collapse_at_zero`).
- **Proof-sketch depth**: **adequate for the live-consumer scaffolds, under-specified for the missing per-decl hooks**.
  - `gmScalingP1`: chapter L960–965 gives the chartwise prescription exactly at the level a prover needs (polynomial map on `𝔸¹ × 𝔾_m`, `u/λ` near `∞`, gluing via `Scheme.Cover.glueMorphisms`). ✓
  - `gm_grpObj`: chapter L932–934 names the group law $(x, y) \mapsto xy$, identity $1$ — mathematically sufficient. Implementation detail (`GrpObj.ofRepresentableBy` + units functor + `IsLocalization.Away`-Spec representable-by) is in the Lean docstring (L389–399), not in the chapter; for a prover this is borderline — the chapter alone would not pin a specific Mathlib install path. Recommend the chapter add a one-line implementation hint or a per-decl `\lean{...}` block under a "the group-object structures" sub-definition.
  - `gmScalingP1_collapse_at_zero`: the **statement** is fully pinned by chapter prose (L1094–1097: "$\lambda \mapsto h_\times(0, \lambda) = f(\lambda \cdot 0) = f(0)$"; L1253–1258: "$\sigma_\times(0, \lambda) = 0$ for all $\lambda$, so the $W$-axis restriction $g$ is the *constant* morphism at $0_A$"). The **proof** sketch — "reduces to a chart-level computation: on `𝔸¹ × 𝔾_m`, `(0, λ) ↦ λ·0 = 0` is a defequal ring-map check" (Lean docstring L450–451) — is not in the chapter. Acceptable mathematically (a one-line computation) but a one-line chapter pin to "`gmScalingP1_collapse_at_zero` discharges the $W$-axis-collapse hypothesis `_hf` of `hom_additive_decomp_of_rigidity` (Cor 1.5)" would help the prover lane.
  - Three k̄-points: chapter prose L924 says "distinguished $\bar k$-points $0$, $1$, $\infty$" — adequate as math. Pinning to `\lean{AlgebraicGeometry.ProjectiveLineBar.zeroPt/onePt/inftyPt}` would close the iter-165 per-decl gap.
- **Hint precision**: **precise where pinned**, **loose where unpinned** (the chapter uses parenthetical "[expected]" annotations in place of `\lean{...}` hooks for `Ga`, `Gm`, `gmScalingP1`, `gaTranslationP1` — the `gmScalingP1` hook *is* present, but `Ga`/`Gm` remain "[expected]" only). No "wrong" hints — the one declaration whose `\lean{...}` resolves into this file (`gmScalingP1`) does so to a correct target.
- **Generality**: **matches need**. The chapter's `def:genus0_base_objects` block correctly works in `Over (Spec k̄)` (the Lean working category) and the chapter's σ_× signature `ℙ¹ × 𝔾_m → ℙ¹` matches the Lean's `ProjectiveLineBar ⊗ Gm ⟶ ProjectiveLineBar` after the `Over`-monoidal-product unfold. No parallel API drift.
- **Recommended chapter-side actions** (for the blueprint-writer subagent):
  - **Re-flag iter-165's per-decl coverage gap as still open in iter-166.** The three k̄-points and `gmScalingP1_collapse_at_zero` are still unhooked. Land per-decl `\lean{...}` blocks for at least:
    - `AlgebraicGeometry.ProjectiveLineBar.zeroPt`, `.onePt`, `.inftyPt` (under `def:genus0_base_objects` as a sub-definition or as a new `def:genus0_kbar_points` block);
    - `AlgebraicGeometry.gm_grpObj` (and, for completeness, `ga_grpObj`) — under `def:genus0_base_objects` or a new `def:genus0_groupObj_structures` block;
    - `AlgebraicGeometry.gmScalingP1_collapse_at_zero` — under `def:gaTranslationP1` as a companion lemma block (e.g. `lem:gmScaling_fixes_zero`).
  - Optionally promote the "[expected]" annotations for `Ga`, `Gm`, `gaTranslationP1` to real `\lean{...}` hooks (the Lean names are now landed for `Ga`, `Gm`; `gaTranslationP1` is still un-declared).

## Severity summary

- **must-fix-this-iter** (1, per the verbatim rule "placeholder body on a chapter-pinned substantive declaration"; the directive explicitly marks it as plan-deferred to iter-167+, so the plan agent's per-file gate may legitimately treat this as already-tracked, not a fresh discovery):
  - `gmScalingP1` body `:= sorry` (L437–439) on the chapter-pinned `\lean{AlgebraicGeometry.gmScalingP1}` (L944).

- **major** (6):
  - Missing `\lean{...}` hooks for `ProjectiveLineBar.zeroPt`, `ProjectiveLineBar.onePt`, `ProjectiveLineBar.inftyPt` (this is iter-165's per-decl coverage gap, **not addressed** in iter-166's chapter update).
  - Missing `\lean{...}` hook for `gmScalingP1_collapse_at_zero` (also iter-165's gap, **not addressed**).
  - Missing `\lean{...}` hook for `gm_grpObj` (the iter-167+ live consumer for `morphism_P1_to_grpScheme_const`; chapter-prose-substantive but unpinned).
  - Missing `\lean{...}` hooks for `Ga` and `Gm` (chapter currently uses "[expected]" placeholders rather than `\lean{...}` hooks; Lean names are now landed and should be pinned).
  - Implementation-level hint precision for `gm_grpObj`: chapter prose pins the math but not the Mathlib install path (`GrpObj.ofRepresentableBy` + `IsLocalization.Away`-Spec representable-by); a one-line hint at the chapter would tighten guidance for iter-167+.
  - The remaining 5 plan-known scaffold sorries (`gm_grpObj`, `gmScalingP1_collapse_at_zero`, `ga_grpObj`, `projectiveLineBar_geomIrred`, `projectiveLineBar_smoothOfRelDim`) are placeholder bodies on chapter-prose-claimed substantive content; *technically* must-fix per the verbatim rule, but none is pinned via `\lean{...}` (so the rule's strictest reading doesn't directly trigger). Reclassified as major (and per the directive these are plan-marked deferred — already tracked, not a fresh discovery).

- **minor** (1):
  - The chapter's `def:genus0_base_objects` block bundles three definitions under one `\lean{...}` hook; consider splitting into per-decl blocks (`def:projective_line_bar`, `def:ga`, `def:gm`) to reduce coupling and to give the blueprint-doctor a clean per-decl audit.

**Overall verdict.** The iter-166 Lane 2 work landed in this file — the private `pointOfVec` helper plus the three `k̄`-points `zeroPt`, `onePt`, `inftyPt` — is **mathematically faithful and structurally clean**: the unit-coordinate convention matches the chapter's `[X₀ : X₁]` description (zero `= [0:1]`, one `= [1:1]`, infty `= [1:0]`), the helper is correctly `private`, the construction (`Proj.fromOfGlobalSections` + `irrelevant → ⊤` discharge from a unit coordinate) is standard, and no excuse-comments or unauthorized axioms appear. The iter-165 per-decl `\lean{...}` coverage gap (`zeroPt`/`onePt`/`inftyPt` + `gmScalingP1_collapse_at_zero`) **was not closed by the iter-166 chapter update**, and the now-landed `gm_grpObj` consumer + `gmScalingP1_collapse_at_zero` companion also remain unhooked — recommend dispatching the blueprint-writer subagent in iter-167 to land per-decl `\lean{...}` blocks for the genus-0 base objects and the σ_× companion lemma before the prover lane attempts the iter-167+ deferred sorries.
