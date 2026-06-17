# Directive — blueprint-writer `barescheme-pins`

## Slug

`barescheme-pins`

## Chapter

`blueprint/src/chapters/AbelianVarietyRigidity.tex` (consolidated;
covers `BareScheme.lean` via `archon:covers`).

## Goal

Add two dedicated `\begin{lemma}` blocks for the two scaffold sorrys
in `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean:151-163`:

- `AlgebraicGeometry.projectiveLineBar_smoothOfRelDim` (L161-163)
- `AlgebraicGeometry.projectiveLineBar_geomIrred` (L154-156)

Per blueprint-reviewer `iter195` HARD GATE finding, the absence of
`\lean{...}` declaration blocks for these two scaffold sorrys blocks
the iter-195 NEW LANE dispatch on BareScheme.lean.

## Specific edits

### Placement

Insert the two blocks IMMEDIATELY AFTER the `def:p1bar_zero`
through `def:gm_one` per-decl Lean coverage hook block (currently
ending around L950 with `def:gm_one`). The new lemmas characterize
the bundle properties of `ProjectiveLineBar` (smoothness +
geometric irreducibility) that `def:genus0_base_objects` describes
informally.

### Block 1 — `projectiveLineBar_smoothOfRelDim`

Authoritative declaration form (verbatim from `BareScheme.lean:161-163`):

```lean
instance projectiveLineBar_smoothOfRelDim (kbar : Type u) [Field kbar] :
    SmoothOfRelativeDimension 1 (ProjectiveLineBar kbar).hom := sorry
```

Blueprint block:

```latex
\begin{lemma}
  [\(\mathbb P^1_{\bar k}\) is smooth of relative dimension \(1\)]
  \label{lem:projectiveLineBar_smoothOfRelDim}
  \lean{AlgebraicGeometry.projectiveLineBar_smoothOfRelDim}
  % Archon-original instance; the mathematics is textbook (Hartshorne
  % II.8.20 for projective space smoothness over a field; the relative
  % dimension is the projective dimension n=1 for \(\mathbb P^1\)). No
  % external SOURCE QUOTE needed.
  The structure morphism \((\mathtt{ProjectiveLineBar}\,\bar k)
  .\mathrm{hom} \colon \mathbb P^1_{\bar k} \to \Spec \bar k\) is smooth
  of relative dimension \(1\). The proof uses the standard 2-chart
  affine cover by \(D_+(X_0)\) and \(D_+(X_1)\) (each chart is
  \(\Spec(\bar k[t])\) where \(t\) is the affine coordinate
  \(X_i/X_{1-i}\)); each chart is standard smooth via the polynomial
  ring presentation, hence smooth over \(\Spec \bar k\); the relative
  dimension equals \(1\) via the single generator \(t\) of the
  polynomial ring. The smoothness on each chart lifts to smoothness on
  \(\mathbb P^1_{\bar k}\) via the open-cover gluing
  (\texttt{Smooth\char`_iff\char`_atOpens}).
\end{lemma}
```

### Block 2 — `projectiveLineBar_geomIrred`

Authoritative declaration form (verbatim from `BareScheme.lean:154-156`):

```lean
instance projectiveLineBar_geomIrred (kbar : Type u) [Field kbar] :
    GeometricallyIrreducible (ProjectiveLineBar kbar).hom := sorry
```

Blueprint block:

```latex
\begin{lemma}
  [\(\mathbb P^1_{\bar k}\) is geometrically irreducible]
  \label{lem:projectiveLineBar_geomIrred}
  \lean{AlgebraicGeometry.projectiveLineBar_geomIrred}
  % Archon-original instance; the mathematics is textbook (Hartshorne
  % II.4 + I.1; \(\Proj\) of an integral domain over a field is
  % integral and geometrically integral when the field is algebraically
  % closed and the polynomial ring is well-defined). No external SOURCE
  % QUOTE needed.
  The structure morphism \((\mathtt{ProjectiveLineBar}\,\bar k)
  .\mathrm{hom} \colon \mathbb P^1_{\bar k} \to \Spec \bar k\) is
  geometrically irreducible: for every field extension \(K/\bar k\),
  the base change \(\mathbb P^1_{\bar k} \times_{\Spec \bar k} \Spec K
  = \mathbb P^1_K\) is irreducible. Since \(\bar k\) is algebraically
  closed and \(\bar k[X_0, X_1]\) is the polynomial ring (integral
  domain), \(\mathbb P^1_{\bar k} = \Proj(\bar k[X_0, X_1])\) is
  integral, and the base change to any field extension \(K\) preserves
  integrality (the homogeneous coordinate ring \(K[X_0, X_1]\) is
  itself an integral domain, hence \(\mathbb P^1_K\) is integral and
  irreducible).
\end{lemma}
```

## Verification

Both Lean declaration names must match `BareScheme.lean:151-163`
verbatim. The current names are:

- `AlgebraicGeometry.projectiveLineBar_smoothOfRelDim` (lower-case
  `projectiveLineBar`).
- `AlgebraicGeometry.projectiveLineBar_geomIrred` (lower-case
  `projectiveLineBar`).

If the Lean declaration names differ from what is shown above, ADJUST
the `\lean{...}` line to match the actual Lean declaration name. The
declaration must EXIST in the project (or be created by the same
writer round); the blueprint-doctor will lint this.

## What you may NOT do

- DO NOT add `\leanok` or `\mathlibok` markers. Those are
  managed by the deterministic `sync_leanok` phase and the review
  agent respectively.
- DO NOT edit any other chapter.
- DO NOT modify the existing `def:genus0_base_objects` definition or
  any other declaration block. ONLY add the 2 new lemma blocks.
- DO NOT introduce any new `\uses{...}` cycles. Both new lemmas can
  optionally `\uses{def:genus0_base_objects}`.

## Output

Write a brief task_results report summarising:
- Final chapter line numbers of the 2 new blocks.
- The two `\lean{...}` declaration names used (verified against
  current `BareScheme.lean`).
- Any minor wording adjustments to the prose I named above.
- Build status (`pdflatex` or `make` if possible; otherwise just
  confirm the LaTeX is well-formed).
