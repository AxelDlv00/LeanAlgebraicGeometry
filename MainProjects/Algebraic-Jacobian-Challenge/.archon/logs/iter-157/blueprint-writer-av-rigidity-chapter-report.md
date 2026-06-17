# Blueprint Writer Report

## Slug
av-rigidity-chapter

## Status
COMPLETE — all five required blocks written and sourced; one Strategy-modifying finding (the
single-$\mathbb P^1$ base case is NOT cube-free, refining the iter-156 expectation).

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex  (NEW FILE — created)

## Determination of the minimal chain (the directive's "most important job")
I read Mumford §4 (PDF p.54, the Rigidity Lemma + proof) and §6 (PDF p.66, the theorem of
the cube), Milne Thm 1.1 (PDF p.14) and Prop 3.10 (PDF p.26, statement + proof), and
Hartshorne Example IV.1.3.5 (PDF p.314). Conclusion on the cube question:

- **The Rigidity Lemma (Mumford Form I) is cube-free** — its proof is purely a
  completeness/closed-map argument (`p₂` closed since `X` complete; a proper connected
  variety has no nonconstant map to an affine). Confirmed verbatim. It is the natural
  formalisation entry point.
- **The single-$\mathbb P^1$ constancy is NOT a consequence of the Rigidity Lemma alone.**
  The Rigidity Lemma collapses a *product* `X × Y → Z` when one axis is already collapsed;
  a bare `f : ℙ¹ → A` presents no collapsed axis (the difference map `(x,y) ↦ f(x)−f(y)` is
  constant on an axis only if `f` already is). Mumford himself leaves "no rational curves /
  `ℙ¹ → A` constant" to the reader (the reference card confirms it is *not* a labelled §4
  result), and Milne's Prop 3.10 proof bottoms out at "the lemma shows each `βᵢ` is
  constant" — i.e. the single-curve base case is taken as known. In characteristic-free
  form that base case rests on the **theorem of the cube** (the char-0 alternative,
  `f*ω` + `H⁰(ℙ¹,Ω)=0`, is exactly the Frobenius-wall route the project abandoned).
- **What IS cube-free is the multi-factor induction**: Milne Cor 1.5 (additivity of
  `Hom(−,A)` over a product of complete pointed varieties) is a corollary of the Rigidity
  Lemma, and drives `β(x₁,…,x_d) = Σ βᵢ(xᵢ)`. So the directive's framing was half right:
  the *induction* is cube-free, the *base* is not.

