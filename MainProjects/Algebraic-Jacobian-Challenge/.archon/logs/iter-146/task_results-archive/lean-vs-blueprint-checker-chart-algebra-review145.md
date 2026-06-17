# Lean ↔ Blueprint Check Report

## Slug
chart-algebra-review145

## Iteration
145

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex`, subsection
  "Chart-algebra piece (ii) first-class decomposition" (lines 1773–1954)

## Audit scope note
Per the directive, this audit is restricted to the new iter-145
subsection `\subsection{Chart-algebra piece (ii) first-class
decomposition}` and the brand-new file
`AlgebraicJacobian/Cotangent/ChartAlgebra.lean`. The five declarations
are intentionally `: True := sorry` placeholders authorised by the
iter-145 refactor directive (citing the iter-128–iter-131 cotangent
body-shape refactor as the cautionary tale). The Lean ↔ blueprint
signature mismatch on each block is therefore EXPECTED in iter-145 and
is flagged here informationally for the iter-146 prover lane, not as
critical.

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product}` (chapter: `\lem:chart_algebra_isPushout_of_affine_product`)
- **Lean target exists**: yes — `ChartAlgebra.lean:50`, full name
  `AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product`,
  matches the blueprint `\lean{...}` hint character-for-character.
- **Signature matches**: no (intentional placeholder). Lean signature
  is `: True`; blueprint claims an `Algebra.IsPushout k B₁ B₂ B`
  structure on the chart-affine pullback square. This is the iter-145
  placeholder shape authorised by the refactor directive — the in-file
  doc-comment carries the explicit annotation `TODO iter-146: real
  signature; placeholder is `: True`.` (line 49).
- **Proof follows sketch**: N/A (placeholder body `:= sorry`; blueprint
  proof is a 3-step recipe — `pullbackSpecIso` → `isPullback_SpecMap_of_isPushout`
  → `CommRingCat.isPushout_iff_isPushout` — that an iter-146 prover
  can directly chain).
- **notes**: `\uses{def:relative_kaehler_presheaf}` cross-reference
  resolves to `blueprint/src/chapters/Differentials.tex` line 14.
  Statement carries a `\leanok` marker (line 1780) and the proof block
  carries a `\leanok` (line 1798). The statement-level `\leanok` is
  defensible per CLAUDE.md's "at least a sorry present" rule, but the
  proof-level `\leanok` is wrong (the Lean has only `:= sorry`, so the
  proof is not closed). See "Red flags / Blueprint marker misuse"
  below.

### `\lean{AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart}` (chapter: `\lem:chart_algebra_df_zero_factors_through_constant_on_chart`)
- **Lean target exists**: yes — `ChartAlgebra.lean:59`, full name
  `AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart`,
  matches the blueprint `\lean{...}` hint exactly.
- **Signature matches**: no (intentional placeholder). Lean signature
  is `: True`; blueprint claims a 5-quantifier statement over a smooth
  proper geometrically irreducible curve `C`, a group scheme `A`, a
  morphism `f : C → A` with `df = 0`, and chart pair `(W = Spec B, V =
  Spec R)`, concluding `f^♯(b) ∈ range (algebraMap k R)`. The in-file
  doc-comment carries the annotation `TODO iter-146: real signature;
  placeholder is `: True`.` (line 58).
- **Proof follows sketch**: N/A (placeholder body `:= sorry`; blueprint
  has a 5-step proof skeleton — Step 1 chart-level translation, Step 2
  extension to all `b ∈ B`, Step 3 chart-Čech / Mayer–Vietoris
  promotion via `\thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`,
  Step 4 ring-side helper, Step 5 integrally-closed-constants helper).
- **notes**: This is the load-bearing block of the subsection (per the
  Strategy-critic Q3 paragraph at line 1778). The `\uses{...}` field
  cites the three sibling helpers; the embedded proof additionally
  cites `\thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`
  which resolves to `Cohomology_MayerVietoris.tex` line 520. The
  Strategy-critic Q3 honesty note (lines 1826 + 1855) is detailed
  enough that an iter-146 prover is on notice that the cohomological
  content `H⁰(C, Ω_{C/k}^⊕g) = 0` IS being invoked (just not via the
  packaged Serre-duality citation).

