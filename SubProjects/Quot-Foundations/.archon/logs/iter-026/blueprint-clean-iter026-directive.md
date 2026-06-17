# blueprint-clean directive — iter-026 (Quot-Foundations)

Clean the two chapters edited this iter. Strip Lean leakage, project-history/iteration noise, and
verbosity; validate/insert missing source quotes. **Preserve all mathematically load-bearing content**
(statements, proof structure, the order-of-operations prescription) and all `% SOURCE`/`% SOURCE QUOTE`/
`% LEAN SIGNATURE` scaffolding comments — only scrub rendered-prose leakage.

## Chapter 1 — `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

Edit made this iter: the proof of `lem:base_change_mate_inner_eCancel` gained an "Order of operations
(load-bearing)" paragraph prescribing the pre-subst route (distribute the `(g')`-unit on the free
composite `e ∘ Spec ι_A` BEFORE the legs are identified with the concrete pullback projections), so the
three eCancel atoms match. Keep the mathematical content (which step precedes which, and WHY the locked
literal form blocks the atoms). Scrub the project-memory reference (`fbc-subst-legs-literal-form-lock`)
and any "recorded in project memory" phrasing — restate the obstruction purely mathematically ("the
factors agree mathematically but differ in hidden index data, so head-symbol matching fails").

## Chapter 2 — `blueprint/src/chapters/Picard_QuotScheme.tex`

Three new blocks added after `lem:qcoh_section_localization_basicOpen` (and the keystone's `\uses`/NOTE
updated):
- `lem:isLocalizedModule_tilde_restrict` (coverage debt — Spec-local core).
- `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ` (coverage debt — affine engine).
- `lem:qcoh_affine_isIso_fromTildeΓ` (gap1 — QCoh≃Mod affine descent, the keystone's missing ingredient).

Scrub iteration tags (`iter-026`, "mathlib-build lane this iter", "the planner") from the rendered prose
and NOTE comments where they leak project history; keep the mathematical NOTE that the Lean decl does not
yet exist and that the globalization is the Mathlib-absent content. Validate the Stacks "Schemes" §7
item-(4) quote on `lem:isLocalizedModule_tilde_restrict` against `references/stacks-schemes.tex`; if the
gap1 block's `% SOURCE` (quasi-coherent on affine = associated to global sections) cannot be matched to a
verbatim quote in `references/`, dispatch a `reference-retriever` (your `references/**` write-domain is
authorized) for the Stacks tag, or downgrade the `% SOURCE` to `% SOURCE: ... (verbatim text not yet
retrieved)` rather than leaving an unbacked citation.
