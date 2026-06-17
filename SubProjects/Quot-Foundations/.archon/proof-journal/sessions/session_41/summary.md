# Session 41 (iter-041) — Review Summary

## Metadata
- Iteration: 041; session_41 reviews iter-041.
- Prover model: claude-opus-4-8.
- Files touched by provers: `AlgebraicJacobian/Picard/QuotScheme.lean` (7 new decls; gap1 CLOSED),
  `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (in-proof Γ-collapse partial; no new decls).
- Sorry count: QUOT 4 → 4 (only the 4 frozen protected iter-176 scaffold stubs remain),
  FBC 4 → 4 (the `_legs_conj` keystone still open). Net active sorry unchanged; +7 axiom-clean decls.
- Build: `lake build AlgebraicJacobian.Picard.QuotScheme` exit 0 (8317 jobs). FlatBaseChange compiles
  0 errors. Both QUOT headline decls `lean_verify` = `{propext, Classical.choice, Quot.sound}`
  (independently re-checked this phase). blueprint-doctor: 0 findings. `sync_leanok` iter 41 sha
  `ea57394`: +6 `\leanok`, 0 removed (Picard_QuotScheme only).

## Headline — QUOT gap1 CLOSED axiom-clean
The ~14-iter QUOT gap1 arc (section-localization descent for quasi-coherent modules on `Spec R`,
Hartshorne II.5.3 / Stacks `lemma-invert-f-sections`, built WITHOUT the global `QCoh ≃ Mod`
equivalence) is complete. 7 new non-private declarations:

| line | declaration | role |
|------|-------------|------|
| 2027 | `image_basicOpen_of_affine` | opaque-`j` image-of-basic-open geometry |
| 2038 | `compositeBasicOpenImmersion_image_basicOpen` | thin concrete instantiation |
| 2051 | `image_basicOpen_eq_inf` | image as `(j ''ᵁ ⊤) ⊓ basicOpen g` |
| 2075 | `section_localization_hfr_aux` | the heavy **opaque-`j`** core (combiner + eqToHom transport) |
| 2198 | `section_localization_hfr_basicOpen` | TOP producer (thin wrapper at the composite immersion) |
| 2240 | `isLocalizedModule_basicOpen_descent` | **keystone** (cover-descent at the QCoh cover) |
| 2261 | `isIso_fromTildeΓ_of_isQuasicoherent` | **gap1** (feeds keystone into the assembler) |

### Targets attempted — QUOT

**`isIso_fromTildeΓ_of_isQuasicoherent` (gap1) — SOLVED.** One-liner feeding the keystone into the
existing assembler `isIso_fromTildeΓ_of_isLocalizedModule_restrict`. Axiom-clean.

**`isLocalizedModule_basicOpen_descent` (keystone) — SOLVED.** Instantiates
`isLocalizedModule_basicOpen_descent_of_basicOpen_cover` at
`exists_finite_basicOpen_cover_le_quasicoherentData`, feeding the basic-open Hfr producer
`section_localization_hfr_basicOpen` per cover overlap. Axiom-clean.

**`section_localization_hfr_aux` (the heavy core) — SOLVED after a refactor.**
- Attempt 1 (inline into the concrete-`j` wrapper): the form-coercion
  `have RESULT' : IsLocalizedModule (powers f) ((modulesSpecToSheaf.obj M).presheaf.map ii.op).hom := RESULT`
  → `(deterministic) timeout at whnf, maximum number of heartbeats (3200000)`. The kernel unfolds the
  concrete triple-composite immersion `j = compositeBasicOpenImmersion`. Raising the budget to 1.6M
  then 3.2M did not help.
- Attempt 2 (the fix): push the entire heavy assembly into an **opaque-`j` helper**
  `section_localization_hfr_aux {R S} (M) (j : Spec S ⟶ Spec R) [IsOpenImmersion j] (h : IsIso (fromTildeΓ ((pullback j).obj M))) …`;
  keep the concrete instantiation in the thin wrapper `section_localization_hfr_basicOpen`. With `j`
  opaque the SAME coercion is a cheap `rfl`. `set_option maxHeartbeats 1600000` covers the multi-step
  combiner + `eqToHom` open-transport. Axiom-clean. This mirrors the same opaque-`j` device used for
  `image_basicOpen_of_affine`.
