# Blueprint Writer Report

## Slug
fbc-reroute

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Verification of directive's Lean claims (done before editing)
- `base_change_mate_section_identity` (Lean 1550) closes via `exact base_change_mate_gstar_transpose ψ φ M`
  (Lean 1567), after `unfold pushforwardBaseChangeMap; rw [Adjunction.homEquiv_counit]`. It uses
  `base_change_mate_domain_read` (Θ_src) and `base_change_mate_codomain_read` (Θ_tgt) directly; it does
  **not** reference `base_change_mate_fstar_reindex`. ✔
- `base_change_mate_fstar_reindex` / `_legs` appear in the Lean file only inside comments and the
  self-referential `exact base_change_mate_fstar_reindex_legs …` (Lean 1479) — nothing live consumes them. ✔
- `eCancel`, `affineUnit`, `innerMatch`: 0 Lean declarations (only mentioned in two comment lines). The
  three blueprint blocks pinned `\lean{}` to non-existent decls. ✔
- `base_change_mate_domain_read` (Lean 737), `pullback_fst_snd_specMap_tensor` (Lean 709),
  `base_change_mate_gstar_transpose` (Lean 1490, carries the live `sorry`) all present as described. ✔

## Changes Made
- **Deleted** the three phantom blocks (broken `\lean{}` pins to non-existent Lean decls):
  `lem:base_change_mate_fstar_reindex_legs_eCancel`,
  `lem:base_change_mate_fstar_reindex_legs_affineUnit`,
  `lem:base_change_mate_fstar_reindex_legs_innerMatch`.
- **Fixed dependencies** `lem:base_change_mate_fstar_reindex_legs` — removed the three phantom labels from
  both the statement-level and proof-level `\uses{}`; rewrote the step-(iii) proof chain (which had
  `\ref`-ed the deleted phantom blocks) to describe the cancellation/affine-unit/inner-value moves inline,
  citing only live lemmas (`codomain_read_legs`, `pullback_isEquivalence_of_iso`,
  `gammaMap_pushforwardComp_hom_eq_id`, `pushforward_spec_tilde_iso`,
  `base_change_mate_unit_value`, `def:base_change_mate_inner_value`). Added a "Superseded" note.
- **Revised** `lem:base_change_mate_fstar_reindex_legs_unitExpand`,
  `lem:base_change_mate_fstar_reindex_legs_gammaDistribute`,
  `lem:base_change_mate_fstar_reindex` — added a "Superseded" paragraph to each stating it is part of the
  abandoned first route to the section identity, replaced by the direct domain-read route
  (`domain_read` + `codomain_read` + `gstar_transpose`), retained only pending dead-code removal. `\lean{}`
  pins and `% SOURCE`/`% SOURCE QUOTE` comments preserved.
- **Revised** `lem:base_change_mate_codomain_read_legs` — removed the stale "free variables / substituting
  the defining equation" narrative; now describes the construction accurately as *parametrised by the
  leg-equality proofs* `(g', f', h_fst, h_snd)` carried as data, and states that this
  proof-parametrisation (the proofs sit inside dependent pushforward/pullback data and cannot be
  eliminated by rewriting downstream) is exactly why the route was abandoned. Added a "Superseded" note.
  `\uses{}` unchanged (it never referenced the phantom labels).
- **Revised** `lem:base_change_mate_gstar_transpose` — removed `lem:base_change_mate_fstar_reindex` from
  both statement and proof `\uses{}` and added `lem:base_change_mate_unit_value` (Seam 1), which is now the
  source of the value `ρ : m ↦ (1⊗1)⊗m`. Rewrote prose so it is presented as the *live remaining FBC
  frontier crux* feeding the section identity directly, no longer "the pullback-side companion of Seam 2"
  drawing `ρ` from the dead `fstar_reindex`. Updated the `% RECIPE` comment correspondingly.
- **Revised** `lem:base_change_mate_section_identity` — statement `\uses{}` dropped
  `lem:base_change_mate_fstar_reindex` and `lem:base_change_mate_unit_value`, keeping the live structural
  deps `{def:pushforward_base_change_map, base_change_mate_domain_read, base_change_mate_codomain_read,
  base_change_mate_regroupEquiv}`; proof `\uses{}` set to exactly the three live derivation nodes
  `{base_change_mate_domain_read, base_change_mate_codomain_read, base_change_mate_gstar_transpose}`.
  Rewrote the proof prose so the identity is derived as the immediate counit-factorisation consequence of
  `gstar_transpose` conjugated by the two reads — matching the live Lean proof — instead of chaining
  through the dead `fstar_reindex`.

