# Session 236 (review of iter-236)

## Metadata
- **Iteration / session:** iter-236 / session_236
- **Model:** claude-opus-4-8
- **Prover lanes:** 2 — `StalkTensor.lean` (d.2 critical path, mathlib-build) and
  `FlatBaseChange.lean` (engine, mathlib-build). Both `done`.
- **Headline:** **d.2 critical-path ISO `stalkTensorIso` is CLOSED, axiom-clean.** The
  varying-ring stalk–tensor commutation `(A ⊗ᵖ B).stalk x ≅ A_x ⊗_{R_x} B_x` — the single
  Mathlib-absent ingredient gating the unconditional associator
  (`isLocallyInjective_whiskerLeft_of_W`) ⇒ `thm:pic_commgroup` — landed in one round
  (stages iv balancing → reverse map → v bundle), after 3 consecutive iters of staged build.
- **File sorry deltas:** StalkTensor.lean 0 → 0 (+6 axiom-clean decls). FlatBaseChange.lean
  2 → 2 (+3 axiom-clean support decls; no sorry closed, none added).
- **Verification (first-hand):** `lean_verify` on `PresheafOfModules.stalkTensorIso` and
  `AlgebraicGeometry.gammaPushforwardIso` → both `{propext, Classical.choice, Quot.sound}`.
  StalkTensor.lean grep `sorry|admit|native_decide|axiom` empty. StalkTensor imported into the
  canonical build via `Picard/TensorObjSubstrate.lean`.

## Target: `PresheafOfModules.stalkTensorIso` (SOLVED — d.2 critical path)

Type (verified by lean-vs-blueprint-checker):
`(stalk (Monoidal.tensorObj A B).presheaf x) ≃ₗ[↑(R.stalk x)] (A.stalk x ⊗_{R.stalk x} B.stalk x)`
— exactly the blueprint `lem:stalk_tensor_commutation` statement.

Three attempts (all succeeded, in sequence — see milestones for code):

1. **`revBihom_balanced`** (the iter-235 residual). The balancing condition
   `revBihom (r•m) n = revBihom m (r•n)` feeding `liftAddHom`. Proved at the **W-section
   level** over the `CommRingCat` carrier `R(W)` (where `R' = R`, so `TensorProduct.smul_tmul`
   synthesises with no carrier mixing), transported down via `congrArg ((tensorObj A B).map
   j.op)` + `erw [tensorObj_map_tmul]`. The iter-235 wall (`PresheafOfModules.map_smul` adds a
   `restrictScalars` wrapper → `smul_tmul` synth fails at `W ⊓ W` over `RingCat`) was REAL but
   AVOIDABLE by working at the W level, not `W ⊓ W`.
   - **Critical gotcha:** a STANDALONE bare-`⊗ₜ[R.obj (op Z)]` lemma fails `Module` synth
     (`A.presheaf.obj` vs `A.obj`). FIX: wrap the equality in `germ` (`revBihom_balanced_germ`),
     which supplies the expected module type.
2. **`stalkTensorRev` / `stalkTensorRev_germ_tmul`** — descend `revBihom` through
   `TensorProduct.liftAddHom`; germ char via `liftAddHom_tmul` + `revBihom_germ_tmul` + the new
   helper `germ_tensorObj_map_tmul` (germ of a restricted simple tensor over a single `j`).
3. **`stalkTensorIso`** — `LinearEquiv` bundling forward (`stalkTensorLinearMap`) and reverse
   (`stalkTensorRev`); `left_inv`/`right_inv` by `TensorProduct.induction_on` after
   `germ_exist`, tmul cases via the germ-char lemmas.
   - **Gotchas:** (1) `induction_on` yields tmuls over the `RingCat` carrier while the germ-char
     lemmas use `R.obj` (CommRingCat) → bridge with `erw` (defeq), not `rw`. (2) zero/add cases:
     `simp only [map_zero/map_add]` makes NO progress on `ConcreteCategory.hom`-applied terms →
     use `erw [map_zero…]`/`erw [map_add…]`.

**lean-auditor verdict:** NON-VACUOUS — `toFun`/`invFun` are genuine forward/reverse maps;
`left_inv`/`right_inv` close by distinct named lemmas, not a degenerate `rfl` or wrong-carrier
coincidence. No rogue axioms. (`task_results/lean-auditor-ts236.md`.)
**lean-vs-blueprint-checker verdict:** PASS — type matches blueprint exactly; all five stages
map to the Lean construction; 3 minor (non-blocking) findings.
(`task_results/lean-vs-blueprint-checker-stalktensor-ts236.md`.)

## Target: `gammaPushforwardIso` / `gammaPushforwardTildeIso` / `globalSectionsIso_hom_comp_specMap_appTop` (SOLVED — FBC Γ-fragment, engine)