- The localization-combiner intertwiner: `IsLocalizedModule.of_linearEquiv_right αU` then
  `of_linearEquiv αV.symm` over the `eqToHom` open-transport equivs needed the function-side composite
  spelled explicitly; the final identity closes via a forward naturality square `hsq` using only
  forward `eqToHom` isos (both `rfl`-identified), sidestepping a failing `ModuleCat.hom_ext` path.
- The analogist `quot-sigma-rebasing` defeqs were all confirmed `rfl` (the `ModuleCat S`-vs-`Γ(Spec S,⊤)`
  structure-sheaf re-basing is definitional, both at `⊤` and at `D(f')`); `he₁` closes in one line via
  `gammaPullbackImageIso_hom_semilinear`, `he₂` needs `Scheme.Hom.appIso_inv_naturality`.

**`image_basicOpen_of_affine` (+ 2 siblings) — SOLVED.** Attempt with the concrete immersion +
`rw` chain timed out at `isDefEq` (200000, then 800000 even with
`backward.isDefEq.respectTransparency false`); the opaque-`j` statement closes cheaply via
`← basicOpen_eq_of_affine` + `Scheme.image_basicOpen`. Concrete form is a thin instantiation.

**Plan's (c)/(d) lemmas** (`gamma_image_iso_semilinear_top`, `flocus_section_scalar_tower`) were NOT
built standalone — their content is inlined into `section_localization_hfr_aux`. No separate blocks needed.

## FBC — `base_change_mate_fstar_reindex_legs_conj` (the i=0 crux) — BLOCKED (route exhausted in-loop)

This was the FINAL in-loop FBC conjugate round (Fallback B), per the kill-criterion armed iter-039/040.

- **Attempt 1 (verified partial — committed):** after `rw [base_change_mate_codomain_read_legs_conj]`,
  a Γ-collapse `simp only [Functor.map_comp, Category.assoc, gammaMap_pushforwardComp_inv_eq_id,
  gammaMap_pushforwardCongr_hom]` distributes `Γ = moduleSpecΓFunctor` over the inner composite and
  collapses 2 of 3 transparent coherences (`(pushforwardComp f' (Spec ψ)).inv → 𝟙`;
  `(pushforwardCongr comm).hom → eqToHom`), reducing the goal to the cross-layer core. File compiles 0
  errors. This is genuine forward progress.
- **Attempt 2 (new sub-blocker):** the remaining `(pushforwardComp g' (Spec φ)).hom` factor is
  `rfl`-equal to `𝟙` (same `rfl` proof as the `.inv` form, `gammaMap_pushforwardComp_hom_eq_id`) yet —
  asymmetrically with the `.inv` factor — neither `simp` nor `rw [gammaMap_pushforwardComp_hom_eq_id]`
  matches its discrimination-tree pattern (`Γ.map ((pushforwardComp ?a ?b).hom.app ?M)` reported "not
  found"/"unused" though visibly present). A diamond-safe `change`/`conv`-to-`𝟙` is needed (NOT `erw` —
  forbidden under the X.Modules diamond).
- **The HEAVY crux (unchanged across iters 037–041):** S2 — recognise the cross-layer composite as a
  `(conjugateEquiv adjL adjR).symm β` value — requires building composite `adjL`/`adjR` spanning
  strictly more adjunction layers than conj-2d's two-pair model, plus the assembled `β`. This is a
  large bespoke construction; it is NOT a missing Mathlib lemma (all conjugate-calculus atoms in hand).
- **Disposition:** per the armed protocol, the conjugate route is exhausted in-loop — NO further
  conjugate/analogist rounds. The pivot is the affine **tilde-transport** route bypassing
  `gstar_transpose` (needs a new blueprint section + scaffold + user steer). See recommendations §0.

## Subagent dispositions (this review phase)
- **lean-auditor `iter041`** (both files): **0 must-fix / 0 major / 0 minor.** All 7 new QUOT decls
  fully proved + honest; the opaque-`j` device is instantiated honestly (no hidden defeq shortcut); the
  `maxHeartbeats 1600000` on the aux is justified (not masking fragility); no `test_sorry_marker` or
  debug residue. FBC: the new `simp` stage carries an honest "PARTIAL" comment, correctly acknowledges
  the residual `sorry`, and the `gstar_transpose` scaffold correctly warns against citing the
  sorry-backed `base_change_mate_fstar_reindex`. Report: `task_results/lean-auditor-iter041.md`.
