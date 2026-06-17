# Blueprint Writer Report

## Slug
rigiditykbar-iter148

## Status
COMPLETE

## Target chapter
`blueprint/src/chapters/RigidityKbar.tex`

## Changes Made

### Change 1 — surfaced the 7-step closure chain for `constants_integral_over_base_field`

**Revised** the proof body of `\label{lem:constants_integral_over_base_field}` (lines 2006–2018 in the iter-147 file; now lines 2006–2030 in the iter-148 file). Markers `\leanok` on the statement and on the proof body were preserved verbatim; the `% NOTE (iter-146 review)` and `% NOTE (iter-147 review)` blocks inside the lemma statement were left untouched per marker discipline.

What changed:

- Replaced the iter-145 three-substep recipe (the `\begin{enumerate}` block of three items: finite-dim / integral-domain / geom-irr-base-change) with a 7-step closure chain `(a)`–`(g)`, naming each Mathlib hook explicitly. The 7-step chain is the iter-147 prover-lane refinement lifted from the iter-147-review `% NOTE` annotation into the prose body.
- Step `(a)` covers algebraisation of `appTop.hom` + `ΓSpecIso k` and the reduction of the surjectivity goal via `RingHom.range_eq_top`.
- Step `(b)` covers the base change to `\bar k` with all four hypothesis stability instances listed explicitly: `IsProper` (base-change-stable), `Smooth` (base-change-stable), `IsReduced` (via `AlgebraicGeometry.Smooth.isReduced_of_smooth` or the `Algebra.IsGeometricallyReduced` idiom), `IrreducibleSpace` (via `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`).
- Step `(c)` consumes `isField_of_universallyClosed` + `finite_appTop_of_universallyClosed` on `X_{\bar k}`.
- Step `(d)` applies `IsAlgClosed.algebraMap_bijective_of_isIntegral` to identify `Γ(X_{\bar k}, ⊤) ≅ \bar k`.
- Step `(e)` names the substantive Mathlib gap as flat base change of `Γ` for proper schemes — Stacks Tag~02KH specialised to `H^0` (with EGA IV.6 / Hartshorne III.11 as alternative citations). The iter-148 disambiguation is folded in: the gap is genuinely cohomology-base-change-deep (~250–500 LOC if built from scratch), NOT a thin wrapper over `finite_appTop_of_universallyClosed`. The misleading-name observation on `constants_integral` is also surfaced: the Lean signature commits to surjectivity = `Γ ≅ k`, which requires the deeper machinery.
- Step `(f)` applies `Module.finrank_baseChange` to conclude `dim_k Γ(X, O_X) = 1`.
- Step `(g)` applies `Subalgebra.bot_eq_top_iff_finrank_eq_one` to discharge surjectivity.
- Closing paragraph clarifies how `(a)`–`(g)` collapses to the earlier iter-145 three-substep recipe `(1)+(2) = (a)–(d)`, `(3) = (e)–(g)`, so the older framing remains accessible.
- LOC budget bumped per the iter-148 strategy-critic's recommendation: from the earlier `~50–100 LOC` (whole proof) to a split `~50–100 LOC` for `(a)`–`(d)` + `(f)`–`(g)` combined and `~250–500 LOC` for step `(e)` from scratch through the Stacks 02KH chain (with a "substantially less if Mathlib's cohomology-base-change machinery has matured" caveat).
- `\emph{Mathlib status.}` paragraph rewritten to enumerate the Mathlib lemmas hit at each `(a)`–`(g)` step, replacing the prior coarser inventory. The iter-148 disambiguation that step `(e)` is the substantive gap (not a thin wrapper) is also reflected here.

### Change 2 — split the KDM block into alternative `(p2)` / `(p1)` routes

**Revised** the proof body of `\label{lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero}` (lines 2057–2089 in the iter-147 file; now lines 2072–2104 in the iter-148 file). The lemma statement block (with its `\leanok`, `\lean{…}`, `\uses{…}`, and the prior iter-146 / iter-147 NOTE blocks if any) was preserved verbatim. The `\uses{…}` line at the top of the proof block was preserved verbatim.

What changed:

