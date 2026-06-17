# Blueprint Writer Report

## Slug
mv-step2

## Status
COMPLETE — Step 2 of `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
now previews the four Mathlib API pieces by name; the labelled
`Implementation status (iter-108 escape-valve)` remark and the
`Status (iter-108 / Archon canonical iter-108)` paragraph in
§ "Use in the project" distinguish the L1846 budget deferral from
the project's three named Mathlib gaps.

## Target chapter
blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Changes Made

- **Expanded Step 2** of the proof sketch of
  `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (proof block
  at L1159–L1183). The original one-sentence Step 2 ("Localizing at $f$
  identifies the factor … reassembles into the Čech complex of $D(f)$
  …") is preserved verbatim as the lead, then followed by a four-item
  enumerated substep block (i)–(iv) naming the Mathlib API pieces:
  - (i) Image-Finset bridge — `Finset.inf_univ_eq_iInf`,
    `Finset.inf'_eq_inf`, `Finset.inf'_image`, plus a `le_antisymm`
    step with `Pi.π`/`Pi.lift`; with a parenthetical noting why the
    direct `CompleteLattice.finite_product_eq_finset_inf` route is
    blocked on universe grounds.
  - (ii) Restriction-of-section identity — `Scheme.basicOpen_res`.
  - (iii) Per-coord `IsLocalization.Away` — `IsAffineOpen.isLocalization_of_eq_basicOpen`
    composed with (i)–(ii); cross-references
    `thm:Scheme_basicOpenCover_finset_inf_isAffineOpen` and
    `thm:Scheme_basicOpenCover_finset_inf_isLocalization`.
  - (iv) Finite-product localization lift —
    `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`
    (`Mathlib.Algebra.Module.LocalizedModule.IsLocalization`) plus
    `IsLocalizedModule.pi` (`Mathlib.RingTheory.TensorProduct.IsBaseChangePi`).

  Step 2 closes with the ladder-transport prose: `Function.Exact.iff_of_ladder_linearEquiv`
  on `IsLocalizedModule.iso` summands, threading the cochain-degree-$0$
  end through `def:Scheme_splitEpi_pi_lift_of_injective`. Steps 1, 3, 4
  are unchanged per directive.

- **Added new `\begin{remark}[Implementation status (iter-108 escape-valve)]`
  block** with label `rem:basicOpenCover_step2_status`, placed between
  the existing `Lean implementation` remark and `\subsection{Use in
  the project}`. The remark
  - states that Steps (i)+(ii)+(iii) of the recipe are committed inline
    at `BasicOpenCech.lean:1786–1834` as ~50 LOC of `have`-declarations
    (iter-108 + iter-109 partial scaffolding), and
  - explicitly distinguishes the L1846 sorry as a **budget deferral, not
    a Mathlib gap** — citing Mathlib pin `b80f227` carrying
    `IsLocalizedModule.Away`, `IsLocalizedModule.pi`, and the algebra-adapter,
    and naming the `letI ... in <goal-type>` elaboration-friction reason
    for the deferral and the parking behind C1 promotion + Phase B
    priorities. The annotation marker `DEFERRED (budget)` versus
    `MATHLIB GAP` is named explicitly, and the project's three-Mathlib-gap
    list (`instIsMonoidal_W`, `h_exact`, `nonempty_jacobianWitness`)
    is cited to disambiguate.

- **Added `\paragraph{Status (iter-108 / Archon canonical iter-108).}`**
  after the existing "Use in the project" paragraph. It records the six
  labelled transient sorries inside the substantive theorem
  (L1120 PAUSED `cechCofaceMap_pi_smul`; L1212 substep (a) augmented
  Čech; L1536 outer `K → K₀` transport; L1564 substep (a) for `s₀`;
  L1846 budget-deferred Step 2 transport; L1754 gated on L1120
  closure), references the new `rem:basicOpenCover_step2_status`, and
  notes that the file compiles end-to-end and that the chain into
  `IsAffineHModuleVanishing` / downstream Phase A step 6 is unaffected.

## Cross-references introduced

- `\ref{thm:Scheme_basicOpenCover_finset_inf_isAffineOpen}` —
  verified existing in same chapter at L1067.
- `\ref{thm:Scheme_basicOpenCover_finset_inf_isLocalization}` —
  verified existing in same chapter at L1097.
- `\ref{def:Scheme_splitEpi_pi_lift_of_injective}` — verified
  existing in same chapter at L1121.
- `\ref{rem:basicOpenCover_step2_status}` — new label introduced
  in this iter; referenced from the § "Use in the project" status
  paragraph (intra-chapter, both directions present).
- `\ref{thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf}` —
  verified existing in same chapter at L1153 (already-existing label).

The substep prose names a number of Mathlib lemmas
(`Finset.inf_univ_eq_iInf`, `Finset.inf'_eq_inf`, `Finset.inf'_image`,
`Pi.π`, `Pi.lift`, `Scheme.basicOpen_res`,
`IsAffineOpen.isLocalization_of_eq_basicOpen`, `IsLocalizedModule.Away`,
`IsLocalizedModule.pi`, `IsLocalizedModule.iso`,
`Function.Exact.iff_of_ladder_linearEquiv`, and the adapter
`instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`).
These are upstream Mathlib references and do not require blueprint
labels — they are cited in prose only.

## Macros needed (if any)

None new. The chapter already imports the macros used
(`\Module`, `\Finite`, `\HasCechToHModuleIso`, `\HasAffineCechAcyclicCover`,
`\IsAffineHModuleVanishing`); I used only standard LaTeX
(`\texttt{...}`, `\textsf{...}`, `\emph{...}`, `\bigl[`, `\bigr]`,
`\paragraph{...}`) plus existing macros. `\texttt{...}` was not
previously used in this chapter but is part of standard LaTeX (no
preamble macro needed); the existing `\paragraph{...}` precedent
in `Picard_LineBundle.tex:17` confirms project-wide acceptance.

## Reference-retriever dispatches (if any)

None. The directive's references — `references/challenge.lean` and
`analogies/finite-product-localisation-and-cech-r-linearity.md` —
are both already on disk. I read the analogies file's Q1a/Q1b/Q1c
decisions to confirm the Mathlib API names and their file paths
(`Mathlib.Algebra.Module.LocalizedModule.IsLocalization`,
`Mathlib.RingTheory.TensorProduct.IsBaseChangePi`) before writing
the substep block. No external source needed.

## Notes for Plan Agent

- The new `\paragraph{Status (...)}` style matches the existing
  `\paragraph{Status note (Phase C1).}` precedent in
  `Picard_LineBundle.tex:17`, so the project already accepts this
  status-paragraph idiom; the blueprint-reviewer-iter108 finding on
  per-iter status acknowledgements is now mirrored on the chapter
  side as well.
- The forward reference `\ref{rem:basicOpenCover_step2_status}` from
  the "Use in the project" paragraph to the new remark resolves after
  the standard two-pass leanblueprint compile.
- The directive's suggested wording at one point said "five labelled
  transient `sorry`s" but enumerated six positions (L1120, L1212,
  L1536, L1564, L1846, L1754) consistent with the directive's
  preamble ("Its proof body has 6 transient sorries"). I wrote
  "six labelled transient `sorry`s" to match the actual count and
  the preamble; flagging this in case the plan agent prefers the
  literal directive phrasing for some downstream reason.
- The Step 2 substep block's substep (i) parenthetical names a
  Mathlib lemma that does NOT exist on `master` (the inline comment
  in the new prose says `CompleteLattice.finite_product_eq_finset_inf`
  fails on universe grounds). This is a pedagogical mention of an
  attempted-and-rejected route, not a claim that Mathlib carries
  that exact name. The prose makes the universe-mismatch rationale
  clear so a reader does not chase a non-existent identifier.

## Strategy-modifying findings

None. Writing this chapter did not surface any strategy-level issue.
The chapter's classification (`complete: partial`) is unchanged; only
the operational precision of Step 2's prose and the iter-108 Lean-state
status acknowledgement have improved.
