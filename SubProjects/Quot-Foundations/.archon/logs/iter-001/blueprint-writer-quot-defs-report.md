# Blueprint Writer Report

## Slug
quot-defs

## Status
COMPLETE

All five required changes were made to `Picard_QuotScheme.tex`. No external
verbatim quotes were added (the changes are prose tightening, one Mathlib
dependency anchor, and one `% NOTE:`), so no new `% SOURCE QUOTE:` blocks were
authored and no reference-retriever was needed. Existing citation blocks were
left untouched.

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made

1. **Fixed the broken cross-reference** (Out-of-scope section, `\Pic_{C/k}`
   bullet). Replaced `\cref{chap:Picard_FGAPicRepresentability}` — a label that
   exists only in the parent project and rendered broken — with a prose
   description of the downstream FGA Picard-representability assembly chapter,
   stated to live in the parent project that consumes this Quot-foundations
   layer. No `\cref`/`\ref` to a non-existent label remains (verified: `grep`
   for `Picard_FGAPicRepresentability` now returns nothing).

2. **Tightened `hilbertPolynomial` signature in prose** (Lean encoding,
   Phase 1). Specified that coherence of `F` is encoded as
   `[F.IsQuasicoherent] + [F.IsFiniteType]` (Mathlib has no single
   `IsCoherent` at the pin; both `SheafOfModules.IsQuasicoherent` and
   `SheafOfModules.IsFiniteType` were verified to exist at the pin). The
   proper-support-over-`S` hypothesis has **no clean Mathlib predicate**: I
   stated the minimal honest encoding (schematic support as a closed subscheme
   `Z ↪ X`, require `Z ↪ X →^π S` to be `AlgebraicGeometry.IsProper` — `IsProper`
   verified to exist), and flagged the schematic-support construction itself as
   a project-side gap at the pin. Existing `\lean{}` pin retained.

3. **Tightened `QuotFunctor` signature in prose** (Lean encoding, Phase 2).
   Added that coherence of `E` is encoded as `[E.IsQuasicoherent] +
   [E.IsFiniteType]`, same as Phase 1.

4. **Tightened `Grassmannian` signature in prose** (Lean encoding, Phase 2).
   Stated that "`V` locally free of rank `r`" has **no faithful Mathlib
   predicate at the pin**: `SheafOfModules.IsLocallyFree` was verified
   *absent* at the pinned commit (`#check` → "Unknown constant"), appearing
   only upstream, and even there it is rank-agnostic. Proposed encoding: an
   `IsLocallyFree`-style hypothesis on `V` paired with an explicit
   `r : ℕ` and the constraint `1 ≤ d ≤ r` as a hypothesis on naturals; the
   rank-`r` local-freeness predicate flagged as a project-side gap.

5. **Representability aligned with Mathlib `Functor.IsRepresentable`.**
   - Added a **Mathlib dependency anchor** `\begin{lemma}` with
     `\label{lem:functor_is_representable_mathlib}`,
     `\lean{CategoryTheory.Functor.IsRepresentable}`, marked `\mathlibok`. The
     statement records that `IsRepresentable` unfolds via
     `Functor.IsRepresentable.has_representation` to exactly
     `∃ Y, Nonempty (F.RepresentableBy Y)`, and that `Functor.representableBy`
     gives the canonical witness on `F.reprX`. All four Mathlib decls
     (`IsRepresentable`, `has_representation`, `representableBy`, `reprX`) were
     verified present at the pin via `#check`.
   - Theorem body now states the faithful target is
     `(Grassmannian V d).IsRepresentable`, so the parent can call
     `Functor.representableBy` / `reprX` at merge-back without re-bridging an
     ad-hoc existential.
   - Added the **universe-constraint** note: `RepresentableBy F Y` needs
     `F : Cᵒᵖ ⥤ Type v` with the representing object in the same `C` at
     matching hom-universe `v`; the Quot/Grassmannian functor's value universe
     must be pinned to the schemes-category hom-universe or representability
     will not typecheck.
   - Wired `\uses{lem:functor_is_representable_mathlib}` into the theorem; also
     updated the Phase-2 encoding sentence from `RepresentableBy` to the
     `IsRepresentable` spelling.

6. **Honored the `\uses{def:quot_functor}` edge** (item 4). Added a sentence to
   the `def:grassmannian_scheme` body and reinforced it in Phase 2 stating that
   `Grass(V,d)` should be **defined** as `Quot^{d,O_S}_{V/S/S}` (case `X=S`,
   `E=V`, `Φ=d`), not as an independent functor, so the structural identity is
   preserved by construction and the Grassmannian inherits functoriality/the
   equivalence relation from the Quot functor.

