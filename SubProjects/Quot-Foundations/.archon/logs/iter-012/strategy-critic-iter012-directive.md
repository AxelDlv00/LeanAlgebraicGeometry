# Strategy-critic — iter-012 (fresh-context strategy audit)

Read these and ONLY these, as a fresh mathematician with no investment in the project's momentum:

- `STRATEGY.md` (verbatim — the current strategy, just edited this iter).
- `references/summary.md` (the reference index).
- The chapter titles + one-line topic of each `blueprint/src/chapters/*.tex` (read the first
  `\chapter{...}` line and the first lemma/def of each; do NOT read the iter sidecars,
  `PROGRESS.md`, `task_pending.md`, task results, or any per-iter narrative).

## Project goal (one paragraph)

Close the seven `sorry`-bearing nodes of the Čech-independent leg of the parent's
`thm:fga_pic_representability` cone (Kleiman FGA "The Picard scheme" §4): flat base change for the
pushforward (i=0), generic flatness (algebraic core + geometric wrapper), and the Quot/Grassmannian
foundations (Hilbert polynomial, Quot functor, Grassmannian scheme + representability). End-state:
zero project sorry in the closure, zero project axioms, kernel-only axioms; names/labels match the
parent so the work merges back.

## What changed in STRATEGY this iter (focus your scrutiny here)

1. **QUOT predicate progress recorded as DONE**: `def:modules_annihilator`, `def:schematic_support`,
   `def:has_proper_support` are now formalized axiom-clean via Mathlib's `IdealSheafData.ofIdeals` /
   `.subscheme` — crucially WITHOUT the QCoh→`IsLocalizedModule` bridge the strategy previously said
   they depended on. Only the *forward characterization* of the annihilator is bridge-gated.
2. **New Mathlib gap recorded**: the bridge `lem:qcoh_section_localization_basicOpen` is itself blocked
   on a new sub-build `isIso_fromTildeΓ_of_isQuasicoherent` (quasi-coherent sheaf on an affine scheme
   ≅ tilde of its global sections); Mathlib has only the *global-presentation* form
   (`isIso_fromTildeΓ_of_presentation`), and `IsQuasicoherent` supplies only a cover-local
   presentation. Flagged as a multi-iter Mathlib-gradient lane.
3. **FBC-A residual re-scoped**: `regroupEquiv` is CLOSED; the residual section-identity is to be
   effort-broken into 3 sub-lemmas (unit-value / fstar-reindex / gstar-transpose) — the abstract
   adjoint-mate tower the parent used is dropped in favor of a direct-on-sections identity.

## Questions to answer

- Is the QUOT decision to build the predicates via `IdealSheafData.ofIdeals` (and defer the forward
  characterization to the bridge sub-build) sound, or does some downstream consumer NEED the forward
  characterization sooner than the strategy implies?
- Is the `isIso_fromTildeΓ_of_isQuasicoherent` sub-build the right Mathlib-gradient target, or is
  there a shorter route to the basic-open localization fact that avoids the global-presentation
  detour?
- Is the FBC direct-on-sections route (dropping the abstract adjoint-mate tower) still sound now that
  the residual LHS unwinding turns out to need its OWN 3-sub-lemma adjoint-mate decomposition — i.e.
  did dropping the tower actually buy anything, or has it reappeared one level down?
- Any other structural concern, route redundancy, or missing prerequisite.

Record any CHALLENGE/REJECT explicitly; the planner must rebut or address each.