I therefore structured the chapter around the minimal chain with the cube retained as a
clearly-flagged **deferred deep input** (matching the project memory chain "thm of cube →
Rigidity 1.1 → … → Prop 3.10"), and recorded the refutation in
`\cref{rmk:cube_is_load_bearing}` and in Strategy-modifying findings below.

## Changes Made
- **Added lemma** `\label{thm:rigidity_lemma}` / `\lean{AlgebraicGeometry.rigidity_lemma}` —
  Mumford Rigidity Lemma (Form I), with the **full cube-free proof** (the iter-158 prover
  entry). `% SOURCE`/`% SOURCE QUOTE`/`% SOURCE QUOTE PROOF` all transcribed from the
  rendered Mumford PDF p.54. Does NOT `\uses` the cube.
- **Added remark** `\label{rmk:rigidity_lemma_cube_free}` — flags the lemma as the
  lowest-prerequisite link / formalisation entry point.
- **Added theorem** `\label{thm:theorem_of_the_cube}` — Mumford theorem of the cube,
  verbatim statement from PDF p.66, **no proof env** (deferred deep input, no Lean target).
  Re-grounded in Mumford (the directive flagged Milne's "deferred to next version" quote in
  the current Jacobian.tex as too thin).
- **Added proposition** `\label{prop:morphism_P1_to_AV_constant}` /
  `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const}` — every `ℙ¹ → A` is constant;
  `\uses{thm:rigidity_lemma, thm:theorem_of_the_cube}`. Sourced to Milne Prop 3.10 (PDF
  p.26, statement + unirational def + proof verbatim). Proof is honest about where the depth
  lives (the cube-backed base case).
- **Added remark** `\label{rmk:cube_is_load_bearing}` — the load-bearing finding (base case
  needs the cube), pointing to Strategy-modifying findings.
- **Added proposition** `\label{prop:genusZero_curve_iso_P1}` /
  `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` — genus-$0$ curve `≅ ℙ¹` over `k̄`;
  `\uses{def:genus}`. Sourced to Hartshorne Example IV.1.3.5 (PDF p.314, verbatim) with a
  Riemann–Roch proof sketch.
- **Added remark** `\label{rmk:genusZero_iso_subbuild}` — flags that this is a genuine
  sub-build (Mathlib has no Riemann–Roch).
- **Added theorem** `\label{thm:rigidity_genus0_curve_to_AV}` (+ second
  `\label{prop:rigidity_genus0_curve_to_AV}` for old `\cref` carryover) /
  `\lean{AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme}` — the headline;
  `\uses{prop:morphism_P1_to_AV_constant, prop:genusZero_curve_iso_P1}`. Signature described
  as `rigidity_over_kbar` minus `[CharZero]` (template named explicitly for the scaffolder).
- **Local macro** `\providecommand{\fatsemi}` added at chapter top (diagrammatic `≫`
  composition) — see "Macros needed".

## Cross-references introduced
- `\uses{thm:rigidity_lemma, thm:theorem_of_the_cube}` in `prop:morphism_P1_to_AV_constant` —
  both defined in this chapter.
- `\uses{def:genus}` in `prop:genusZero_curve_iso_P1` — `def:genus` exists in `Genus.tex`
  (`\label{def:genus}`, verified).
- `\uses{prop:morphism_P1_to_AV_constant, prop:genusZero_curve_iso_P1}` in the headline —
  both defined in this chapter.
- Chapter cross-refs to `\cref{chap:RigidityKbar}`, `\cref{chap:Genus}`, `\cref{chap:Jacobian}`
  — all exist. (RigidityKbar.tex already added an iter-157 STRATEGY NOTE pointing at
  `\cref{chap:AbelianVarietyRigidity}` and `thm:rigidity_genus0_curve_to_AV`, so the labels
  match what the plan agent pre-wired.)

## References consulted
- `references/mumford-abelian-varieties.pdf` — **read rendered page images** (pypdf
  `page.images` → PIL; pdftoppm absent). PDF p.54 (book p.43): Rigidity Lemma (Form I) +
  proof — verbatim for `thm:rigidity_lemma`. PDF p.66 (book p.55): theorem of the cube —
  verbatim for `thm:theorem_of_the_cube`.
- `references/abelian-varieties.pdf` (Milne) — **rendered via pymupdf** (text PDF, but
  pypdf text-extraction mojibakes `×`/`⊗`/etc., so I rendered to image for clean verbatim).
  PDF p.14 (doc p.8): Rigidity Theorem 1.1. PDF p.26 (doc p.20): Prop 3.10 + unirational
  def + proof — verbatim for `prop:morphism_P1_to_AV_constant`. Also read PDF p.15–16, 22–25
  to trace the curve base case / Cor 1.5 dependency.
- `references/hartshorne-algebraic-geometry.pdf` — **read rendered page image** (pypdf
  images). PDF p.314 (doc p.297): Example IV.1.3.5 — verbatim for
  `prop:genusZero_curve_iso_P1`.
- `references/mumford-abelian-varieties.md`, `references/hartshorne-algebraic-geometry.md`,
  `references/abelian-varieties.md` — pointer cards (page maps); no quotable text taken from
  them.
- `blueprint/src/chapters/Jacobian.tex` (`sec:av_rigidity_route_c`, lines ~449–595) — read
  as a starting point for label carryover; re-grounded every proof in Mumford/Hartshorne.
- `AlgebraicJacobian/RigidityKbar.lean` (signature of `rigidity_over_kbar`) and
  `AlgebraicJacobian/Genus.lean` (`genus` def) — to mirror the headline signature.

## Macros needed (if any)
- `\fatsemi` — diagrammatic composition (Lean `≫`), used in the headline block. I added a
  local `\providecommand{\fatsemi}{\mathbin{\,;\,}}` at the chapter top (per directive's
  permission for a local definition). If you prefer a global symbol, promote it to
  `macros/common.tex` (e.g. mapping to `⨟` via a math font); `\providecommand` makes the
  local definition a no-op once a global one exists, so no clash.

## Reference-retriever dispatches (if any)
None — all required sources were already in `references/` and I rendered the PDF pages
directly (pypdf+PIL for the scanned Mumford/Hartshorne; pymupdf for the Milne text PDF, whose
glyphs mojibake under text extraction).

## Notes for Plan Agent
- **Existing Jacobian.tex carries a spurious `\uses{thm:theorem_of_the_cube}` on the
  Rigidity Theorem block** (`lem:rigidity_theorem`, line ~498). The Rigidity Lemma/Theorem
  proof is cube-free (verified against Mumford p.54 and Milne p.14 — pure closed-map
  argument). My chapter's `thm:rigidity_lemma` correctly does NOT use the cube. When you
  strip the duplicated route-(c) blocks from Jacobian.tex, drop that spurious edge.
- **The reference card `references/hartshorne-algebraic-geometry.md` mis-describes Exercise
  IV.1.3.** The card says Ex IV.1.3 is "genus-0 + rational point ⇒ ≅ ℙ¹"; the actual
  Exercise IV.1.3 (PDF p.314) is about a non-proper regular curve being affine. I did NOT
  cite it; the genus-0 classification is fully contained in **Example IV.1.3.5**, which I
  quoted verbatim. Consider correcting the card.
- The headline block carries **two labels** (`thm:rigidity_genus0_curve_to_AV` and
  `prop:rigidity_genus0_curve_to_AV`) so that both the new iter-157 references (in
  RigidityKbar.tex) and the old `prop:`-style `\cref`s in Jacobian.tex resolve. If you would
  rather have a single label, update the surviving `\cref{prop:rigidity_genus0_curve_to_AV}`
  occurrences in Jacobian.tex when you strip the route-(c) blocks, then I can drop the second
  label next round.
- `prop:morphism_P1_to_AV_constant` and `prop:genusZero_curve_iso_P1` both have real
  formalisation cost (the former needs the deferred cube; the latter needs Riemann–Roch,
  absent from Mathlib). Only `thm:rigidity_lemma` is genuinely prover-ready at iter-158; the
  others are statement-level until their prerequisites are built. The chapter says so in
  prose (`rmk:genusZero_iso_subbuild`, `rmk:cube_is_load_bearing`).

## Strategy-modifying findings
**The single-$\mathbb P^1$ base case of the genus-0 rigidity arm is NOT cube-free.** The
iter-156 disposition (recorded in project memory and echoed in the directive) expected that a
single `ℙ¹ → A` factor would avoid the theorem of the cube, with the cube entering only the
multi-factor unirational induction. Reading the sources shows the opposite split:

- The **multi-factor induction** (Milne Prop 3.10's `β = Σ βᵢ`) *is* cube-free — it is pure
  Rigidity-Lemma additivity (Milne Cor 1.5).
- The **base case** "a single nonconstant `ℙ¹ → A` cannot exist" (≡ an abelian variety has
  no rational curves) is the irreducible content, and it is NOT a formal consequence of the
  Rigidity Lemma. Characteristic-free, it rests on the theorem of the cube. (Char-0 has the
  `df=0` shortcut, but that is precisely the Frobenius-wall route the project rejected.)

**Why it matters:** route (c)'s real cost is the **theorem of the cube** (Mumford §6 / the
char-free scheme form §10), not the elementary Rigidity Lemma. The Rigidity Lemma alone does
not close the genus-0 arm. STRATEGY.md should reflect that the genus-0 arm's keystone
prerequisite is the cube (a substantial multi-section build), and that `thm:rigidity_lemma`
(prover-ready at iter-158) is necessary but not sufficient — closing
`prop:morphism_P1_to_AV_constant` is blocked on the cube. This does not kill route (c) (the
chain is correct and char-free), but it relocates the heavy lifting and should temper any
expectation that the genus-0 arm closes shortly after `rigidity_lemma` lands.