7. **Recorded the RelativeSpec dependency gap** (item 5, NOT resolved). Added a
   `% NOTE:` to the `thm:grassmannian_representable` block: its sketch recovers
   the representing object through the `RepresentableBy` Yoneda form "as in the
   RelativeSpec chapter", but `thm:relative_spec_univ` is currently established
   at the Lean level only as `IsAffineHom (structureMorphism 𝒜)` (verified by
   reading `Picard_RelativeSpec.tex` L198–267) — strictly weaker. The NOTE
   records the proof is blocked on either (a) strengthening RelativeSpec to a
   `RepresentableBy` witness, or (b) a `RepresentableBy`-free Grassmannian
   argument — a deferred open question. The RelativeSpec chapter was not
   edited.

## Cross-references introduced
- `\uses{lem:functor_is_representable_mathlib}` added in
  `thm:grassmannian_representable` — target is the new anchor lemma in the same
  chapter. `leandag build --json` reports `unknown_uses: []` (resolves).
- `\cref{lem:functor_is_representable_mathlib}` used in the theorem body and in
  the Phase-2 encoding paragraph — same-chapter label, resolves.
- Retained existing `\cref{chap:Picard_RelativeSpec}` (valid label at
  `Picard_RelativeSpec.tex:2`).

## Verification
- LaTeX env balance: definition 3/3, theorem 1/1, lemma 1/1, proof 1/1.
- `leandag build --json`: `unknown_uses: []`, `conflicts: []`, `mathlib_ok: 1`
  (the new anchor). My chapter has **0 isolated nodes**
  (`leandag query --isolated --chapter Picard_QuotScheme` → none). The new
  lemma is not isolated (the theorem uses it). The anchor appears under
  `unmatched_lean` mapping to `CategoryTheory.Functor.IsRepresentable` — this
  is expected for a `\mathlibok` anchor (a Mathlib decl has no project-side
  Lean source to match); it is not an error.
- Mathlib decls confirmed at the pin via `lean_run_code` `#check`:
  `Functor.IsRepresentable`, `.has_representation`, `.representableBy`,
  `.reprX`, `SheafOfModules.IsQuasicoherent`, `SheafOfModules.IsFiniteType`,
  `AlgebraicGeometry.IsProper` all **present**;
  `SheafOfModules.IsLocallyFree` **absent at the pin** (present only upstream).

## References consulted
- `references/summary.md` — confirmed the Nitsure source is the primary
  reference and that no new source was required for these (prose/encoding-level)
  changes.
- `blueprint/src/chapters/Picard_RelativeSpec.tex` (sibling, read-only) —
  confirmed `thm:relative_spec_univ` is currently `IsAffineHom`-level only, to
  ground the `% NOTE:` in item 5. (Not edited.)
- No `references/*.md` opened for a new `% SOURCE QUOTE:` block — none was
  authored this pass.

## Markers added
- `\mathlibok` on `lem:functor_is_representable_mathlib` (Mathlib dependency
  anchor only). No `\leanok` added or removed.

## Macros needed
- None. `\mathlibok` is already defined (`blueprint/src/macros/print.tex:17`).

## Notes for Plan Agent
- **`.lean` re-signing is deferred by directive.** The four stubs in
  `AlgebraicJacobian/Picard/QuotScheme.lean` still carry the weaker signatures
  (`hilbertPolynomial` takes `_L _F : X.Modules` with no coherence/proper-support
  hypotheses; `Grassmannian` takes `_V : S.Modules` `_d : ℕ` with no
  local-freeness/rank constraint; `Grassmannian.representable` returns the raw
  `∃ Y, Nonempty (RepresentableBy Y)` rather than `.IsRepresentable`). The
  blueprint now specifies the faithful target signatures; a later
  `lean-scaffolder` / refactor pass should thread these hypotheses and switch
  the representability return type to `(Grassmannian V d).IsRepresentable` so
  prose and Lean agree.
- **Two genuine encoding gaps surfaced** (flagged in prose, not resolved):
  (i) the schematic-support closed subscheme of a coherent sheaf — needed to
  encode "proper support over S" via `IsProper` — is not available at the pin;
  (ii) a rank-`r` local-freeness predicate for `SheafOfModules` does not exist
  at the pin (`IsLocallyFree` is upstream-only and rank-agnostic). Both are
  project-side sub-builds a prover will need before the stubs can be re-signed
  honestly.

## Strategy-modifying findings
The RelativeSpec dependency gap (item 5) is a route-level blocker but was
already a known deferred item recorded in `Picard_RelativeSpec.tex`
(iter-174+ commitment to upgrade `thm:relative_spec_univ` to a `RepresentableBy`
witness, still pending). It is now also recorded as a `% NOTE:` on
`thm:grassmannian_representable`. I am surfacing it here so the plan agent is
aware the Grassmannian representability PROOF cannot proceed until either
RelativeSpec is strengthened to `RepresentableBy` or a `RepresentableBy`-free
Grassmannian argument is adopted — but this does not change the chapter's
definitions/statements, only the order in which the proof bodies can be filled.
No edit to STRATEGY.md is forced by the present (definition-signature) pass.
