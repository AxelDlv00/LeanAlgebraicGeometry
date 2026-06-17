# Blueprint Reviewer Directive (SCOPED RE-REVIEW — fast path)

## Slug
rescope

## Scope
This is a same-iter fast-path re-review scoped to ONE chapter:
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. The prior full review
(slug `init-bp`) returned this chapter `complete: true`, `correct: partial` with a
SINGLE must-fix. A blueprint-writer has now applied the fix. Confirm the must-fix is
resolved and render a fresh `complete`/`correct` verdict for THIS chapter only. You
still read the whole chapter, but you do not need to re-audit the other two chapters.

## The must-fix that was supposed to be fixed
`lem:tensorobj_inverse_invertible` (`\lean{...exists_tensorObj_inverse}`, statement
~L1355) — its `\begin{proof}` block previously opened with stale
"\textbf{Infrastructure-blocked.} … not realizable …" language. The writer rewrote
it to a real 3-step proof (L⁻¹ exists as sheaf dual via `def:presheaf_internal_hom` /
`lem:internal_hom_isSheaf`; Step 1 line-bundle via `lem:dual_isLocallyTrivial`; ε_L
via `lem:internal_hom_eval`; Step 3 local→global via `lem:tensorobj_restrict_iso`),
with a "Downstream Lean dependency" note that the body consumes `lem:dual_restrict_iso`.

## What to confirm
1. The stale "Infrastructure-blocked / not realizable / cannot be named / placeholder"
   framing is GONE from that proof block.
2. The replacement proof is mathematically sound and prover-usable, and the
   `\uses{}` (now including `lem:dual_restrict_iso`) is accurate.
3. `% SOURCE:` / `% SOURCE QUOTE:` / `\textit{Source:}` (Stacks 01CR) remain intact.
4. No new must-fix introduced; `leandag build` `unknown_uses` still empty for this chapter.

## Gate question (answer explicitly)
Does `Picard_TensorObjSubstrate.tex` now read `complete: true` AND `correct: true`
with NO must-fix-this-iter finding? This clears the HARD GATE for all 5 covered
files: `TensorObjSubstrate.lean`, `DualInverse.lean`, `StalkTensor.lean`,
`PresheafInternalHom.lean`, `Vestigial.lean`.

## Known issues (do NOT re-report as must-fix)
- `lem:leftadjointuniq_app_unit_eta_general` carries `\lean{...leftAdjointUniqUnitEta_app}`
  (name mismatch vs label slug) — the underlying decl EXISTS and is closed; this is a
  cosmetic label/lean-name drift for the review agent, not a gate blocker.
- 3 forward-reference unmatched `\lean{}` (the two iso seeds + the consumer) — known
  scaffold targets, decls not yet created; not a gate blocker for the 6 open sorries.
- Broken `\cref{}` to missing sibling/parent chapters — rendering-only, no gate impact.
