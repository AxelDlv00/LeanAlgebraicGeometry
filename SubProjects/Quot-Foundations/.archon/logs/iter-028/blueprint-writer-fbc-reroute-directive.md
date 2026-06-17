# Blueprint-writer directive — FBC chapter (Seam-A routing reconciliation, the CHURNING corrective)

## Chapter
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — edit ONLY this file.

## Why this edit (context you must encode correctly)
The progress-critic flagged the FBC route CHURNING: 4 prover passes, 1 sorry closed, because **the
chapter's Seam-A routing narrative is now falsified by what the prover actually found**, so each prover
pass rediscovers the wall. You are fixing the chapter so it matches the live route. Do NOT add Lean
tactic strings (no `erw`/`rw`/`subst` in the prose) — describe the mathematics and the *order of
operations*; the tactic-level detail lives in the prover directive, not the blueprint.

### The factual correction (load-bearing)
The chapter currently (lines ~1986–2069, the "Seam A inline chain": `lem:base_change_mate_inner_unitReduce`
(A-1) → the three eCancel atoms (A-2) → `lem:base_change_mate_inner_value_eq` (A-3)) asserts that
`Γ_R(θ_in) = ρ` is derived **INLINE in the concrete pullback square** (legs = the literal projections
`pr_1`, `pr_2`), routed through the proved standalone atoms and **NOT** through the leg-parametrised
`lem:base_change_mate_fstar_reindex_legs`, which it labels "Superseded … retained only pending dead-code
removal" (line ~1727) and "retired … sorry-backed" (line ~1989).

**This is now false.** The iter-026 prover established:
- The **inline** distribution of the bare `(g')`-unit at the literal projection legs is **WALLED**: the
  projection leg `pr_1` is only *propositionally* equal to the composite `e ∘ Spec ι_A` (witnessed by
  `pullback_fst_snd_specMap_tensor`), not *definitionally* equal, so the unit-expansion step cannot be
  performed at the literal leg — every transport attempt hits a dependent-motive wall (the codomain read
  is a closed definition whose type bakes in the leg).
- The **viable** route is **through `lem:base_change_mate_fstar_reindex_legs`**: once the legs are carried
  as parameters and identified with their composite form `g' = e ∘ Spec ι_A` (where the equality is now
  definitional), the unit expansion (`lem:..._legs_unitExpand`) fires, the four-factor distribution
  (`lem:..._legs_gammaDistribute`) applies, the three proved eCancel atoms cancel against the unfolded
  codomain read (`lem:base_change_mate_codomain_read_legs`), and the lone surviving affine `(Spec ι_A)`-unit
  goes to ρ via Seam 1. Therefore `_legs`/`fstar_reindex` are **NOT dead code** — they are the realization
  path for Seam A `inner_value_eq`, which is live (consumed by `lem:base_change_mate_gstar_transpose` in the
  domain-read route). They are superseded only as a *direct* route to `lem:base_change_mate_section_identity`
  (that now goes through domain-read + codomain-read + `gstar_transpose`); the *inner value* obligation
  still routes through them.

## Task
1. **Reconcile the routing narrative.** Rewrite the prose of the Seam-A chain (the `% --- Seam 3, the
   inline inner-value chain` comment block ~1986–1995 and the affected blocks) so it states the live
   route: Seam A `inner_value_eq` is realised **through `base_change_mate_fstar_reindex_legs`** (leg
   substitution → unit expansion → four-factor distribution → eCancel telescoping → Seam 1 → ρ), and
   explicitly records that the inline-at-literal-legs distribution is walled (legs only propositionally
   equal — a dependent-motive obstruction), so the proof must pass to the leg-parametrised form first.
   Keep the existing four-factor formula and the three eCancel atoms — they are correct and reused; only
   the *plumbing* (inline vs via-`_legs`) changes.
2. **Un-supersede `_legs` / `fstar_reindex` for the inner-value obligation.** Update the "Superseded"/"
   retired … sorry-backed" framing (lines ~1727–1732, ~1989–1995) to: superseded as a *direct* route to
   `section_identity`, but the live realization of Seam A `inner_value_eq` (hence not dead code). Make the
   `\uses{}` of `lem:base_change_mate_inner_value_eq` point at `lem:base_change_mate_fstar_reindex` (which
   `\uses` `..._legs`) so the graph reflects the true dependency.
3. **Give the residual telescoping a single named sub-lemma target.** The remaining ~100-LOC work is step
   (iii) link (3) of the `_legs` proof: cancel the four distributed Γ-factors against the unfolded codomain
   read, using the three already-proved atoms (`base_change_mate_inner_eCancel_eUnit`,
   `..._pushforwardComp`, `..._pullbackComp`) and leaving the lone affine `(Spec ι_A)`-unit. State this as
   its own lemma block — e.g. `lem:base_change_mate_inner_eCancel_assemble` — with `\lean{}` left
   un-pinned or pinned to the subsuming `base_change_mate_fstar_reindex_legs` (mirror the existing
   convention used by `lem:base_change_mate_inner_unitReduce`, which pins the subsuming theorem and carries
   a `% LEAN INTERNAL` note), and `\uses{}` listing the three atoms + `codomain_read_legs` +
   `gammaMap_pushforwardComp_hom_eq_id` + Seam 1 `base_change_mate_unit_value`. This is the single closeable
   target the prover will attack. Its informal proof = the link-(3) telescoping already written in the
   `_legs` step (iii); lift it into this block as the standalone statement.

## Out of scope / do not touch
- Do NOT add `\leanok` anywhere (sync_leanok's job). The `\mathlibok` marker is not relevant here.
- Do NOT rewrite the domain-read route (`gstar_transpose`, Seams B/C) — those are correct and closed.
- Do NOT touch the affine/FBC-B globalization blocks.
- No Lean tactic strings in the prose. Keep the existing `% SOURCE`/`% SOURCE QUOTE` citation comments.