### `\lean{AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero}` (chapter: `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`)
- **Lean target exists**: yes — `ChartAlgebra.lean:69`, full name
  `AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
  (the `KaehlerDifferential.…` decl is OUTSIDE the `namespace GrpObj`
  block, lifting it to `AlgebraicGeometry.KaehlerDifferential.…` — this
  matches the blueprint `\lean{...}` exactly).
- **Signature matches**: no (intentional placeholder). Lean signature
  is `: True`; blueprint claims a ring-level theorem `D b = 0 ⇒ b ∈
  range (algebraMap k B)` for `B` a finitely-generated `k`-algebra
  (or more generally standard-smooth-of-relative-dimension `n`). The
  in-file doc-comment annotation is present (line 68).
- **Proof follows sketch**: N/A. Blueprint has a characteristic
  case-split: char-0 closes via the `Differential.ContainConstants`
  typeclass; char-`p` runs a 3-substep Frobenius-iteration chain
  (p1) reduce to `B^p`, (p2) iterate via `RingHom.iterateFrobenius_comm`,
  (p3) descend via integrally-closed-constants. See "Blueprint
  adequacy for this file" below for a more detailed assessment of
  the char-`p` sketch — it is mostly concrete but step (p1) sits on
  an acknowledged Mathlib [gap] (chart-side `ker D = B^p` Cartier
  direction) and step (p3) appeals to a "smooth proper geometrically
  irreducible scheme" hypothesis that is NOT in the lemma statement
  (which posits only a finite-type `k`-algebra).
- **notes**: Project-namespaced (`AlgebraicGeometry.KaehlerDifferential.…`
  rather than the upstream `KaehlerDifferential.…`), explicitly because
  the upstream Mathlib `KaehlerDifferential` namespace does not own
  this lemma in snapshot `b80f227` (see Mathlib-status note in
  blueprint line 1920). Project-namespacing is the right call for now
  with the upstream PR deferred. `\uses{lem:chart_algebra_isPushout_of_affine_product}`
  resolves locally.

### `\lean{AlgebraicGeometry.constants_integral_over_base_field}` (chapter: `\lem:constants_integral_over_base_field`)
- **Lean target exists**: yes — `ChartAlgebra.lean:77`, full name
  `AlgebraicGeometry.constants_integral_over_base_field` (declared in
  the outer `AlgebraicGeometry` namespace, outside `GrpObj` and
  outside `Scheme.Over`). Matches the blueprint `\lean{...}`.
- **Signature matches**: no (intentional placeholder). Lean signature
  is `: True`; blueprint claims `Γ(X, O_X) = range (algebraMap k Γ(X,
  O_X))` for `X` smooth proper geometrically irreducible over a field
  `k`, i.e. `Γ(X, O_X) ≅ k`. In-file annotation present (line 76).
- **Proof follows sketch**: N/A. Blueprint has a 3-substep proof:
  (1) properness ⇒ `Γ(X, O_X)` finite-dimensional over `k`,
  (2) smooth + geometrically irreducible ⇒ integral domain,
  (3) finite integral domain over a field is a finite field
  extension; geometric irreducibility forces dim_k = 1 via base
  change to `k̄`.
- **notes**: Sub-step (3) flags a "[gap]-fill thin wrapper" need for
  flat base change of Γ — an honest acknowledgment that iter-146+
  prover lane will need to derive or wrap the `IsBaseChange`-namespace
  result. No `\uses{...}` field on the lemma block (line 1870–1873) —
  arguably should cite Mathlib's `IsProper`-namespace coherent-pushforward
  lemmas if those are encoded in any other blueprint chapter, but since
  the chapter freely cites Mathlib by qualified path in the Mathlib-status
  block, this is acceptable.

### `\lean{AlgebraicGeometry.Scheme.Over.ext_of_diff_zero}` (chapter: `\lem:Scheme_Over_ext_of_diff_zero`)
- **Lean target exists**: yes — `ChartAlgebra.lean:89`, full name
  `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero` (inside `namespace
  Scheme.Over`, lines 79–91). Matches the blueprint `\lean{...}`.
- **Signature matches**: no (intentional placeholder). Lean signature
  is `: True`; blueprint claims `df = dg + eqOnOpen U ⇒ f = g` for
  two morphisms `f, g : C → A` in `Over (Spec k)`. In-file annotation
  present (line 88).
- **Proof follows sketch**: N/A. Blueprint has a 3-step proof:
  (1) reduce to a single difference morphism `h = μ ∘ ⟨f, ι ∘ g⟩`
  with `dh = 0` using `KaehlerDifferential.D_sub`;
  (2) apply `\lem:chart_algebra_df_zero_factors_through_constant_on_chart`
  chart-by-chart, conclude `h` factors through `Spec k`;
  (3) identify the constant value via Step 1's agreement on `U`,
  and finally invoke `\thm:GrpObj_eq_of_eqOnOpen` for the iter-125
  ext_of_eqOnOpen packaging.
- **notes**: `\uses{lem:chart_algebra_df_zero_factors_through_constant_on_chart,
  thm:GrpObj_eq_of_eqOnOpen}` cross-references both resolve
  (`thm:GrpObj_eq_of_eqOnOpen` is at `Rigidity.tex:12`).

## Red flags

### Blueprint marker misuse (minor — sync-time auto-correctable)

- All five `\begin{proof}` blocks (lines 1798, 1831, 1883, 1907, 1940)
  carry a `\leanok` marker, but every corresponding Lean proof body is
  `:= sorry`. Per `.archon/CLAUDE.md` "Blueprint Marker Vocabulary",
  `\leanok` on a proof block means "proof closed, no `sorry`". The
  deterministic `sync_leanok` phase between prover and review should
  strip these proof-block `\leanok` markers next iter; until it does,
  the blueprint is over-claiming closure on five `\begin{proof}` blocks.
- All five `\begin{lemma}` / `\begin{theorem}` blocks (lines 1780,
  1810, 1870, 1895, 1923) also carry `\leanok`. This is defensible
  under "at least a sorry present" for the statement-level marker
  (the placeholder `: True := sorry` does instantiate the named
  declaration in a way that compiles), but the underlying signature
  is `: True`, not the substantive type the blueprint prose names.
  This is best left to the next `sync_leanok` run to decide; the
  honest reading is that the statement-level `\leanok` is **also**
  premature because a `: True` declaration is not a faithful
  formalization of the prose. Flagging as minor because (a) the
  iter-145 refactor directive authorised the `: True` placeholder
  shape, and (b) `sync_leanok` is the canonical authority and will
  apply the right rule.

### Placeholder / suspect bodies
- All five declarations have body `:= sorry` on a `: True` signature.
  Per the audit-scope note above, this is expected and authorised
  by the iter-145 refactor directive. Each declaration carries an
  honest `TODO iter-146: real signature; placeholder is `: True`.`
  annotation in its doc-comment (`ChartAlgebra.lean:49, 58, 68, 76,
  88`). The header comment at lines 18–39 additionally documents
  the skeleton-only authoring discipline. **Not flagged as critical**
  per the directive's "Known issues" guidance.

### Excuse-comments
- None that are misleading. The doc-comments name the placeholder
  shape (`: True`) honestly and pin the iter-146 closure target.

### Axioms / Classical.choice on non-trivial claims
- None.

## Unreferenced declarations (informational)
- None. All five Lean declarations in this file are `\lean{...}`-referenced
  from the blueprint subsection. The file is 100% blueprint-mapped.

## Blueprint adequacy for this file

- **Coverage**: 5/5 Lean declarations have a corresponding `\lean{...}`
  block in the chapter. Unreferenced declarations: 0 helpers + 0
  substantive. Perfect coverage.

- **Proof-sketch depth**: **mostly adequate, one under-specified
  substep** (the char-`p` (p1) of
  `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`).
  Specifically:
  - `\lem:chart_algebra_isPushout_of_affine_product`: 3-step
    Mathlib-recipe sketch with named tagged lemmas — **adequate**, an
    iter-146 prover can chain `pullbackSpecIso` →
    `isPullback_SpecMap_of_isPushout` →
    `CommRingCat.isPushout_iff_isPushout` directly.
  - `\lem:chart_algebra_df_zero_factors_through_constant_on_chart`:
    5-step sketch with the Mayer–Vietoris instantiation explicit (cites
    `\thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact` for
    the exact-sequence; cites `Genus.lean`'s `H¹(C, O_C) = 0` idiom as
    the running model) — **adequate**.
  - `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`:
    char-0 case (via `Differential.ContainConstants` typeclass) is
    **adequate**. Char-`p` case has three sub-steps (p1–p3) with
    issues:
    - **(p1) chart-side `ker D = B^p` Cartier-direction** is flagged
      `[gap]` in Mathlib snapshot `b80f227` (blueprint line 1920) and
      the sketch defers to "the project's iter-145+ in-tree build
      derives it from the explicit chart presentation … by hand". This
      is the load-bearing mathematical content of the char-`p` half
      and the blueprint does not give a concrete proof recipe — just
      "by hand from the standard-smooth presentation". An iter-146
      prover will hit a wall here without additional informal-prose
      expansion. **Recommend** an iter-146 blueprint-writer dispatch
      to expand step (p1) into a 3–5-sub-step recipe (e.g. derivation
      of the Cartier isomorphism from the relative Frobenius +
      standard-smooth chart, or alternative reduction via Mathlib's
      existing `Algebra.IsSeparable` / `IsPurelyInseparable`
      machinery with explicit accommodation for the
      not-necessarily-separable case).
    - **(p2)** Frobenius iteration via `RingHom.iterateFrobenius_comm`
      — the chain `b = c₁^p = c₂^{p²} = … = c_n^{p^n}` is named, but
      the bound "Frobenius depth uniformly bounded by the chart's
      structural data" is hand-wavy. The prover lane will need to
      pin a specific depth bound (e.g. via the chart's relative
      dimension `n` or the standard-smooth chart's structural
      generators). **Recommend** a one-paragraph expansion naming
      the explicit bound and citing the Mathlib lemma that supplies
      it (if any).
    - **(p3)** Descent step appeals to "B is the chart-side ring of
      a smooth proper geometrically irreducible scheme (the standing
      chart-side hypothesis)". This is a **logical gap**: the lemma
      statement at line 1900 says `B` is a finite-type `k`-algebra
      (or "more generally" a standard-smooth chart of relative
      dimension `n`); neither hypothesis encodes "chart of a smooth
      proper geometrically irreducible scheme". The proof is implicitly
      restricting `B` to the chart-side of a globally-proper `X`, but
      the lemma is stated without that restriction. **Either** the
      lemma should be re-stated to carry the chart-of-proper hypothesis
      explicitly, **or** the proof should derive the integral-closure
      conclusion from the finite-type + standard-smooth hypotheses
      alone (the latter is mathematically tight but considerably
      harder). Flagging as **major** for the iter-146 prover lane.
  - `\lem:constants_integral_over_base_field`: 3-substep sketch,
    flags one `[gap]-fill thin wrapper` honestly — **adequate**.
  - `\lem:Scheme_Over_ext_of_diff_zero`: 3-step sketch chaining the
    `KaehlerDifferential.D_sub` reduction, the chart-helper consumption,
    and the iter-125 `ext_of_eqOnOpen` packaging — **adequate**.

- **Hint precision**: **precise**. Every `\lean{...}` block names the
  fully-qualified Lean identifier, and each lands at exactly the named
  identifier in `ChartAlgebra.lean` (verified above). The blueprint
  prose pins the Mathlib predicates by name (`Algebra.IsPushout`,
  `KaehlerDifferential.D`, `Differential.ContainConstants`,
  `RingHom.iterateFrobenius_comm`, `Algebra.IsStandardSmoothOfRelativeDimension`,
  …) with `\texttt{…}` formatting and source-file paths.

- **Generality**: **matches need** — but with the
  finite-type-vs-chart-of-proper ambiguity in
  `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` (see
  Proof-sketch depth → char-`p` (p3) above) flagged as the
  generality-mismatch worth resolving before iter-146.

- **Recommended chapter-side actions** (for the catalog's
  blueprint-writing subagent):
  1. **Expand char-`p` step (p1)** of
     `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` into
     a concrete 3–5 sub-step recipe; the current "by hand from the
     standard-smooth presentation" is too thin for an iter-146 prover
     without further informal-prose dispatch.
  2. **Reconcile the lemma statement and proof of
     `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`**:
     either tighten the statement to "chart of a smooth proper
     geometrically irreducible scheme" (the hypothesis the proof
     actually uses in step (p3)), or rework the proof to descend
     from the finite-type + standard-smooth hypotheses alone. The
     current mismatch is a soft logical gap.
  3. **Pin the Frobenius-depth bound** in char-`p` step (p2) — name
     the explicit numerical bound or cite the structural lemma that
     supplies it.
  4. **No action required for the other four blocks** — they are
     adequately specified.

## Severity summary

Apply rules verbatim.

- **must-fix-this-iter**:
  - **None of the placeholder `: True := sorry` shapes** trigger this
    classification, per the directive's "Known issues" authorising
    the iter-145 placeholder pattern with honest `TODO iter-146`
    annotations on every declaration (all five present, verified
    above).
  - **No critical findings** in either direction.

- **major**:
  - **Blueprint adequacy: char-`p` step (p1) of
    `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` is
    under-specified.** The chart-side `ker D = B^p` Cartier direction
    is flagged `[gap]` in Mathlib and the blueprint defers to "by
    hand from the standard-smooth presentation" without a concrete
    sub-step recipe. An iter-146 prover will need an additional
    blueprint-writer dispatch to expand this step before formalization
    can proceed on the char-`p` half.
  - **Blueprint logical gap: step (p3) of
    `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`**
    appeals to a "chart of a smooth proper geometrically irreducible
    scheme" hypothesis that is not in the lemma statement (which
    states only finite-type + optionally standard-smooth of relative
    dimension `n`). Statement and proof should be reconciled before
    iter-146 prover lane attempts the body.

- **minor**:
  - **Proof-block `\leanok` markers on all five blocks (lines 1798,
    1831, 1883, 1907, 1940) are premature** — the corresponding Lean
    proofs are `:= sorry`. The next `sync_leanok` run should strip
    these automatically; flagging informationally so the iter-145
    review agent can confirm the sync caught them.
  - **Statement-level `\leanok` markers on all five blocks** are
    defensible under "at least a sorry present" but arguably premature
    given the signatures are `: True` rather than the substantive
    prose-named types. Deferred to `sync_leanok`'s canonical authority.
  - **Frobenius-depth bound** in char-`p` step (p2) of
    `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` is
    hand-wavy ("uniformly bounded by the chart's structural data");
    iter-146+ blueprint-writer should pin the explicit bound.

**Overall verdict**: The five `: True := sorry` placeholders in
`ChartAlgebra.lean` are intentional iter-145 skeletons authorised by
the refactor directive and carry honest `TODO iter-146` annotations;
the blueprint subsection is well-structured, hint-precise, and
adequate for four of the five blocks, but the char-`p` half of
`\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` (step
(p1) under-specification + step (p3) statement/proof generality
mismatch) needs one more blueprint-writer pass before the iter-146
prover lane can take it on without further informal-prose dispatch.
