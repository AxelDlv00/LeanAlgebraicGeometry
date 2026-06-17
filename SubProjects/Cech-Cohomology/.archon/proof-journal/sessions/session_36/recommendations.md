# Recommendations for iter-037 (plan agent)

## HIGH — restore 1:1 Lean↔blueprint coverage for the 3 new Route-B bricks (coverage debt)
`archon dag-query unmatched` shows 3 new `lean_aux` nodes with no blueprint entry (the 4th, dead
`CechAcyclic.affine`, is documented pre-existing debt). The planner must author blueprint blocks (or
bundle into the keystone's sub-lemma chain) and `\lean{}`-pin each:
- `AlgebraicGeometry.tilde_section_isLocalizedModule` — deps: Mathlib `tilde.toOpen`
  (`IsLocalizedModule` instance, Tilde.lean:115), `tilde.isIso_toOpen_top`, `tilde.toOpen_res`,
  `CategoryTheory.Iso.toLinearEquiv`, `IsLocalizedModule.of_linearEquiv_right`.
- `AlgebraicGeometry.section_isLocalizedModule_of_isIso_fromTildeΓ` — deps:
  `tilde_section_isLocalizedModule`, `qcoh_iso_tilde_sections` (this file),
  `TopCat.Sheaf.forget`, `NatIso.isIso_app_of_isIso`, `IsLocalizedModule.of_linearEquiv(_right)`.
- `AlgebraicGeometry.section_isLocalizedModule_of_presentation` — deps: the previous +
  Mathlib `isIso_fromTildeΓ_of_presentation`.
Natural structure: blueprint these as a `\uses`-linked chain under `lem:qcoh_section_isLocalizedModule`,
with `section_isLocalizedModule_of_presentation` as the *globally-presented keystone case* and
`section_isLocalizedModule_of_isIso_fromTildeΓ` as the *per-piece engine*. The keystone's `\uses`
should then cite these three.

## HIGH — expand the keystone blueprint sketch before re-dispatching the keystone lane
(lean-vs-blueprint-checker `qcohtilde`, major) The proof sketch for `lem:qcoh_section_isLocalizedModule`
collapses the entire remaining obstruction into "fix j and localize the situation at g_j". That clause
hides the `.over`→affine base-change bridge — the *sole* remaining blocker. Before any prover is sent
at the keystone:
- add `lem:modules_restrict_basicOpen` (and its successors) to the keystone's `\uses{}`;
- expand the sketch to name the three transfer steps explicitly (see the prover's decomposition in
  `task_results/QcohTildeSections.md` and the new `% NOTE (iter-036)` on the keystone block).
This is a blueprint-writer + effort-breaker task. The keystone reads "ready" in `archon dag-query
frontier` (effort 3048) but its `\uses` under-declares the real dependence — **do NOT dispatch a
prover at `qcoh_section_isLocalizedModule` until the sketch is expanded** (it would burn a lane on
absent-Mathlib geometry, the same trap flagged for the FALSE-ready frontier nodes in iter-035).

## MEDIUM — the keystone gap is genuinely absent-Mathlib infra; plan a multi-lane build, not a prover round
The unconditional `[IsQuasicoherent F]` case needs (per `task_results/QcohTildeSections.md`):
  1. `Γ(D(g), F)` ≅ `(F.over (D g)).Γ` — bridge `Scheme.Modules.over` to concrete sections.
  2. `F.over (D g)` global presentation when `D(g) ⊆ X_i` — restrict `QuasicoherentData` along the
     slice inclusion (`Presentation.map` under a left-adjoint restriction functor).
  3. `D(g) ≅ Spec R_g` base change identifying `F.over (D g)` as a `(Spec R_g).Modules`, so
     `section_isLocalizedModule_of_presentation` applies.
Lanes (1)+(2) are categorical/sheaf-theoretic; lane (3) is the affine base-change geometry (heaviest).
This is the same `.over`→affine bridge the iter-035 review flagged as absent (P1a L2
`tilde_restrict_basicOpen` / Stacks `lemma-widetilde-pullback`). Consider a mathlib-analogist
api-alignment pass on `Scheme.Modules.over` before committing the lane shapes — the prover hit
`InducedCategory` / `.val` and `.over` ergonomics repeatedly.

## MEDIUM — `.lean` docstring fixes (lean-auditor `iter036`, 2 major, comment-only)
Outside the review agent's write domain (`.lean` edits). For the next prover/refactor on the file:
- `QcohTildeSections.lean` L388: section header `/-! ## Route B local model -/` says "The **two**
  declarations here" — now three. Update count.
- `QcohTildeSections.lean` L489–492: `section_isLocalizedModule_of_presentation` docstring calls
  itself "**Route B keystone**" / "the keystone `qcoh_section_isLocalizedModule`". Since the
  unconditional keystone was intentionally never built, this overclaims — reword to "globally-presented
  case of the keystone". (A refactor subagent can land both as a 2-line comment edit alongside the
  next prover lane.)

## LOW
- Private helpers under `lem:isLocalizedModule_of_span_cover` `\lean{}` pin (7 names) are `private` in
  Lean → `sync_leanok` cannot verify their fully-qualified names (lvb minor). Harmless; the bundling
  keeps them DAG-visible. No action unless `sync_leanok` starts reporting them.
- ~14 long-line lint warnings + 5 unused `set … with h` witnesses in `QcohTildeSections.lean`
  (cosmetic; fold into any future refactor).

## Do NOT retry without a structural change
- `qcoh_section_isLocalizedModule` directly: blocked on absent-Mathlib `.over`→affine bridge. The
  prover correctly left it absent (no sorry). Re-dispatching it as a single prover lane will fail the
  same way — build the bridge sub-lemmas (lanes 1–3 above) FIRST.
- The FALSE-ready frontier nodes `lem:affine_cech_vanishing_qcoh` (02KG seed) and
  `lem:cech_augmented_resolution` (P5a) remain gated on the unconditional 01I8 keystone /
  `affine_serre_vanishing` — still not dispatchable despite reading "ready" (carried over from
  iter-035).

## Reusable proof patterns (also in PROJECT_STATUS Knowledge Base)
- Transport a Mathlib `IsLocalizedModule` instance from the underlying module `M` to its section group
  `Γ(⊤, M^~)`: build `eTop := (asIso (tilde.toOpen M ⊤)).toLinearEquiv`, use `toOpen_res`, finish with
  `IsLocalizedModule.of_linearEquiv_right (S) (f') eTop.symm` (S, f' explicit).
- `TopCat.Sheaf` is an `InducedCategory`: reach the underlying presheaf morphism via `Sheaf.forget`,
  NOT `.val`; component isos of a forgotten nat-iso via `NatIso.isIso_app_of_isIso` (not `inferInstance`).
- Avoid categorical `inv`/`Iso.eq_inv_comp` rewrites on `ModuleCat` morphisms (coercion mismatch);
  drop to the linear-map level with `LinearEquiv`s and prove equalities pointwise.
