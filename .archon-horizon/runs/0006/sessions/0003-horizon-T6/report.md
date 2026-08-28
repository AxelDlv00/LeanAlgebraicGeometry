## Summary
- T6's one reachable target — the dead-code cleanup — is **done as a single Lean+blueprint pass**, and the build is green.
- Key unblock: I-0038/I-0039 assumed the T6 session would be Lean-only, but this session's write scope was `SubProjects/Albanese/**` (blueprint included), so no Ground handoff was needed.
- Per the Ground recommendation, the 00OF/0AVF/Milne-blocked proof sorries were deliberately **not** attempted.

## Progress
- `CodimOneExtension.lean`: deleted the superseded chain at **L628–883** (~256 LOC, I-0039's corrected range, not T6's L647–871): `MvPolynomial.maximalIdeal_height_*` ×4 → `ringKrullDim_localization_atMaximal_MvPolynomial` → `ringKrullDim_quotient_add_eq_of_regular_sequence` → both `submersivePresentation_relation_cotangent_mk_linearIndependent` lemmas → terminal composite. Kept live `ringKrullDim_localization_eq_height_atPrime`; rewrote the stale 00OE section comment. File 1937→1682 lines.
- `blueprint/src/chapters/Albanese_CodimOneExtension.tex`: removed the 9 dead `\lean` nodes; re-pointed `lem:smooth_algebra_krull_dim_formula`'s two `\uses` lists to the live `StandardSmoothDimension` chain; fixed the dangling `matsumura` cref; replaced the superseded `subsec:stage6_iib_substrate_iter200` body with a supersession note (label kept — 3 `\ref` sites); fixed the Mathlib-API-state bullet; pruned `blueprint/lean_decls` 906→897.
- **Decisive checks**: `lake build` exit 0 (8581 jobs); sorry set byte-for-byte unchanged (CodimOneExtension ×3, Thm32 ×1, AlbaneseUP ×7, FGAPic ×2, WeilDivisor ×1, GmScaling ×1); zero references to deleted names remain in `*.lean`/`*.tex` (including LaTeX-escaped forms); `horizon blueprint` ok — Albanese 284 nodes / 161 edges / 0 dangling; DAG node `lem:smooth_algebra_krull_dim_formula` now has 6 live direct deps.
- Inbox/roadmap: commented + completed `I-0038`, `I-0039`; task comment on T6; roadmap comment on `ALB.codim1` (should stay **active**); new memory `I-0040` on the write-scope-vs-write_set discrepancy.

## Issues
- No new issues. Pre-existing, unchanged: the 4 in-scope sorries stay blocked on Stacks 00OF / 0AVF / Milne 3.3 machinery.
- Generated `blueprint/web/*.html` still shows the deleted nodes until the next blueprint web build (plastex not run here).
- Observed engine quirk (pre-existing): leandag registers only statement-env `\uses`, not proof-env ones — hence the 173 "isolated" figure; house style says proof-env placement is correct, so I did not churn it.

## Next
- Ground: regenerate the blueprint web output; optionally purify the remaining iteration-history narrative in the chapter (pre-existing math-purity debt).
- Net sorry progress on Albanese now requires the 00OF homological build, 0AVF, or redirecting slots to `AJC.pic0av`/FGA representability — per I-0038's option (c).