- Replaced the iter-147 char-split structure (`\emph{Characteristic 0 case.}` paragraph + `\emph{Characteristic p > 0 case.}` paragraph with nested `(p1)`–`(p3)` `enumerate`) with a two-alternative-routes presentation: a setup paragraph naming the eventual end-state case-split `if CharZero k then (p2) else (p1)`, followed by `\emph{Primary path (p2) — characteristic-0 via Differential.ContainConstants.}` and `\emph{Alternative path (p1) — characteristic-p via standard-smooth chart presentation.}` blocks.
- Setup paragraph also surfaces the iter-147 finding that `(p2)` is a standalone viable char-0 first-attempt route, not nested under a char-p Frobenius wrapper, and explains the iter-148+ recommended attempt order.
- Primary path `(p2)` is now a standalone paragraph with the typeclass bridge details fully spelled out per the directive: the typeclass is positioned for `Differential B` (a `B → B` derivation), not the universal `D : B → Ω_{B/k}`; the bridge fixes a basis of `Ω_{B/k}` via `Algebra.IsStandardSmooth.free_kaehlerDifferential`, projects `D` to coefficient derivations `∂_i : B → B`, and uses each as a `Differential B` instance. `ContainConstants` of each `∂_i` in characteristic 0 then closes the forward direction with no Frobenius detour, and crucially without consuming `KaehlerDifferential.constants_in_chart_of_proper_curve`. LOC budget: `~80–150 LOC`.
- Alternative path `(p1)` keeps the iter-146 substep chain `(p1.a)`–`(p1.d)` (the standard-smooth chart presentation → `b ∈ B^p`) and adds two further substeps inside the same `itemize`: `(p1.e)` Frobenius iteration via `RingHom.iterateFrobenius_comm` (the old top-level `(p2)`) and `(p1.f)` descent through the chart-of-proper-curve integrally-closed-constants helper (the old top-level `(p3)`). The `(p2)` / `(p3)` labels at the top level are eliminated — the now-`(p2)` label is reserved for the primary char-0 path, and the old `(p3)` content is folded into `(p1.f)`. LOC budgets preserved: `(p1.a)`–`(p1.d)` = `~60–100 LOC`, `(p1.e)` = `~40–80 LOC`, `(p1.f)` = `~40–50 LOC`, `(p1)` total = `~140–230 LOC`.
- Per the directive's minor request: step `(p1.d)` now names `RingHom.iterateFrobenius_comm` for the characteristic-`p` Frobenius-power expansion explicitly (replacing the prior free-text appeal "Frobenius is additive and multiplicative in characteristic `p`"). The companion mention of `Algebra.IsStandardSmooth.free_kaehlerDifferential` (free-module structure on `Ω`) is also threaded into `(p1.d)`'s narrative.
- New closing paragraph `\emph{Closure end state and ordering.}` documents the case-split body shape `if CharZero k then (p2) else (p1)`, the worst-case total LOC `~200–350 LOC`, and the reduced LOC if only the `(p2)` char-0 branch is needed (`~80–150 LOC`). It also notes that `(p1)` / `(p2)` are independent sub-paths that may be formalised in parallel.
- `\emph{Signature-vs-proof reconciliation (iter-146 disposition).}` paragraph updated: the chart-of-proper-curve dependency is now correctly attributed to step `(p1.f)` (was `(p3)`); a new sentence notes that `(p2)` char-0 path does NOT consume the chart-of-proper-curve helper, sharpening the iter-146 (B.preferred) disposition.
- `\emph{Mathlib status.}` paragraph augmented: `Differential.ContainConstants` is now annotated as "the primary `(p2)` closure mechanism"; the `(p2)` typeclass bridge is identified as the substantive `(p2)` build, leveraging `Algebra.IsStandardSmooth.free_kaehlerDifferential` to fix a basis. `RingHom.iterateFrobenius_comm` is annotated as supplying both Frobenius additivity + multiplicativity in `(p1.d)` and the depth-bounded iteration in `(p1.e)`.

## Cross-references introduced

No new `\uses{…}` cross-references were introduced. The pre-existing `\uses{lem:chart_algebra_isPushout_of_affine_product, lem:KaehlerDifferential_constants_in_chart_of_proper_curve}` on the KDM proof block was preserved verbatim. The pre-existing absence of an explicit `\uses{…}` on the `constants_integral_over_base_field` proof body was also preserved (the lemma has no in-chapter dependencies; only Mathlib hooks are referenced, which do not require `\uses{…}`).

