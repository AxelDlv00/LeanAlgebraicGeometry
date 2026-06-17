# Recommendations — next plan iter (after iter-062)

## Closest-to-completion / prioritize

1. **GR-quot `matrixEnd_pullback` (L3(a)) — frontier, atom now in hand.** The make-or-break atom
   `scalarEnd_pullback` is CLOSED axiom-clean, so (a) is now a mechanical reduction: the
   naturality-square form is already established (`rw [← Category.assoc, Iso.eq_comp_inv, matrixEnd]`);
   the residual is **distribute `(pullback p)` over the biproduct presentation (term-mode
   `(pullback p).map_comp` — positional `rw`/`simp` hit the `X.Modules` functor diamond), then reduce
   `biproduct.matrix (scalarEnd ∘ M)` per-entry to `scalarEnd_pullback (M p q)` + cofan extensionality.**
   This is the natural next prover target. Reuse the iter-062 unlocks: `change`-to-nested-application
   for the value diamond, explicit-term for diamond-blocked rewrites, `Scheme.{0}` signatures.
2. **Then (b) `baseChange_bridge` → assembly `bundleTransition_cocycle_transport` → C2.** Once (a)+(b)
   land, C2 (`bundleTransition_cocycle`) and its 3 riders (`universalQuotient`/`tautologicalQuotient`/
   `represents`) + the `glue` cocycle hyps cascade. `informal/bundleTransition_cocycle_L3_transport.md`
   holds the assembly roadmap.

## MEDIUM

3. **lean-auditor MAJOR — stale `.lean` section NOTE, GrassmannianQuot.lean:316–322 (RECURRING).** The
   `/-! ## Gluing a sheaf of modules… -/` block claims the `glue` body + cocycle hyps are "still to be
   filled" (DONE since iter-056, lines 419–456, no sorry, `_hC1`/`_hC2` in signature) AND describes the
   construction via `overRestrictPullbackIso`/`existsUnique_gluing'` — the committed code uses a descent
   equalizer of pushforwards and neither API. Review cannot edit `.lean`; the **GR prover should fix this
   comment** when it next touches the file (same region flagged iter-061 at L319–323; now 2 iters stale).
4. **Coverage debt (dag unmatched=19) — planner to blueprint these helpers.** New this iter (all
   axiom-clean, no blueprint entry): `scalarEnd_val_app`, `scalarEnd_val_app_one`, `unitHomEquiv_scalarEnd`,
   `unitToPushforward_scalarEnd_comm` (proof-internal helper for `scalarEnd_pullback`). Persistent from
   prior iters: the 7 ported private Cells lemmas (`cocycle_imageMatrix_eq'`, `imageMatrix_map_eq'`,
   `inv_mul_inv_mul_cancel'`, `isUnit_algebraMap_away_left'`, `map_map_eq_of_comp'`, `map_nonsing_inv'`,
   `mul_submatrix_col'`), `biproduct_matrix_comp`, `bundleMatrix_cancel`, `hasFiniteBiproducts_modules`,
   and the SNAP `objRestrict*`/`opensTopology` family. All are private/helper-grade — route as `private`
   hygiene blueprint blocks or leave as accepted lean_aux (lvb: 0 substantive unreferenced decls).
5. **SNAP `relativeTensorCoequalizerIso` lane has now skipped 2 consecutive iters (no committed edits).**
   `SectionGradedRing` is 0-sorry; the planned presheaf-promotion lane (`relativeTensorCoequalizerIso`)
   was assigned both iter-061 and iter-062 but the prover committed nothing either time. **Re-seed/dispatch
   explicitly** (confirm the scaffold keyword sits on the filename line per memory
   `scaffold-keyword-same-line-as-lean-filename` — the iter-061 drop cause). If it stalls a 3rd time,
   investigate whether the BUILD task is being dropped by the no-op filter rather than genuinely worked.

## LOW

6. lvb minor #2: `lem:gr_scalarEnd_pullback`'s `\uses` credits `lem:gr_pullbackFreeIso` but the proof
   uses `pullbackObjUnitToUnit` directly — harmless `\uses` DAG overstatement; tidy when convenient.
7. Optional blueprint `% NOTE:` on `lem:gr_scalarEnd_pullback`'s proof recording the adjunction-transpose
   route via `unitToPushforward_scalarEnd_comm` (lvb rec) — would help the (a) prover reuse the pattern.

## Do NOT retry / standing guidance
- **Do NOT** attack the value-level ModuleCat diamond with `comp_apply`/`hom_comp` spellings —
  `change`-to-nested-application is the established lever (iter-062).
- **Do NOT** sign the `scalarEnd`/`matrixEnd`-pullback lemmas at `Scheme.{u}` — universe-0 only.
- C2 itself is NOT a direct prover target until (a)+(b) close — it cascades, don't grind it.
