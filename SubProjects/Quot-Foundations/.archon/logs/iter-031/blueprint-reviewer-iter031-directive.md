# blueprint-reviewer directive — iter-031 (whole-blueprint audit, HARD GATE)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`). Per-chapter completeness + correctness
checklist with `complete:` / `correct:` verdicts and must-fix-this-iter findings.

This iter's chapters under active prover work (the HARD GATE must clear these before provers run):
- `Cohomology_FlatBaseChange.tex` — the five `_legs` link blocks were reconciled this iter: L1+L2 merged
  into `lem:base_change_mate_fstar_reindex_legs_link_distributeCollapse` (pins the existing axiom-clean
  Lean decl); L3/L4/L5 (`_link_cancelEUnit`/`_cancelPullbackComp`/`_survivor`) are forward-reference
  blocks the iter-031 prover will build via the term-mode wrapper recipe. Confirm: no dangling
  `_link_distribute`/`_link_collapseComp` names remain; the three wrapper blocks have precise,
  formalizable term-mode proofs; the assembly/narrative `\uses{}` lists are consistent.
- `Picard_QuotScheme.tex` — new 6-block sub-section for the over-site/open-subspace sheaf equivalence
  (bridge C topological layer, all 6 decls landed axiom-clean iter-030); `lem:over_restrict_iso` expanded
  to a 4-step decomposition with step 2 (ring-sheaf identification) as the named next obstacle. Confirm the
  step-2 sketch is detailed enough to guide the prover (iter-030 checker flagged the prior sketch as too
  thin), and that the 6 infra blocks have accurate `\uses{}`.
- `Picard_GrassmannianCells.tex` — new standalone block `lem:gr_cocycle_phi_id` (the rotated Φ=id ring
  cocycle identity, the `cocycle`-field ingredient), wired into `def:gr_glued_scheme`. Confirm its proof
  sketch (IsLocalization.ringHom_ext → generators → reuse `lem:gr_cocycle_imageMatrix_eq`) is sound and
  `def:gr_glued_scheme` is prover-ready for the `theGlueData`/`Grassmannian.scheme` assembly.

Report the per-chapter checklist, must-fix items (if any), broken `\uses{}`/isolated nodes, and any
unstarted-phase blueprint proposals. Do not pass back a `\leanok` recommendation (that is the deterministic
sync's job).
