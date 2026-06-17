# Blueprint Writer Directive

## Slug
fbc-reroute

## Target chapter
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (ONLY this chapter).

## Context (read the CURRENT Lean file first)

This iter a `refactor` subagent restructured
`AlgebraicJacobian/Cohomology/FlatBaseChange.lean`. The change is a **route swap** for the
section-level base-change mate computation. Read the current Lean file to confirm every claim
below before editing — the line numbers are approximate.

**What changed in Lean (all verified, file builds GREEN):**

1. **New axiom-clean declarations** (both already have matching blueprint blocks — confirm the
   prose matches, do not duplicate):
   - `AlgebraicGeometry.base_change_mate_domain_read` (~line 737) — the **domain read** of the
     section-level mate, `Γ(g'^*(f'_*(tilde M)))` read as `R' ⊗_R A ⊗_A M`. Proved axiom-clean
     (`propext, Classical.choice, Quot.sound`). Blueprint block: `lem:base_change_mate_domain_read`
     (~chapter line 1078).
   - `AlgebraicGeometry.pullback_fst_snd_specMap_tensor` (~line 709) — the two pullback cone legs
     equal the tensor-inclusion Spec-maps. Block: `lem:pullback_fst_snd_specMap_tensor` (~1046).

2. **The section identity was RE-ROUTED.** `base_change_mate_section_identity` (~Lean line 1550)
   now closes via
   `exact base_change_mate_gstar_transpose ψ φ M`
   using `base_change_mate_domain_read` (Θ_src) and `base_change_mate_codomain_read` (Θ_tgt)
   directly. It **no longer depends on** `base_change_mate_fstar_reindex` (the old Seam-2
   mate-`fstar`-reindex). Confirm: `grep "base_change_mate_fstar_reindex"` in the Lean file shows
   it appears ONLY inside comments and the self-referential `_legs`/public pair — nothing
   downstream consumes it.

3. **Consequence — the entire Seam-2 `fstar`-reindex apparatus is now DEAD CODE / SUPERSEDED:**
   - `AlgebraicGeometry.base_change_mate_fstar_reindex_legs` (~Lean 1333) — still carries a
     `sorry` (the old 6-iter "mate-unwinding crux"), but is now consumed by nothing live.
   - `AlgebraicGeometry.base_change_mate_fstar_reindex` (~Lean 1435) — public Seam-2 statement,
     now orphaned (referenced only in comments).
   - `_unitExpand` (~1273) and `_gammaDistribute` (~1304) — real, axiom-clean Lean decls, but they
     only ever fed the now-dead crux.
   - **`_eCancel`, `_affineUnit`, `_innerMatch` were NEVER stated in Lean** (verified: 0
     occurrences in the Lean file) — their blueprint blocks carry **broken `\lean{}` pins** to
     non-existent declarations and currently appear as phantom "ready-to-prove" frontier nodes in
     the dependency graph.

## Changes requested

The math is unchanged and correct (Stacks 02KH flat base change of `R⁰f_*`, affine case). This is a
**blueprint-to-Lean reconciliation** so the dependency graph reflects the live route. Do NOT add
`\leanok` anywhere (the deterministic sync phase owns it).

1. **Delete the three phantom blocks** whose `\lean{}` pins name non-existent decls:
   - `lem:base_change_mate_fstar_reindex_legs_eCancel` (~chapter 1690)
   - `lem:base_change_mate_fstar_reindex_legs_affineUnit` (~1758)
   - `lem:base_change_mate_fstar_reindex_legs_innerMatch` (~1795)
   First `grep` the chapter for `\uses{...eCancel...}` / `affineUnit` / `innerMatch` and remove
   those labels from any surviving `\uses{}` lists so no broken `\uses` remains.

2. **Mark the surviving `fstar`-reindex blocks as superseded.** For
   `lem:base_change_mate_fstar_reindex_legs` (~1828), `lem:base_change_mate_fstar_reindex` (~1902),
   `lem:base_change_mate_fstar_reindex_legs_unitExpand` (~1622),
   `lem:base_change_mate_fstar_reindex_legs_gammaDistribute` (~1662), and
   `lem:base_change_mate_codomain_read_legs` (~1179): keep each block (its `\lean{}` still matches a
   real decl) but rewrite the **prose** to state plainly that this apparatus is the *abandoned*
   first route to the section identity, **superseded by the direct domain-read route**
   (`lem:base_change_mate_domain_read` + `lem:base_change_mate_codomain_read` +
   `lem:base_change_mate_gstar_transpose`), and is retained only pending dead-code removal. Remove
   the stale "legs as free variables / substituting the defining equation" narrative from
   `lem:base_change_mate_codomain_read_legs` — the actual Lean decl still carries the leg-equality
   *proof binders* (`g' f' hfst hsnd`), so describe it accurately as "parametrised by the
   leg-equality proofs" rather than "free variables", and note this proof-parametrisation is
   exactly why the route was abandoned.

3. **Make the live route prose authoritative.** Update `lem:base_change_mate_section_identity`
   (~2208) prose so it derives the section identity from
   `lem:base_change_mate_domain_read` (domain read) + `lem:base_change_mate_codomain_read`
   (codomain read) + `lem:base_change_mate_gstar_transpose` (the `g^*`-transpose / Seam-3 crux),
   and fix its `\uses{}` (both statement-level and proof-level) to list exactly those three (drop
   any `\uses` of `lem:base_change_mate_fstar_reindex`). Confirm `lem:base_change_mate_gstar_transpose`
   (~2085) is stated as the live remaining crux feeding the section identity; if its `\uses{}` or
   prose still imply it sits *behind* the fstar-reindex Seam 2, correct it so the graph shows it as
   the live FBC frontier crux.

4. Verify after editing: no broken `\uses{}` anywhere in the chapter (`leandag build --json` or
   grep every `\uses{}` label against the chapter's `\label{}`s), and the only FBC `\lean{}` pins
   that fail to resolve to a Lean decl are NONE (the three phantom blocks are gone).

## Out of scope
- Do NOT touch any other chapter.
- Do NOT attempt to write a proof for `gstar_transpose`, the affine reduction, or FBC-B — those
  remain the prover's open targets.
- Do NOT delete the surviving (real-decl-backed) fstar-reindex blocks — only the three phantom
  ones. Physical removal of the dead Lean decls is a separate refactor next iter; this directive
  only reconciles the blueprint.
- Do NOT add `\leanok`. You MAY add `\mathlibok` only on genuine Mathlib dependency anchors (none
  expected new here).

## Citation discipline
Preserve all existing `% SOURCE` / `% SOURCE QUOTE` comments on the surviving blocks. No new source
material should be needed; `references/**` is in your write-domain only so you can spawn a
reference-retriever if you discover a genuine gap (not expected).
