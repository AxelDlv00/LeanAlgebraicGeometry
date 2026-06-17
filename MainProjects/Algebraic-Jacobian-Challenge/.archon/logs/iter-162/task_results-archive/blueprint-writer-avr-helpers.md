# Blueprint Writer Report

## Slug
avr-helpers

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Changes Made
- **Added lemma** `\begin{lemma}` / `\label{lem:eq_comp_of_isAffine_of_properIntegral}` /
  `\lean{AlgebraicGeometry.eq_comp_of_isAffine_of_properIntegral}` — the PROVEN, axiom-clean
  algebraic-core helper: two $\bar k$-points (sections of $w$) of a proper, integral, locally-of-
  finite-type $\bar k$-scheme $W$ mapping into an affine $V$ compose equally with the map. Placed
  immediately BEFORE `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` so the `\uses` edge runs
  forward.
  - Proof sketch added: Y. Full route prose — $\Gamma(W)$ a field
    (`isField_of_universallyClosed`), module-finite over $\bar k$ (`finite_appTop_of_universallyClosed`),
    `IsAlgClosed.ringHom_bijective_of_isIntegral` ⟹ $\Gamma(W)=\bar k$ and $w^\sharp$ an epi on $\Gamma$,
    so $a^\sharp=b^\sharp$ by cancellation, then `ext_of_isAffine` pins the morphism. One sentence
    enumerates the load-bearing role of each hypothesis (IsAlgClosed / integral / UniversallyClosed /
    LocallyOfFiniteType / IsAffine), each with its counterexample-on-removal.
  - Project-bespoke: NO `% SOURCE:` block. A `%`-comment + prose note records that it realizes the
    "complete slice into an affine maps to a single point" step already quoted verbatim from Mumford
    Ch. II §4 p. 43 elsewhere in the chapter (no new external quote fabricated).
- **Added lemma** `\begin{lemma}` / `\label{lem:isIntegral_of_retract_of_integral}` (NO `\lean{}` —
  see below) — the retract-integrality fact: if $X\times Y$ is integral and $X$ is a retract of it
  (a section $s$ of $p_1$ with $s\fatsemi p_1 = \mathbf 1_X$), then $X$ is integral. Placed before
  `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`.
  - Proof sketch added: Y. Reduced via split-injective $p_1^\sharp$ into the reduced
    $\mathcal O_{X\times Y}$ (`isReduced_of_injective`); irreducible via continuous-surjection image
    of the irreducible $X\times Y$ (surjective because $s$ is a section); reduced + irreducible =
    integral. Elementary, no external citation.
  - `\lean{}` deliberately OMITTED (directive: do not fabricate). A `% NOTE:` instructs that the
    cross-ref be filled once the prover lands the named top-level helper (`IsIntegral X.left`).
- **Revised** proof block of `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` — added
  `\uses{lem:eq_comp_of_isAffine_of_properIntegral, lem:isIntegral_of_retract_of_integral}` (it
  previously had no `\uses` on its proof), and REPLACED the multi-line `% NOTE (iter-161 review) …
  PLAN/BLUEPRINT-WRITER TODO …` comment block with a one-line `% NOTE (iter-162):` recording that the
  documentary gap is now resolved and the node + `\uses` edge are in place.

## Cross-references introduced
- `\uses{lem:eq_comp_of_isAffine_of_properIntegral}` in proof of
  `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` — target defined two blocks above (same chapter).
- `\uses{lem:isIntegral_of_retract_of_integral}` in the same proof — target defined one block above
  (same chapter).
- Both edges run forward along the on-disk Lean dependency order (helpers precede the consumer).

## References consulted
None opened this session: both new blocks are project-bespoke (assemblies of existing Mathlib lemmas
+ elementary topology/algebra), so they carry NO `% SOURCE:` / `% SOURCE QUOTE:` lines, exactly like
the existing `lem:morphism_eq_of_eqAt_closedPoints`. The only external statement referenced in prose
(Mumford's "complete slice into an affine → single point", Ch. II §4 p. 43) is already cited verbatim
in the surrounding chain lemmas; no new quote was introduced.

## Macros needed (if any)
None new. Reused the chapter-local `\fatsemi` and the project's `\Spec`, `\mathcal`, `\mathtt`.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- `lem:isIntegral_of_retract_of_integral` carries NO `\lean{}` yet (prover has not landed the helper
  as of this writer pass). When the prover lands the top-level retract-integrality helper, fill the
  `\lean{...}` cross-ref (the `% NOTE:` at that block flags the exact spot). Until then the deterministic
  `sync_leanok` / blueprint-doctor will see a `\lean{}`-less node — expected, not an orphan.
- `lem:eq_comp_of_isAffine_of_properIntegral` is reported by the prover as already PROVEN axiom-clean;
  the deterministic `sync_leanok` should mark its statement+proof `\leanok` on the next sync (I did not
  touch any marker, per descriptor).
- Out-of-scope items (theorem of the cube §, the four already-proven chain-lemma statement blocks, all
  markers, protected signatures) were left untouched.

## Strategy-modifying findings
None. Both edits are documentary/dependency-graph additions reflecting the on-disk Lean truthfully;
no strategy-level issue surfaced.
