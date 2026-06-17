# Blueprint Writer Report

## Slug
quot-graded-snap

## Status
COMPLETE — with one important Strategy-modifying finding (Mathlib gap) and one
directive factual correction (item 3 premise was wrong); both handled honestly
and flagged below.

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made
- **Rewrote** `def:hilbert_polynomial` (item 1):
  - Replaced the cohomological-χ prose body with the **graded Hilbert-function**
    encoding: `Φ_{F,s}` is the unique polynomial agreeing for `m ≫ 0` with
    `m ↦ dim_{κ(s)} Γ(X_s, F_s ⊗ L_s^{⊗m})`, the graded Hilbert function of the
    section module `⊕_{m≥0} Γ(X_s, F_s ⊗ L_s^{⊗m})` (→`def:sectionGradedModule`)
    over the section ring `⊕_{m≥0} Γ(X_s, L_s^{⊗m})` (→`def:sectionGradedRing`).
  - States the χ-agreement for `m ≫ 0` (Serre vanishing) explicitly, so no
    numerical invariant is lost, while stressing the construction uses only `H^0`.
  - Kept the existing `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` pin and
    the existing Nitsure `% SOURCE`/`% SOURCE QUOTE` (the source itself uses χ;
    that is the verbatim source and is left intact).
  - Replaced the stale "ENCODING PIVOT (iter-003 …)" comment (which referenced
    project history and a "queued task") with a clean, non-historical `% ENCODING`
    note pointing at the new blocks.
  - Added `\uses{thm:hilbertPoly_of_sectionModule}`.
- **Added `\section{Graded Hilbert polynomial}`** (`\label{sec:graded_hilbert_polynomial}`),
  embedded in this chapter, with these blocks (item 2):
  1. **`\definition def:sectionGradedRing`** `\lean{AlgebraicGeometry.sectionGradedRing}`
     — graded section ring `R(X_s,L_s)=⊕_{m≥0} Γ(X_s,L_s^{⊗m})`; f.g. Noetherian
     κ(s)-algebra when L_s ample, X_s proper.
  2. **`\definition def:sectionGradedModule`** `\lean{AlgebraicGeometry.sectionGradedModule}`
     `\uses{def:sectionGradedRing}` — graded module `M(X_s,F_s,L_s)=⊕_{m≥0} Γ(X_s,F_s⊗L_s^{⊗m})`.
  3. **`\lemma lem:sectionGradedModule_fg`** `\lean{AlgebraicGeometry.sectionGradedModule_fg}`
     `\uses{def:sectionGradedModule, def:sectionGradedRing}` — Serre (H^0 only):
     M is f.g. over the Noetherian R. Proof sketch added (Serre's theorem on ample
     line bundles, finiteness of cohomology on proper schemes over a field).
  4. **`\lemma lem:hilbertPoly_exists_mathlib`** `\lean{Polynomial.existsUnique_hilbertPoly}`
     `\mathlibok` — Mathlib anchor. **Stated faithfully to the ACTUAL Mathlib
     statement** (see Strategy-modifying findings): for a CharZero field F, p∈F[X],
     d∈ℕ, `∃! h∈F[X]` whose values eventually equal the X^n-coefficient of
     `p·(1-X)^{-d}`. CharZero satisfied by ℚ. This is the **only** block I marked.
  5. **`\lemma lem:gradedHilbertSerre_rational`** `\lean{AlgebraicGeometry.gradedModule_hilbertSeries_rational}`
     `\uses{def:sectionGradedRing, def:sectionGradedModule, lem:sectionGradedModule_fg}`
     — **NEW block not in the directive's 5-item list**, added to keep the DAG
     honest (see Strategy-modifying findings): the genuine graded Hilbert–Serre
     *rationality* step (f.g. graded module ⟹ Hilbert series = `p·(1-X)^{-d}` up to
     a polynomial), which Mathlib does NOT provide. Marked as a project-side
     obligation in its prose; **NOT** `\mathlibok`. Inductive proof sketch added.
  6. **`\theorem thm:hilbertPoly_of_sectionModule`** `\lean{AlgebraicGeometry.Scheme.hilbertPolynomialOfSectionModule}`
     `\uses{lem:sectionGradedModule_fg, lem:gradedHilbertSerre_rational, lem:hilbertPoly_exists_mathlib}`
     — extracts `Φ_s` by feeding the rational series (block 5) to the Mathlib
     extraction lemma (block 4) over F=ℚ. Proof sketch added.