The Γ-fragment iso `Γ((Spec φ)_* N) ≅ restrictScalars φ (Γ N)` — the keystone the iter-234/235
attempts could NOT build (carrier wall) — landed axiom-clean via the **element-free route (b)**.

- **Route (a) confirmed DEAD** (documented in file): the `LinearEquiv.toModuleIso`/`AddEquiv.refl`
  approach typechecks (annotate `≃ₗ[(R : Type u)]`, NO `respectTransparency` — supersedes
  iter-234) and `map_smul'` reduces exactly to `A • m = B • m`, but EVERY element-level finisher
  hits the alias-vs-reduced-type `HSMul`-synth wall (`congr 1` → `whnf` timeout; `congr 2` →
  `RingHom`+`HEq`). **Do NOT retry any section-level finisher.**
- **Route (b) succeeded:** both sides peel by `rfl` to nested `restrictScalars` towers over the
  common global-section module; reconcile via `restrictScalarsComp'App` × 2 + `eqToIso` of the
  ring equation `globalSectionsIso_hom_comp_specMap_appTop` (proved by
  `globalSectionsIso = ΓSpecIso.inv` (rfl) + `ΓSpecIso_inv_naturality`). NO element-level `smul`.

**Still open:** the object iso `pushforward_spec_tilde_iso` is NOT added. Reduced to one named
obligation — **quasi-coherence of `(Spec φ)_*(tilde M)`** — with three concrete attack routes
(route (iii), direct basic-open `isIso_of_isIso_app_of_isBasis` via `IsLocalizedModule`, yields
the object iso AND QC at once). The deep `flatBaseChange_pushforward_isIso` (Čech + flatness)
stays a documented sorry per PROGRESS.md.

**lean-auditor verdict:** the three new decls are genuine (not `eqToIso rfl` masking a gap), the
2 sorry sites honestly scoped, 0 must-fix. **lean-vs-blueprint-checker verdict:** PASS on
`\leanok`/sorry classification, but two MAJOR blueprint-side gaps (below).

## Critical-path status — ingredient built, consumer not yet wired

`stalkTensorIso` is the d.2 INGREDIENT. Its consumer `isLocallyInjective_whiskerLeft_of_W` lives
in `TensorObjSubstrate.lean` (still sorry-bearing, 23 sorry-lines in that file). The
critical-path counter at `thm:pic_commgroup` has **not dropped yet** — the next unit is the
consumer wiring (associator → `thm:pic_commgroup`), which is now UNBLOCKED for the first time
in ~19 iters. This is genuine, verified convergence: the long-dodged bottleneck is gone.

## Blueprint markers updated (manual)
- `Picard_TensorObjSubstrate.tex`, `lem:stalk_tensor_commutation`: rewrote the stale `% NOTE`
  block — it claimed `stalkTensorIso` "is not yet assembled" and listed completed stages
  (iii)–(v) as "remaining". Replaced with an accurate iter-236 status note recording the iso is
  complete and axiom-clean with all five stages assembled. (No `\leanok` touched.)

## `\leanok` sync nuance (NOT laundering)
`sync_leanok-state.json` = `{iter: 236, sha: 931a5756, added: 1}` — sync ran for this tree. The
**proof block** of `lem:stalk_tensor_commutation` (line 1900) carries `\leanok`; the **statement
block** (line 1850) does not yet. This is *under*-marking (a pending sync gap the checker also
noted), not laundering — the declaration is genuinely axiom-clean. No agent should touch
`\leanok`; the next `sync_leanok` run resolves it.

## Subagent findings (full reports in task_results/, archived to logs/iter-236/)
- **lean-auditor ts236:** 0 must-fix; 3 major comment-quality issues (stale module header in
  StalkTensor; wrong helper name `revBihom_balanced_section` in `revBihom_balanced` docstring;
  iter-numbered STATUS/UPDATE history block in FlatBaseChange section header). → recommendations.
- **lean-vs-blueprint-checker stalktensor:** PASS; 3 minor (unpinned `stalkTensorRev` etc.).
- **lean-vs-blueprint-checker flatbasechange:** PASS on markers; 2 MAJOR blueprint gaps — (a) the
  3 new FBC decls have no `\lean{}` pins; (b) `lem:pushforward_spec_tilde_iso`'s proof sketch has
  a **circular QC dependency** (QC of the pushforward presented as a corollary of the object iso
  when it is actually a prerequisite). → recommendations for the plan agent's blueprint-writer.

## Blueprint-doctor
CLEAN — no orphan chapters, no broken `\ref`/`\uses`, no new `axiom` declarations.

## Recommendations for next session
See `recommendations.md`. Headline: **dispatch the associator-wiring prover lane** to consume
`stalkTensorIso` and close `thm:pic_commgroup`; dispatch a blueprint-writer for
`Cohomology_FlatBaseChange.tex` (3 pins + circular-QC fix) before any FBC object-iso prover
round.