## Cross-references introduced
- `lem:base_change_mate_section_identity` proof now `\uses{base_change_mate_domain_read,
  base_change_mate_codomain_read, base_change_mate_gstar_transpose}` — all live, present in this chapter.
- `lem:base_change_mate_gstar_transpose` now `\uses{… base_change_mate_unit_value}` (Seam 1, live, present
  in this chapter) in place of `base_change_mate_fstar_reindex`.
- `lem:base_change_mate_fstar_reindex_legs` proof now `\uses{… pullback_isEquivalence_of_iso,
  base_change_mate_unit_value, pushforward_spec_tilde_iso, def:base_change_mate_inner_value,
  gammaMap_pushforwardComp_hom_eq_id}` (all live, present in this chapter) in place of the three phantom
  labels.

## Verification after editing
- `leandag build --json`: **`unknown_uses: []`** (no broken `\uses{}` anywhere in the blueprint);
  `conflicts: []`. The three phantom `\lean{}` pins no longer appear in `unmatched_lean`
  (phantom-unmatched check returns empty). The single project-wide isolated node is a `lean_aux` node
  outside this chapter; `leandag query --isolated --chapter Cohomology_FlatBaseChange` returns none.
- LaTeX environments balanced: 43 `\begin{lemma}`/43 `\end{lemma}`, 37/37 `\begin{proof}`/`\end{proof}`,
  2/2 definitions, 1/1 theorem.
- No `\leanok` added or removed (existing markers on the kept blocks were left untouched; the deleted
  phantom blocks carried none).

## References consulted
None opened this session — this was a blueprint-to-Lean reconciliation with no new source material. All
existing `% SOURCE` / `% SOURCE QUOTE` comments on the surviving blocks were preserved verbatim.

## Deviation from the directive (flagged for transparency)
- Directive item 3 said to set `lem:base_change_mate_section_identity`'s `\uses{}` "exactly [to] those
  three" at both statement and proof level. I made the **proof-level** `\uses{}` exactly the three
  (`domain_read`, `codomain_read`, `gstar_transpose`), matching the live Lean proof. I kept the
  **statement-level** `\uses{}` as `{def:pushforward_base_change_map, domain_read, codomain_read,
  regroupEquiv}` because the statement is literally *about* the base-change map and asserts it equals
  `regroup⁻¹` — these are genuine, **live** structural dependencies of the statement, and dropping them
  would remove true edges from the DAG (my descriptor requires `\uses{}` to match the real mathematics).
  The dead `fstar_reindex` edge and the now-indirect `unit_value` edge were removed from both, which is
  the substantive intent of the item. If the plan agent prefers the statement-level list trimmed to the
  literal three, that is a one-line change.

## Notes for Plan Agent
- `lem:pullbackPushforward_unit_comp` (NOT in my edit list, line ~1533) still describes itself as the
  "engine consumed by Seam 2 (`base_change_mate_fstar_reindex`)". The `\ref` resolves (the block still
  exists), so this is not a broken reference, but the prose is now stale given the route swap. It can be
  updated to "consumed by the superseded Seam-2 reindex apparatus" when those dead blocks are physically
  removed next iter.
- A `% RECIPE`/`% LEAN SIGNATURE` comment in `gstar_transpose` (line ~2007) still points to
  `lem:base_change_mate_fstar_reindex` as the place where the shared notation `inner`, `Z`, `f'`, `g'` is
  introduced. It is an invisible LaTeX comment (no DAG effect) and the target still exists; left as a
  harmless notation pointer. Will become removable with the dead-code-removal refactor.
- The Lean docstring/comments of `base_change_mate_gstar_transpose` (e.g. "Uses: `base_change_mate_fstar_reindex`
  (Seam 2)", line ~1519 of the .lean) still frame the open `sorry` as drawing `ρ` from the dead Seam 2.
  That is a `.lean` file (outside my write-domain); flagging so the next prover/refactor re-points the
  crux's `ρ` source to Seam 1 (`base_change_mate_unit_value`), consistent with the blueprint now.

## Strategy-modifying findings
None. The mathematics (Stacks 02KH affine flat base change of R⁰f_*) is unchanged; this was purely a
blueprint-to-Lean reconciliation of the live route.
