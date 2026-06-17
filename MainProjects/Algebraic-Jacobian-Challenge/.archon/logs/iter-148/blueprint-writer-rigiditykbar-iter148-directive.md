# Directive — blueprint-writer for `RigidityKbar.tex` @ iter-148

## Scope

ONE chapter: `blueprint/src/chapters/RigidityKbar.tex`.

## Strategy context (chapter-local slice)

The chart-algebra (β) route is the M2.a critical path. Five
sub-pieces in `Cotangent/ChartAlgebra.lean`; three closed
(α, β-core, lift), two with iter-148 prover lane scheduled
(KDM forward inclusion, constants substep 3 step (e)).

The iter-148 mandatory blueprint-reviewer flagged TWO soon-severity
prose-detail items to lift from `% NOTE (iter-147 review)` comment
annotations into the chapter's `\begin{proof}` bodies. The
iter-148 strategy-critic separately challenged the substep 3 gap
depth and recommended raising the LOC budget; this writer round
absorbs both.

## Required changes (this writer round)

### Change 1 — surface the 7-step closure chain for `constants_integral_over_base_field`

The current chapter proof body presents the iter-145 three-substep
recipe:
- (1) `IsReduced` + `GeometricallyIrreducible` ⇒ `IsIntegral X`.
- (2) `IsIntegral` + `UniversallyClosed` ⇒ `Γ(X, O_X)` is a field +
  finite over `k`.
- (3) base-change to `\bar k` ⇒ `dim_k Γ(X, O_X) = 1`.

The iter-147 prover's closure expansion names a 7-step chain
(a)–(g) that decomposes substep (3) into named Mathlib lemmas:

- (a) Algebraize `appTop.hom` and `ΓSpecIso k` to expose
  `Γ(X, ⊤)` as a finite `k`-algebra and a field. Use Mathlib's
  `RingHom.range_eq_top` to convert the goal to
  `Function.Surjective ⇑(appTop.hom)`.

- (b) Pull back `X` along `Spec.map (algebraMap k (AlgebraicClosure k))`
  to obtain `X_{\bar k}`. The base change preserves:
  - `IsProper` (stable under base change),
  - `Smooth` (stable under base change),
  - `IsReduced` (smoothness + algebraically closed base ⇒ reduced;
    Mathlib's `AlgebraicGeometry.Smooth.isReduced_of_smooth` or
    via `Algebra.IsGeometricallyReduced`),
  - `IrreducibleSpace` (via
    `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`
    applied to the new structure morphism over `Spec \bar k`).
  Hence `X_{\bar k}` is integral.

- (c) Apply `isField_of_universallyClosed` +
  `finite_appTop_of_universallyClosed` to `X_{\bar k} → Spec \bar k`
  to get: `Γ(X_{\bar k}, ⊤)` is a field, the appTop is finite
  (= integral).

- (d) Apply `IsAlgClosed.algebraMap_bijective_of_isIntegral` with
  `k := \bar k`, `K := Γ(X_{\bar k}, ⊤)` to conclude
  `algebraMap \bar k Γ(X_{\bar k}, ⊤)` is bijective, so
  `Γ(X_{\bar k}, ⊤) ≅ \bar k`.

- (e) Use flat base change of global sections for proper schemes
  to identify
  `Γ(X, ⊤) ⊗_k \bar k ≃ Γ(X_{\bar k}, ⊤) = \bar k`. **This is the
  substantive Mathlib gap.** Citation: Stacks Tag 02KH (cohomology
  along proper morphisms commutes with flat base change), specialised
  to `Hⁱ = H⁰ = Γ`; equivalently EGA IV.6 / Hartshorne III.11.

- (f) Conclude `dim_k Γ(X, ⊤) = 1` via `Module.finrank_baseChange`
  on the equality `Γ(X, ⊤) ⊗_k \bar k = \bar k` (both sides have
  `\bar k`-dimension `1`).

- (g) Conclude `algebraMap k Γ(X, ⊤)` is surjective via
  `Subalgebra.bot_eq_top_iff_finrank_eq_one` (or equivalently
  `Module.finrank` arguments on the trivial finite field extension).

Replace the existing three-substep recipe in the
`\begin{proof}` body of `lem:constants_integral_over_base_field`
with this 7-step (a)–(g) chain. Name step (e) explicitly as the
substantive Mathlib gap with the Stacks Tag 02KH citation; mention
the iter-148 disambiguation: the gap is genuinely flat-base-change-
of-Γ-for-proper-schemes (~250–500 LOC if built from scratch), not
a thin wrapper over `finite_appTop_of_universallyClosed` (the
lemma name "constants_integral" is misleading; the current Lean
signature commits to surjectivity = `Γ ≃ k`, which requires the
deeper machinery).

### Change 2 — split the KDM block into alternative (p1) / (p2) routes

The current KDM proof block (`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`)
folds (p2) `Differential.ContainConstants` under the char-0 case
of (p1) standard-smooth-chart. The iter-147 prover identified (p2)
as a *standalone* viable char-0 first-attempt route, not nested.

Restructure the proof block to present two alternative attack
routes:

