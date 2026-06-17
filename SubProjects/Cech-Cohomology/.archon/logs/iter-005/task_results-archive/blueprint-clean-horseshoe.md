# Blueprint Clean Report — horseshoe

**Chapter:** `blueprint/src/chapters/Cohomology_AcyclicResolution.tex`
**Iteration:** 005

## Status: COMPLETE

## Changes Made

### 1. Subsection intro (L191–200): stripped Lean/process leakage

**Removed:**
- `(modelled on Mathlib's \texttt{InjectiveResolution.ofCocomplex})` — implementation note citing a Mathlib internal; replaced with plain "by induction on degree".
- `with no sorry-free partial fragment when attempted wholesale` — prover-process phrasing; removed entirely.
- `We therefore isolate its independent moving parts` (the "therefore" followed from the prover logic) — reworded without the causal link to proof-attempt history.
- `\(I_A : \mathrm{InjectiveResolution}\,A\)` Lean-style type annotation — replaced with `\(I_A\) and \(I_C\) are fixed injective resolutions of \(A\) and \(C\)`.

### 2. `lem:horseshoe_degree_split` (L230–231): removed downstream implementation note

**Removed:** `supplying exactly the degreewise-splitting data the downstream comparison (\(\mathrm{rightDerivedShiftIsoOfSplitResolutionSES}\)) consumes` — Lean identifier used as implementation annotation.

**Replacement:** `furnishing the degreewise-splitting data required for the construction.`

### 3. `lem:horseshoe_twist` statement (L282–285): removed `\mathrm{Injective.factorThru}` implementation note

**Removed:** `(\(\mathrm{Injective.factorThru}\))` parenthetical naming the Mathlib function.

**Result:** the sentence reads purely in terms of the universal lifting property.

### 4. `lem:horseshoe_twist` proof (L291–293): removed `\mathrm{factorThru}` parenthetical

**Removed:** `(this is \(\mathrm{factorThru}\))` from the augmentation construction sentence; the mathematical content (extension along a monomorphism into an injective) is fully described by the surrounding text.

## Not Changed (per directive)

- All `\leanok` markers (L128, L404, L445) — untouched; owned by `sync_leanok`.
- `% NOTE (iter-004 review)` comment block (L408–416) — preserved as instructed.
- All `\lean{}` target names and `\label{}` identifiers — untouched.
- `\mathlibok` anchors on `lem:horseshoe_biprod_injective` and `lem:horseshoe_degree_split` — kept; these are genuine Mathlib dependency anchors.
- `\mathrm{factorThru}(\alpha, S.f)` in the statement formula of `lem:horseshoe_stage_mono` — kept; used as mathematical notation naming the constructed map, not an implementation note.
- `\texttt{ShortComplex.Splitting}` in `lem:horseshoe_degree_split` — kept; it is the Mathlib structure name naming what the `\mathlibok` block provides.
- No SOURCE QUOTE fabricated for the new sub-lemmas; they inherit the Weibel Lemma 2.2.8 citation from the parent block.

## LaTeX Validity

- All `\begin{lemma}…\end{lemma}`, `\begin{proof}…\end{proof}`, `\begin{theorem}…\end{theorem}`, `\begin{definition}…\end{definition}` pairs verified balanced.
- All `\uses{}` / `\label{}` / `\lean{}` cross-references reviewed; no orphan or malformed entries found.