Mathlib lemma names referenced inside the revised prose (all are reference text, not blueprint cross-refs):

**Change 1 (`constants_integral_over_base_field`):**
- `RingHom.range_eq_top` (Mathlib `Mathlib.RingTheory.RingHom`)
- `IsProper`-namespace base-change instance, `Smooth`-namespace base-change instance (Mathlib `Mathlib.AlgebraicGeometry`)
- `AlgebraicGeometry.Smooth.isReduced_of_smooth` / `Algebra.IsGeometricallyReduced` (Mathlib `Mathlib.AlgebraicGeometry.Smooth.*` / `Mathlib.RingTheory.IsGeometricallyReduced`)
- `GeometricallyIrreducible.irreducibleSpace_of_subsingleton` (Mathlib `Mathlib.AlgebraicGeometry.GeometricallyIrreducible`)
- `isField_of_universallyClosed`, `finite_appTop_of_universallyClosed` (Mathlib `Mathlib.AlgebraicGeometry.*` `UniversallyClosed`-namespace)
- `IsAlgClosed.algebraMap_bijective_of_isIntegral` (Mathlib `Mathlib.FieldTheory.IsAlgClosed.Basic`)
- `Module.finrank_baseChange` (Mathlib `Mathlib.LinearAlgebra.FiniteDimensional`)
- `Subalgebra.bot_eq_top_iff_finrank_eq_one` (Mathlib `Mathlib.RingTheory.Algebraic`)
- `AlgebraicGeometry.IsBaseChange`-namespace (Mathlib `Mathlib.AlgebraicGeometry.*` — for the step `(e)` gap discussion)
- Stacks Tag~02KH (substantive Mathlib gap citation)

**Change 2 (KDM):**
- `Derivation.map_algebraMap` (Mathlib `Mathlib.RingTheory.Derivation.Basic`)
- `Differential.ContainConstants` (Mathlib `Mathlib.RingTheory.Derivation.DifferentialRing`)
- `Algebra.IsStandardSmooth.free_kaehlerDifferential`, `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` (Mathlib `Mathlib.RingTheory.Smooth.StandardSmoothCotangent`)
- `Algebra.IsStandardSmoothOfRelativeDimension` (Mathlib `Mathlib.RingTheory.Smooth.StandardSmooth`)
- `KaehlerDifferential.D_add`, `KaehlerDifferential.D_mul`, `Derivation.leibniz` (Mathlib `Mathlib.RingTheory.Kaehler.Basic` / `Mathlib.RingTheory.Derivation.Basic`)
- `Subring`-builder boilerplate (Mathlib `Mathlib.RingTheory.Subring.Basic`)
- `RingHom.iterateFrobenius_comm` (Mathlib `Mathlib.Algebra.CharP.Frobenius`) — newly named in `(p1.d)` per the directive's minor request
- `Algebra.IsSeparable.iff_isPurelyInseparable_extension` (Mathlib — too-restrictive variant counterpoint)
- Stacks Tag~07F4 (Cartier-direction `ker D = B^p`)

In-chapter `\cref{…}` references:
- `\cref{lem:chart_algebra_isPushout_of_affine_product}` — already present, preserved.
- `\cref{lem:KaehlerDifferential_constants_in_chart_of_proper_curve}` — already present, preserved; now also explicitly noted as NOT consumed by the `(p2)` char-0 path.
- `\cref{lem:chart_algebra_df_zero_factors_through_constant_on_chart}` — already present in the chart-of-proper-curve descent step, preserved.

## Macros needed (if any)

None. All new prose uses only the same macros already in service in the surrounding chapter prose (`\Spec`, `\bar`, `\mathcal O`, `\Gamma`, `\Omega`, `\mathtt{…}`, `\texttt{…}`, `\cref{…}`, `\emph{…}`, `\operatorname{…}`, etc.) plus stock LaTeX. The `\Updownarrow` symbol in step `(a)` of Change 1 (used for the up-arrow surrounding `Function.Surjective` notation) is a stock AMS-LaTeX command and does not need to be defined.

## Reference-retriever dispatches (if any)