- **Corrected prose** in `lem:functor_is_representable_mathlib` (item 3) — but see
  the correction note below: the directive's premise was factually wrong, so I
  did NOT replace `Functor.representableBy` (which is correct); I instead added
  `Functor.representableByEquiv` in its **correct** role.

## Cross-references introduced
- `def:hilbert_polynomial` → `\uses{thm:hilbertPoly_of_sectionModule}` (same chapter). ✓
- `def:sectionGradedModule` → `def:sectionGradedRing` (same chapter). ✓
- `lem:sectionGradedModule_fg` → `def:sectionGradedModule`, `def:sectionGradedRing`. ✓
- `lem:gradedHilbertSerre_rational` → `def:sectionGradedRing`, `def:sectionGradedModule`, `lem:sectionGradedModule_fg`. ✓
- `thm:hilbertPoly_of_sectionModule` → `lem:sectionGradedModule_fg`, `lem:gradedHilbertSerre_rational`, `lem:hilbertPoly_exists_mathlib`. ✓
- `leandag build --json`: `unknown_uses: []` (no broken refs); **0 isolated nodes**
  in chapter `Picard_QuotScheme`. The 6 new `\lean{}` pins appear in
  `unmatched_lean`, which is the expected pattern for `[expected]` to-be-created
  project decls and for Mathlib anchors (the pre-existing `\mathlibok` anchor
  `CategoryTheory.Functor.IsRepresentable` is likewise in `unmatched_lean`).

## References consulted
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` (L445–L545, read this
  session) — verbatim `% SOURCE QUOTE` text (in original `$…$` notation) for
  `def:sectionGradedRing`, `def:sectionGradedModule`, `lem:sectionGradedModule_fg`
  (L453–L464), `lem:gradedHilbertSerre_rational` (L459–L464, Snapper polynomiality),
  and `thm:hilbertPoly_of_sectionModule` (L468–L478, fibrewise `Φ_s ∈ ℚ[λ]`).
- `references/summary.md` — source index.
- `.lake/packages/mathlib/Mathlib/RingTheory/Polynomial/HilbertPoly.lean` (read
  the actual statement of `existsUnique_hilbertPoly`, lines 160–215, plus the file
  outline) — to state the `\mathlibok` anchor faithfully and to discover the
  Mathlib gap.
- `.lake/packages/mathlib/Mathlib/CategoryTheory/Yoneda.lean` (lines ~285–595) —
  to verify `Functor.representableBy`, `Functor.reprX`, `IsRepresentable.has_representation`,
  and `representableByEquiv` for item 3.

## Macros needed (if any)
- None. The chapter uses only macros already present (`\Quot`, `\Hilb`, `\spec`,
  `\PP`, `\AA`, etc.) plus standard LaTeX. `\llbracket…\rrbracket` (used once for
  the power-series ring `F⟦X⟧` in the Mathlib anchor) is standard `stmaryrd`/
  `amsmath`-adjacent; if the build's preamble lacks it, swap for `F[[X]]`. Flagged
  for the plan agent to confirm at typeset; NOT added by me (out of write-domain).

## Reference-retriever dispatches (if any)
- None. All required verbatim quotes came from the Nitsure source already on disk;
  the Mathlib statements were read directly from `.lake/packages/mathlib`.

## Notes for Plan Agent
- **Item 3 premise is factually wrong (directive correction).** The directive says
  "the prose says `Functor.representableBy` — the actual Mathlib method is
  `representableByEquiv`." I verified against the pinned Mathlib
  (`Mathlib/CategoryTheory/Yoneda.lean`):
  - `Functor.representableBy` **exists** (line 573):
    `noncomputable def representableBy : F.RepresentableBy F.reprX`. The existing
    prose ("produces the canonical witness `F.RepresentableBy (F.reprX)` on the
    representing object `F.reprX`") was therefore **already correct**.
  - `representableByEquiv` (line 380) is a **different** object:
    `F.RepresentableBy Y ≃ (yoneda.obj Y ≅ F)`.

  Blindly substituting `representableBy → representableByEquiv` would have
  *introduced* an error. To honour the directive's surface intent (mention
  `representableByEquiv`) without writing a falsehood, I kept `Functor.representableBy`
  for the witness producer and added a clause naming `Functor.representableByEquiv`
  in its correct role (witness ↦ Yoneda iso). No `\lean{}` pin changed
  (`CategoryTheory.Functor.IsRepresentable` is correct, untouched).
- The existing `\leanok` markers on `def:hilbert_polynomial`, `def:quot_functor`,
  `def:grassmannian_scheme`, `thm:grassmannian_representable` were left untouched
  (sync_leanok owns them). Note: `def:hilbert_polynomial` still carries `\leanok`
  although its prose encoding changed; sync_leanok will re-evaluate against the
  current Lean stub.

## Strategy-modifying findings
**The graded encoding's pivot lemma is only HALF in Mathlib — the substantive half
(Hilbert–Serre rationality) is a project-side gap, not a Mathlib export.**

The directive describes `Polynomial.existsUnique_hilbertPoly` as
"(graded Hilbert–Serre)" and frames the strategy as routing polynomiality
"directly through Mathlib's already-verified" lemma. I read the actual Mathlib
source (`Mathlib/RingTheory/Polynomial/HilbertPoly.lean`). The lemma is:

```
theorem existsUnique_hilbertPoly (p : F[X]) (d : ℕ) [Field F] [CharZero F] :
  ∃! h : F[X], ∃ N, ∀ n > N, (p * invOneSubPow F d : F⟦X⟧).coeff n = h.eval (n : F)