- **Primary path (p2) — characteristic-0 via `Differential.ContainConstants`**.
  When `CharZero k` (or more generally when the chart-algebra has
  trivial `p`-torsion in its Kähler differentials), the kernel of
  `D : B → Ω_{B/k}` is computed by Mathlib's
  `Differential.ContainConstants` typeclass machinery (see
  `Mathlib.RingTheory.Derivation.DifferentialRing`). The typeclass
  is positioned for a specific derivation `B → B`, not the universal
  Kähler derivation `D : B → Ω_{B/k}`; the bridge requires
  packaging the universal derivation through a chosen basis of
  `Ω_{B/k}` (free of finite rank under
  `Algebra.IsStandardSmooth.free_kaehlerDifferential`), projecting to
  a single coefficient to get a `B → B` derivation, and using that
  as the `Differential B` instance. Estimated ~80–150 LOC for the
  bridge.

- **Alternative path (p1) — characteristic-`p` via standard-smooth
  chart presentation**. When `CharP k p` for `p > 0`, the chart-
  algebra's Kähler kernel is `B^p` (Cartier direction; Stacks Tag
  07F4). The 4-substep iter-146 expansion (p1.a)–(p1.d) lands the
  standard-smooth chart presentation, then `RingHom.iterateFrobenius_comm`
  for the Frobenius-power expansion, then descent through the
  chart-of-proper-curve helper. Estimated ~140–230 LOC.

The eventual end state is a case-split body `if charZero then (p2)
else (p1)`. The iter-148 prover may attempt (p2) first since the
typeclass bridge is well-understood and the char-`p` path also
requires the chart-of-proper-curve helper to be scaffolded.

(Minor) Add one sentence to KDM step (p1.d) naming the Mathlib lemma
for the characteristic-$p$ Frobenius-power expansion (Frobenius
additivity + multiplicativity, currently a free-text appeal):
`RingHom.iterateFrobenius_comm` (the iterated Frobenius commutes
with `algebraMap`) is the key; `Algebra.IsStandardSmooth.free_kaehlerDifferential`
delivers the free-module structure on `Ω`.

### Out of scope (DO NOT touch)

- `lem:chart_algebra_isPushout_of_affine_product` (α) — closed
  iter-146; the chapter prose for this block is fine.
- `lem:chart_algebra_df_zero_factors_through_constant_on_chart`
  (β-core) — closed iter-147 via delegation to KDM; the chapter
  prose for this block is fine.
- `lem:Scheme_Over_ext_of_diff_zero` (lift) — closed iter-146 via
  signature reduction; the iter-148+ refinement to encode `df = dg`
  substantively is documented in the chapter's `% NOTE (iter-146 review)`
  block and is NOT this writer round's scope. Leave it alone.
- The `\lean{...}` hints and `\label{...}` labels — these are
  stable cross-reference anchors; do NOT rename.
- Markers `\leanok` / `\mathlibok` — managed by deterministic
  sync_leanok and the review agent respectively; DO NOT add or
  remove either.

## References

- `references/challenge.lean` — the protected signature surface.
- `analogies/m3-route-a-refresh-iter145.md` — Route A LOC midpoint
  per iter-145 audit refresh (informational background).
- Stacks Project Tag 02KH (cohomology and flat base change) and
  Tag 0BUG (cohomology along proper morphisms); Stacks Tag 07F4
  (KDM in char-`p`); Stacks Tag 0F8L (2-chart cover existence on a
  smooth proper curve).
- Hartshorne, *Algebraic Geometry*, Ch. III.11 (proper morphisms
  + base change) and Ch. II.8 (Kähler differentials).

## What you read

- `blueprint/src/chapters/RigidityKbar.tex` (your assigned chapter).
- `references/summary.md` (1-line per source).
- `references/challenge.lean` (authoritative signature surface).
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (current Lean
  signatures and bodies; check signatures match before referencing).

## What you DO NOT read

- `STRATEGY.md`, `PROGRESS.md`, `task_pending.md`, `task_done.md`.
- `PROJECT_STATUS.md`, iter sidecars, prover journals.
- Other chapter files (you may peek at chapter titles for
  cross-references, but do not modify them).

## Output

- Edit `blueprint/src/chapters/RigidityKbar.tex` per Changes 1 + 2
  above.
- Write a self-contained report to
  `task_results/blueprint-writer-rigiditykbar-iter148.md`
  summarising the prose changes, the Mathlib lemma names referenced,
  and any cross-chapter references touched. Include a "Verification"
  section that lists the affected `\label{...}` blocks and confirms
  the chapter still compiles (textually, not LaTeX-wise — your job
  is content, not LaTeX rendering).

## Write-domain

`blueprint/src/chapters/RigidityKbar.tex`, `task_results/**`,
`references/**` (in case you need to dispatch a reference-retriever
child for Stacks 02KH or 0BUG; you probably won't, but the
permission is here so you can if needed).

## Marker discipline

You MUST NOT add or remove `\leanok`, `\mathlibok`, or `% NOTE` /
`\notready` markers in this round. Marker discipline is owned by
the deterministic `sync_leanok` phase + the review agent, not the
blueprint-writer.
