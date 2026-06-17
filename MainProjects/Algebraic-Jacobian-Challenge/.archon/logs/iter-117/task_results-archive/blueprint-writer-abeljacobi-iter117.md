# Blueprint Writer Report

## Slug

abeljacobi-iter117

## Status

COMPLETE

## Target chapter

`blueprint/src/chapters/AbelJacobi.tex`

## Changes Made

- **Revised chapter intro** — added a sentence summarising that every block in the chapter closes by a single projection from the Albanese structure, with the classical Pic-scheme description preserved as forward-looking remarks. Kept the existing reference to Chapter~\ref{chap:Genus} and Definition~\ref{def:Jacobian}.

- **Revised `def:ofCurve`** (`\definition`, `\label{def:ofCurve}`, `\lean{AlgebraicGeometry.Jacobian.ofCurve}`) — rewrote the body so the leading mathematical content is the Albanese-projection definition: $\alpha_P := \iota_P$, where $\iota_P$ is the universal pointed morphism carried by the Albanese structure $\mathrm{IsAlbanese}\,C\,P\,\Jac(C)$ supplied by Theorem~\ref{thm:nonempty_jacobianWitness}. Updated `\uses{...}` to `{def:Jacobian, def:IsAlbanese, thm:nonempty_jacobianWitness}` to record the new dependencies. Existing `\leanok` marker preserved in place.

- **Added remark** `\label{rem:ofCurve_classical}` titled "Classical description (Pic-scheme route)" — relocates the Pic-scheme / $\mathcal O_{C\times C}(\Delta - p_1^* P)$ description to a remark with an explicit "Lean implementation does not follow this route; see Layer~I of Chapter~\ref{chap:Jacobian}" cross-reference.

- **Revised proof of `lem:comp_ofCurve`** — replaced the line-bundle restriction argument with a short paragraph stating the Lean closure is the pointed-property field projection from $\mathrm{IsAlbanese}\,C\,P\,\Jac(C)$ (the field encoding $P \circ \iota_P = \eta$). Existing `\leanok` markers preserved.

- **Added remark** `\label{rem:comp_ofCurve_classical}` titled "Classical description" — relocates the classical $k$-point computation $\alpha_P(P) = [\mathcal O_C(P-P)] = [\mathcal O_C] = 0$ and the global line-bundle restriction argument to a remark with explicit note that the classical content is not used in the Lean formalisation.

- **Revised proof of `thm:exists_unique_ofCurve_comp`** — restructured into the requested two-stage shape:
  - *Lean closure*: the existence-and-uniqueness assertion is exactly the universal-property field of $\mathrm{IsAlbanese}\,C\,P\,\Jac(C)$, applied to the data $(f, hf)$.
  - *Classical description*: cross-references Theorem~\ref{thm:nonempty_jacobianWitness} Routes A and B (positive genus) and sub-cases C.1--C.3 (genus-$0$ rigidity), with explicit note that this classical content is not replayed on the Lean side.
  - `\uses{...}` updated to `{def:IsAlbanese, thm:nonempty_jacobianWitness, def:ofCurve, lem:comp_ofCurve}`; existing `\leanok` markers preserved.

- **Revised closing "Implementation route via the Albanese framework" section** — tightened the prose to explicitly name the Layer~I / Layer~II structure (matching Chapter~\ref{chap:Jacobian}'s own organisational principle), with explicit cross-references to the three results of the chapter and to the catalog of missing-Mathlib infrastructure in the proof of Theorem~\ref{thm:nonempty_jacobianWitness}.

  Proof-sketch shape: each block now leads with the Lean closure (Albanese projection); classical content is documented as a remark / sub-paragraph with an explicit "not used in the Lean formalisation" caveat.

## Cross-references introduced

The following `\uses{...}` cross-references are now present in this chapter; the listed labels live in `Jacobian.tex` (verified by reading that chapter):

- `\uses{def:Jacobian, def:IsAlbanese, thm:nonempty_jacobianWitness}` in `def:ofCurve` — all three labels exist (`Jacobian.tex` lines 25, 50, 140).
- `\uses{def:ofCurve, thm:nonempty_jacobianWitness}` in `rem:ofCurve_classical` — both exist.
- `\uses{def:ofCurve, def:IsAlbanese}` in `lem:comp_ofCurve` — both exist.
- `\uses{def:ofCurve, def:IsAlbanese, thm:nonempty_jacobianWitness}` in proof of `lem:comp_ofCurve` — all exist.
- `\uses{def:ofCurve, lem:comp_ofCurve, rem:ofCurve_classical}` in `rem:comp_ofCurve_classical` — all exist within this chapter.
- `\uses{def:ofCurve, lem:comp_ofCurve, def:IsAlbanese}` in `thm:exists_unique_ofCurve_comp` — all exist.
- `\uses{def:IsAlbanese, thm:nonempty_jacobianWitness, def:ofCurve, lem:comp_ofCurve}` in proof of `thm:exists_unique_ofCurve_comp` — all exist.

New labels introduced in this chapter (consumable by sibling chapters if desired):

- `rem:ofCurve_classical`
- `rem:comp_ofCurve_classical`

## Macros needed (if any)

None. All commands used (`\Spec`, `\Pic`, `\Jac`, `\Hom`, `\mathcal{O}`, `\Delta`, `\mathbf{1}`, etc.) are already defined in `blueprint/src/macros/common.tex` or are standard LaTeX/AMS.

## Reference-retriever dispatches (if any)

None. The directive's required content is descriptive (rewrite shape of existing prose, redirect classical content into remark blocks) and does not introduce new mathematical claims that need source-grounding beyond what is already in the Lean docstring at `AlgebraicJacobian/AbelJacobi.lean` L14--28 and in the existing sibling chapter `Jacobian.tex` (`def:IsAlbanese`, `thm:nonempty_jacobianWitness`).

## Notes for Plan Agent

- The closing "Implementation route via the Albanese framework" section is now arguably partially redundant with the per-block remarks: each block now states the Lean-implementation route directly in its proof body. I kept the section because the directive's "Expected outcome" said total chapter length should be similar to the current and called for a Layer-I/Layer-II shape matching `Jacobian.tex`. If a later writer wants to fold this section's content into the chapter intro instead, it can be done without information loss.

- The directive's reference to `(Classical.choose_spec h).2 f hf` in the proof restructuring instruction for `thm:exists_unique_ofCurve_comp` is one level lower than the actual Lean closure, which is `((jacobianWitness C).isAlbaneseFor P).exists_unique_ofCurve_comp f hf`. I described this in mathematical terms ("projection of the universal-property field of the Albanese witness") rather than literally citing `Classical.choose_spec`, in keeping with the "use mathematical, not Lean-syntactic prose" rule. No information loss; the mathematical content is the projection from a chosen-witness universal-property field.

- No sibling-chapter inconsistencies spotted. `Jacobian.tex` already uses the Layer-I/Layer-II split and the Albanese-witness narrative I cross-reference; the chapter is consistent with what this rewrite needs to lean on.

## Strategy-modifying findings

None. Writing the chapter surfaced no strategy-level issue. The Albanese-projection route is mathematically equivalent to the classical Pic-scheme route (modulo the deferred existence hypothesis in `thm:nonempty_jacobianWitness`), exactly as `STRATEGY.md`-level decisions for this iteration assume; rewriting the chapter to lead with the Albanese projection just brings the prose into alignment with the existing Lean implementation, without changing what either side is claiming.