- **lean-vs-blueprint-checker `quot-iter041`**: 0 must-fix / **4 major** / 2 minor. The 3 substantive
  gap1 decls (`isLocalizedModule_basicOpen_descent`, `isIso_fromTildeΓ_of_isQuasicoherent`,
  `section_localization_hfr_basicOpen`) have correct signatures, axiom-clean proofs, matching `\leanok`.
  MAJOR: 3 sub-lemma blocks (`lem:composite_immersion_flocus_basicOpen`,
  `lem:gamma_image_iso_semilinear_top`, `lem:flocus_section_scalar_tower`) pin NON-EXISTENT decls (content
  absorbed inline into `section_localization_hfr_aux`); re-pin is NOT safe without a SPLIT → planner task
  (recommendations §2). MAJOR: G1-core (`isLocalizedModule_basicOpen_of_isQuasicoherent`) now a 2-line
  corollary of gap1 — schedule it (recommendations §3). MINOR (review-handled this phase): 3 stale
  `% NOTE: does NOT yet exist` comments. Report: `task_results/lean-vs-blueprint-checker-quot-iter041.md`.
- **lean-vs-blueprint-checker `fbc-iter041`**: **0 must-fix / 0 major / 3 minor.** `_legs_conj` is honestly
  marked (statement `\leanok`, no proof `\leanok` — correct, sorry open); all 3 legs (conj-2b/2c/2d)
  correctly pinned + sorry-free; the blueprint sketch accurately encodes Fallback B; the Lean roadmap comment
  does not cite the sorry-backed `base_change_mate_fstar_reindex` as proven. Minor: blueprint-prose
  suggestions only (note the `.hom`-factor discrimination-tree asymmetry; clarify the collapse-first ordering)
  — planner/blueprint-writer, not blocking. Report: `task_results/lean-vs-blueprint-checker-fbc-iter041.md`.

## Blueprint markers updated (manual)
- `Picard_QuotScheme.tex`, `lem:section_localization_descent`: replaced stale
  `% NOTE: ...isLocalizedModule_basicOpen_descent does NOT yet exist` roadmap with
  `% NOTE: BUILT axiom-clean iter-041` (decl now exists + `\leanok`).
- `Picard_QuotScheme.tex`, `lem:qcoh_affine_isIso_fromTildeΓ`: replaced stale
  `% NOTE: the Lean decl does NOT yet exist` with `% NOTE: BUILT axiom-clean iter-041`.
- `Picard_QuotScheme.tex`, `lem:section_localization_hfr_basicOpen`: replaced stale
  `% NOTE: ...does NOT yet exist` with a `% NOTE: BUILT axiom-clean iter-041` note (wrapper over the
  opaque-`j` core; sub-lemmas absorbed inline).
- `Picard_QuotScheme.tex`, `lem:composite_immersion_flocus_basicOpen` /
  `lem:gamma_image_iso_semilinear_top` / `lem:flocus_section_scalar_tower`: added
  `% NOTE (iter-041): STALE PIN — no standalone decl …; content absorbed inline; planner to split/re-pin`
  (kept the `\lean{}` pins rather than re-pointing — re-pin would falsely `\leanok` a bundled/absent block).
- No `\mathlibok` added: all 7 new decls are project proofs, not Mathlib re-exports.
- No `\lean{...}` corrections applied: the keystone + gap1 + hfr_basicOpen pins already match; the 3
  mismatched pins are deferred to the planner (split decision), not a clean rename.

## Key findings / patterns
- **The opaque-immersion device is the load-bearing trick for the whole gap1 close.** A heavy
  `IsLocalizedModule` assembly whose final form-coercion involves a concrete composite open immersion
  triggers a >3.2M-heartbeat `whnf` runaway (the kernel unfolds the immersion). Pushing the assembly
  into a helper that takes the immersion as an OPAQUE hypothesis makes the same coercion a cheap `rfl`;
  instantiate concretely in a thin wrapper. This pattern resolved both `image_basicOpen_of_affine` and
  `section_localization_hfr_aux` and was the reason gap1 had churned ~5 iters.
- **FBC conjugate-reframing idiom is exhausted** — 5 dedicated iters (037–041) could not assemble the
  multi-layer composite-adjunction recognition. Not mathematically dead; the next move is a
  structurally-different route, not another conjugate attempt.