None. The directive's References list (`challenge.lean`, `analogies/m3-route-a-refresh-iter145.md`, Stacks Tag 02KH / 0BUG / 07F4 / 0F8L, Hartshorne Ch. III.11 / II.8) is sufficient for the prose rewrites at hand. The Stacks Tag and Hartshorne citations are already integrated into the chapter's citation discipline (Stacks Tag 02KH and 0BUG were already named in the iter-147 chapter; 07F4 and 0F8L too). No new external source needed to be summarised into `references/`.

## Notes for Plan Agent

- **`% NOTE (iter-147 review)` on `constants_integral_over_base_field` is now redundant.** The 7-step closure chain it described has been lifted into the prose body verbatim. The plan agent may consider asking the next iter's blueprint-reviewer / `sync_leanok` to prune the now-redundant NOTE block (lines 1983–1998 of the lemma statement; outside this writer round's marker-discipline scope).
- **`% NOTE (iter-147 review)` on the lift lemma `Scheme_Over_ext_of_diff_zero` (lines 2126–2134) was left untouched** per the directive's explicit "Out of scope" instruction. The iter-148+ refinement to encode `df = dg` substantively in that lemma is still gated on KDM body closure (per that NOTE's last sentence), and remains pending iter-148+ prover-lane work.
- **No strategy-modifying findings.** The 7-step chain and the (p1)/(p2) alternative-routes restructure are both refinements of the existing project strategy, not changes to it. The iter-148 strategy-critic's LOC-bumping recommendation for substep 3 / step (e) was absorbed at the chapter level (LOC budget for step (e) raised from `~50–100 LOC` to `~250–500 LOC` from scratch, with the explicit "substantially less if Mathlib matures" caveat). If the plan agent wants this LOC bump reflected in `STRATEGY.md` numerically, that is outside the writer's scope.

## Strategy-modifying findings

None. Both Changes 1 and 2 absorb existing in-chapter `% NOTE (iter-147 review)` content + the iter-148 review/critic mandates into the chapter body; neither requires a STRATEGY.md edit. The LOC-budget bump for step (e) is purely a chapter-level refinement of the existing strategy's cost estimate, not a route change.

## Verification

Affected labels and structural integrity:

- **`\label{lem:constants_integral_over_base_field}`** at line 1962: lemma statement (with its `\leanok`, `\lean{…}`, and two iter-146/147 `% NOTE` blocks) preserved verbatim. Proof body rewritten from line 2009 onward; `\leanok` at line 2008 preserved verbatim. `\begin{proof}` at line 2006, `\end{proof}` at line 2030 (new file). No new `\leanok`, `\mathlibok`, `% NOTE`, or `\notready` markers added or removed.

- **`\label{lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero}`** at line 2063: theorem statement (with `\leanok` on `\begin{theorem}`, `\lean{…}`, `\uses{…}`) preserved verbatim. Proof body rewritten from line 2074 onward; the `\uses{…}` at line 2073 preserved verbatim. `\begin{proof}` at line 2072, `\end{proof}` at line 2104 (new file). No new `\leanok`, `\mathlibok`, `% NOTE`, or `\notready` markers added or removed.

LaTeX structural balance:

- Top-level `\begin{theorem|lemma|proof|definition|remark|proposition|corollary|quote|enumerate|itemize|verbatim|array}` block count: 50 begins / 50 ends (unchanged from iter-147 file).
- All-level (including indented) `\begin{enumerate|itemize}` block count: 25 begins / 25 ends.
- All-level structural block count: 73 begins / 73 ends.
- Total `\leanok` + `\mathlibok` marker count: 25 (unchanged from iter-147 file). Pre-/post-edit conservation of marker discipline confirmed.
- File line count: 2163 (iter-147) → 2176 (iter-148). The net 13-line growth is consistent with the (a)–(g) chain expansion in Change 1 (added structure: itemize for the four hypothesis stability instances of step (b)) plus the (p1.e) / (p1.f) sub-step renaming and the new "Closure end state and ordering" paragraph in Change 2.

No dangling `\begin{…}` or `\end{…}`, no unbalanced braces in any new `\label{…}`, `\uses{…}`, or `\lean{…}` (none were added or modified by this writer round). Chapter remains structurally valid LaTeX from a textual sanity check.