```

This is **purely the polynomial-extraction step**: given a numerator `p` and a
denominator `(1-X)^d`, the eventual coefficients of `p·(1-X)^{-d}` are a unique
polynomial. It says **nothing** about graded modules. The genuine Hilbert–Serre
content — that the Hilbert function `n ↦ dim_κ M_n` of a *finitely generated
graded module M over a Noetherian graded ring* equals the coefficients of some
rational series `p·(1-X)^{-d}` — is **absent from Mathlib** (grep for
`hilbert.?serre`/`hilbert series`/`hilbertSeries` over the whole pinned Mathlib:
no hits; the `HilbertPoly` file contains only `preHilbertPoly`, `hilbertPoly`,
`coeff_mul_invOneSubPow_eq_hilbertPoly_eval`, `existsUnique_hilbertPoly`,
`eq_hilbertPoly_of_forall_coeff_eq_eval`, and degree lemmas).

**Consequence for the route.** `thm:hilbertPoly_of_sectionModule` needs a bridge
`dim_κ M_n  ⟶  p·(1-X)^{-d}` *before* it can invoke `existsUnique_hilbertPoly`.
I encoded that bridge as the new project-own lemma
`lem:gradedHilbertSerre_rational` (`\lean{AlgebraicGeometry.gradedModule_hilbertSeries_rational}`,
NOT `\mathlibok`). It is a real proof obligation (classical Hilbert–Serre,
inductive on the number of degree-1 generators / dévissage). This is mathematically
routine and still **Čech-independent / H^0-only** (so the strategy's core claim —
avoiding higher cohomology — holds), but it is **not free from Mathlib** and
should be costed as project work, not a Mathlib citation.

Recommended STRATEGY.md adjustment: under "Routes QUOT", record that the graded
encoding depends on TWO pieces — (a) Mathlib `existsUnique_hilbertPoly`
(extraction, done) and (b) an in-project graded Hilbert–Serre rationality lemma
(`gradedModule_hilbertSeries_rational`, to be proved) — rather than a single
Mathlib lemma. Also check whether Mathlib's graded-module / `Module.length` /
associated-graded machinery shortens (b); a dedicated `reference-retriever` or
Lean search pass on `Mathlib`'s graded-module length-additivity lemmas would
de-risk it before any QUOT prover dispatch.
